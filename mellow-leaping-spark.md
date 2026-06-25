# 密码加密算法迁移：RSA→SM2 / BCrypt→SM3

## Context

将用户密码的传输加密从 RSA-1024 替换为国密 SM2（椭圆曲线非对称加密），将存储哈希从 BCrypt 替换为国密 SM3（哈希算法）+ 盐 + 迭代。项目已依赖 Hutool 5.8.35，其 `cn.hutool.crypto` 包内置了 SM2/SM3/SM4 支持，但需要额外添加 BouncyCastle 作为算法提供者（Hutool 将其声明为 optional，不会自动传递，必须显式添加）。

## 涉及模块

- `eladmin-common`：SM2/SM3 工具类、配置属性类
- `eladmin-system`：安全配置、登录/用户控制器
- `eladmin-web`：前端加密工具、登录页、API 调用
- `sql/`：种子数据迁移

---

## 一、后端改动

### 1.1 添加 BouncyCastle 依赖

**文件：** `eladmin/eladmin-common/pom.xml`

```xml
<dependency>
    <groupId>org.bouncycastle</groupId>
    <artifactId>bcprov-jdk18on</artifactId>
    <version>1.78.1</version>
</dependency>
```

> **注意：**
> 1. BouncyCastle 从 1.71 起将 `bcprov-jdk15on` 更名为 `bcprov-jdk18on`（要求 JDK ≥ 1.8）。本项目 Java 版本为 1.8，使用 `jdk18on` 坐标。**经验证 `bcprov-jdk18on` 1.78.1 在 Maven Central 存在**，建议用 1.78.1 修复 CVE-2024-29857、CVE-2024-30172。
> 2. Hutool 的 SM2/SM3 需要 BouncyCastle 作为底层 Provider，但 Hutool 将其声明为 optional，不会自动传递，必须显式添加。

### 1.2 新建 SM2 工具类

**文件（新建）：** `eladmin/eladmin-common/src/main/java/me/zhengjie/utils/Sm2Utils.java`

替代 `RsaUtils.java`。基于 Hutool 的 `cn.hutool.crypto.asymmetric.SM2`：

```java
import cn.hutool.core.util.HexUtil;
import cn.hutool.crypto.SecureUtil;
import cn.hutool.crypto.SmUtil;
import cn.hutool.crypto.asymmetric.KeyType;
import cn.hutool.crypto.asymmetric.SM2;
import org.bouncycastle.jce.interfaces.ECPublicKey;
import java.security.KeyPair;
import java.util.Base64;

public class Sm2Utils {

    /**
     * 私钥解密 —— 后端解密前端传来的 SM2 密文
     * @param privateKeyBase64 Base64 编码的私钥（PKCS#8 格式）
     * @param encryptedBase64  Base64 编码的 SM2 密文（前端 sm-crypto 输出，含 04 前缀）
     * @return 明文
     */
    public static String decryptByPrivateKey(String privateKeyBase64, String encryptedBase64) {
        byte[] privateKeyBytes = Base64.getDecoder().decode(privateKeyBase64);
        // 传入私钥，公钥传 null 即可（解密只需私钥）
        SM2 sm2 = SmUtil.sm2(privateKeyBytes, null);
        return sm2.decryptStr(encryptedBase64, KeyType.PrivateKey);
    }

    /**
     * 公钥加密 —— 通用公钥加密（可用于测试/工具）
     * @param publicKeyBase64 Base64 编码的公钥（X.509 格式）
     * @param plainText 明文
     * @return Base64 编码的密文
     */
    public static String encryptByPublicKey(String publicKeyBase64, String plainText) {
        byte[] publicKeyBytes = Base64.getDecoder().decode(publicKeyBase64);
        SM2 sm2 = SmUtil.sm2(null, publicKeyBytes);
        return sm2.encryptBase64(plainText, KeyType.PublicKey);
    }

    /**
     * 生成 SM2 密钥对
     * @return 密钥对，含 Base64 格式（后端配置用）和 Hex 格式（前端用）
     */
    public static Sm2KeyPair generateKeyPair() {
        // 使用 SecureUtil 生成 SM2 密钥对
        KeyPair pair = SecureUtil.generateKeyPair("SM2");

        // 后端存储：PKCS#8 私钥 + X.509 公钥，Base64 编码
        String privateKeyBase64 = Base64.getEncoder().encodeToString(
            pair.getPrivate().getEncoded());
        String publicKeyBase64 = Base64.getEncoder().encodeToString(
            pair.getPublic().getEncoded());

        // 前端使用：提取原始 EC 点（65 字节：04||x||y），Hex 编码
        ECPublicKey bcPub = (ECPublicKey) pair.getPublic();
        byte[] rawPubKey = bcPub.getQ().getEncoded(false); // false=uncompressed 格式
        String publicKeyHex = HexUtil.encodeHexStr(rawPubKey); // 130 hex 字符，04 开头

        return new Sm2KeyPair(privateKeyBase64, publicKeyBase64, publicKeyHex);
    }

    /**
     * main() 用于手动生成密钥对，同时输出 Base64（后端配置用）和 Hex（前端用）
     */
    public static void main(String[] args) {
        Sm2KeyPair keyPair = generateKeyPair();
        System.out.println("私钥（Base64，配置到 application.yml 的 sm2.private-key）：");
        System.out.println(keyPair.getPrivateKey());
        System.out.println();
        System.out.println("公钥（Base64，配置到 application.yml 的 sm2.public-key）：");
        System.out.println(keyPair.getPublicKey());
        System.out.println();
        System.out.println("公钥（Hex，配置到前端 sm2Encrypt.js 的 publicKey）：");
        System.out.println(keyPair.getPublicKeyHex());
        System.out.println();
        // 自检：后端加密→解密，验证一致性
        String plain = "123456";
        String encrypted = encryptByPublicKey(keyPair.getPublicKey(), plain);
        String decrypted = decryptByPrivateKey(keyPair.getPrivateKey(), encrypted);
        System.out.println("后端自检：" + (plain.equals(decrypted) ? "通过" : "失败"));
    }

    public static class Sm2KeyPair {
        private final String privateKey;
        private final String publicKey;
        private final String publicKeyHex;
        // 构造函数、getter 省略...
    }
}
```

> **Hutool SM2 API 关键说明（均已通过外部文档验证）：**
> 1. **密钥生成**：必须使用 `SecureUtil.generateKeyPair("SM2")` 生成密钥对，`SmUtil.sm2()` 无参不保证生成密钥。验证依据：Hutool 官方文档及多个技术博客均使用此模式。
> 2. **密钥格式**：`pair.getPrivate().getEncoded()` 返回 PKCS#8 DER 编码，`pair.getPublic().getEncoded()` 返回 X.509 DER 编码。`SmUtil.sm2()` 可接受这些编码格式构造 SM2 实例。
> 3. **前端公钥**：必须从 Java `ECPublicKey` 中提取原始 EC 点（`bcPub.getQ().getEncoded(false)`），而非直接使用 `getEncoded()`（后者是 X.509 包装格式，前端 sm-crypto 无法识别）。验证依据：多个跨语言 SM2 联调文章确认此转换方法。
> 4. **密文排列**：Hutool SM2 默认 C1C3C2（符合 GM/T 0009-2012），前端 sm-crypto 使用 `cipherMode=1` 与之匹配。
> 5. **密文编码**：`sm2.encryptBase64()` 返回 Base64，`sm2.decryptStr()` 接受 Base64 输入。

### 1.3 新建 SM2 配置属性类

**文件（新建）：** `eladmin/eladmin-common/src/main/java/me/zhengjie/config/properties/Sm2Properties.java`

替代 `RsaProperties.java`：

```java
@Component
public class Sm2Properties {
    public static String privateKey;
    public static String publicKey;

    @Value("${sm2.private-key}")
    public void setPrivateKey(String privateKey) { Sm2Properties.privateKey = privateKey; }

    @Value("${sm2.public-key}")
    public void setPublicKey(String publicKey) { Sm2Properties.publicKey = publicKey; }
}
```

> SM2 私钥和公钥都需配置：私钥用于解密前端传来的密码，公钥用于 `Sm2Utils.main()` 自检及后端加密工具场景。`@Value` 支持 Spring 宽松绑定。

### 1.4 新建 SM3 PasswordEncoder

**文件（新建）：** `eladmin/eladmin-system/src/main/java/me/zhengjie/modules/security/config/SM3PasswordEncoder.java`

实现 Spring Security 的 `PasswordEncoder` 接口：

- **编码格式：** `{sm3}{32位盐的Hex}:{64位SM3哈希的Hex}`
  - `{sm3}` 前缀为未来引入 `DelegatingPasswordEncoder` 做平滑迁移预留
  - `:` 分隔盐与哈希
- **盐：** 随机 16 字节（128 位），以 Hex 编码存储（32 个十六进制字符）
- **迭代方式：** 5000 轮迭代 SM3（远超国标 GM/T 0002-2012 建议的 1024 轮）
  - 算法：`H0 = SM3(rawSalt || rawPassword)`，`H1 = SM3(H0)`，…，`H5000 = SM3(H4999)`
  - `rawSalt` 为原始 16 字节随机盐，`rawPassword` 为密码的 UTF-8 字节
  - 存储值为 `{sm3}` + Hex(rawSalt) + `:` + `H5000` 的 Hex 编码
  - 每轮将上一轮输出作为下一轮 SM3 的输入，盐只在首轮参与
- **encode(rawPassword)：** 生成随机盐，执行 5000 轮迭代，拼接为 `{sm3}saltHex:hashHex`
- **matches(rawPassword, encodedPassword)：** 解析存储的盐，用相同迭代次数计算后比较
- **matches 需兼容旧 BCrypt 格式：** 检查 encodedPassword 是否以 `{sm3}` 开头；如果不是（即仍为 BCrypt `$2a$10$...` 格式），应直接返回 `false`

> **为什么不使用 DelegatingPasswordEncoder 做平滑迁移？** 现有系统中只有 admin/test 两个种子用户，默认密码都是 `123456`，直接替换 SQL 种子数据的哈希值即可。如果生产环境已有大量用户需平滑迁移，可后续引入 `DelegatingPasswordEncoder` 同时支持 `{bcrypt}` 和 `{sm3}` 两种编码。

### 1.5 修改安全配置

**文件：** `eladmin/eladmin-system/src/main/java/me/zhengjie/modules/security/config/SpringSecurityConfig.java`

- 将 `passwordEncoder()` Bean 的返回值从 `new BCryptPasswordEncoder()` 改为 `new SM3PasswordEncoder()`
- 移除 `org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder` 导入（行 31）
- 添加 `SM3PasswordEncoder` 导入

> **已验证：** 全项目搜索确认 `BCryptPasswordEncoder` 除本文件外无其他引用。

### 1.6 修改登录控制器

**文件：** `eladmin/eladmin-system/src/main/java/me/zhengjie/modules/security/rest/AuthController.java`

- 导入从 `RsaProperties` / `RsaUtils` 改为 `Sm2Properties` / `Sm2Utils`
- 第 83 行：`RsaUtils.decryptByPrivateKey(RsaProperties.privateKey, ...)` → `Sm2Utils.decryptByPrivateKey(Sm2Properties.privateKey, ...)`
- `passwordEncoder.matches()` 调用不变（接口一致，只是底层实现变为 SM3）

### 1.7 修改用户控制器

**文件：** `eladmin/eladmin-system/src/main/java/me/zhengjie/modules/system/rest/UserController.java`

- 导入从 `RsaProperties` / `RsaUtils` 改为 `Sm2Properties` / `Sm2Utils`
- `updateUserPass()` 方法（第 157-158 行）：两处 `RsaUtils.decryptByPrivateKey(RsaProperties.privateKey, ...)` → `Sm2Utils.decryptByPrivateKey(Sm2Properties.privateKey, ...)`
- `updateUserEmail()` 方法（第 188 行）：一处 RSA 解密改为 SM2 解密
- `passwordEncoder.encode()` / `.matches()` 调用不变
- `createUser()`（第 112 行）和 `resetPwd()`（第 173 行）中的 `passwordEncoder.encode("123456")` 无需改动——Bean 已切换为 SM3PasswordEncoder

### 1.8 修改配置文件

**文件：** `eladmin/eladmin-system/src/main/resources/config/application.yml`

删除：
```yaml
#密码加密传输，前端公钥加密，后端私钥解密
rsa:
  private_key: MIIBUwIBADANBgkqhkiG9w0BAQEFAASCAT0wggE5AgEAAkEA0vfv...
```

新增：
```yaml
# SM2 密码加密传输，前端公钥加密，后端私钥解密
sm2:
  private-key: <Sm2Utils.main() 生成的 Base64 私钥（PKCS#8）>
  public-key: <Sm2Utils.main() 生成的 Base64 公钥（X.509）>
```

> **已验证：** `application-dev.yml`、`application-prod.yml`、`application-quartz.yml` 中均无 RSA 配置项，无需额外修改。

### 1.9 更新 SQL 种子数据

**文件：**
- `sql/eladmin.sql`
- `sql/eladmin_postgresql.sql`

将 admin 和 test 用户的 `password` 字段从 BCrypt 哈希（`$2a$10$...`）替换为 `123456` 的 SM3 哈希值（通过 SM3PasswordEncoder 提前生成）。

MySQL (eladmin.sql) 中 admin 用户的行（约第 556 行）和 test 用户的行（约第 557 行），以及 PostgreSQL (eladmin_postgresql.sql) 中对应的两行。

格式示例：`{sm3}a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6:d41d8cd98f00b204e9800998ecf8427e0123456789abcdef0123456789abcdef`

> **⚠️ 重要：更新后必须清除 Redis 用户缓存。** `UserDetailsServiceImpl` 会在首次登录时将用户信息（含密码哈希）缓存到 Redis，之后登录直接读缓存不查数据库。直接用 SQL 改库不会触发 `UserCacheManager.cleanUserCache()`。缓存键为 `user_login_cache:{username}`（定义在 `LoginProperties.cacheKey`）。清除方式：
> ```bash
> redis-cli -n 1 DEL user_login_cache:admin user_login_cache:test
> # 如果没有 redis-cli，重启 Redis 服务亦可（缓存存在内存中）
> ```

### 1.10 （可选）清理旧 RSA 文件

以下文件可以安全删除或保留：
- `eladmin-common/.../utils/RsaUtils.java`
- `eladmin-common/.../config/properties/RsaProperties.java`

> **已验证：** 全项目搜索确认 `RsaUtils` 和 `RsaProperties` 仅被 `AuthController` 和 `UserController` 引用，这两个控制器在步骤 1.6、1.7 中已完成迁移。Alipay 支付模块（`eladmin-tools`）使用 Alipay SDK 自带的 RSA 签名验证，不依赖项目中的 `RsaUtils`/`RsaProperties`。

---

## 二、前端改动

### 2.1 安装新依赖 / 移除旧依赖

**文件：** `eladmin-web/package.json`

- 移除：`"jsencrypt": "^3.0.0-rc.1"`
- 新增：`"sm-crypto": "^0.4.0"`

执行 `npm install` 更新 lock 文件。

### 2.2 新建 SM2 加密工具

**文件（新建）：** `eladmin-web/src/utils/sm2Encrypt.js`

替代 `eladmin-web/src/utils/rsaEncrypt.js`：

```javascript
import { sm2 } from 'sm-crypto'

// 公钥 Hex 格式：04||x||y，共 130 个十六进制字符
// 使用 Sm2Utils.main() 生成，取其中 "公钥（Hex）" 一行
const publicKey = '<新生成的SM2公钥Hex>'

// cipherMode: 1 = C1C3C2（国标），需与后端 Hutool SM2 保持一致
const CIPHER_MODE = 1

/**
 * SM2 加密
 * @param {string} txt - 明文
 * @returns {string} Base64 编码的密文（与 Hutool SM2.decryptStr() 兼容）
 */
export function encrypt(txt) {
  // sm-crypto 的 doEncrypt 返回 Hex 字符串，不含 04 前缀
  let hexCipher = sm2.doEncrypt(txt, publicKey, CIPHER_MODE)
  // 必须补上 04 前缀（ASN.1 未压缩 EC 点标识），否则后端 Hutool 解密失败
  if (!hexCipher.startsWith('04')) {
    hexCipher = '04' + hexCipher
  }
  // Hex → Base64，匹配后端 Hutool SM2.decryptStr() 的期望输入
  return hexToBase64(hexCipher)
}

/**
 * Hex 字符串转 Base64
 */
function hexToBase64(hexStr) {
  const bytes = new Uint8Array(
    hexStr.match(/.{2}/g).map(byte => parseInt(byte, 16))
  )
  let binary = ''
  bytes.forEach(b => binary += String.fromCharCode(b))
  return btoa(binary)
}
```

> **关键兼容性要点（联调时必须逐项验证）：**
> 1. **04 前缀（已验证）：** `sm-crypto` 的 `doEncrypt()` 输出**不含** `04` 前缀（输出为 128 hex chars），后端 Hutool/BC 解密**需要** `04` ASN.1 未压缩点标识（需 130 hex chars）。代码中做了防御性判断，如果已有前缀则不重复添加。验证依据：多个 Hutool+Vue 联调实战文章确认此规则——"前端加密加04，后端解密补04"。
> 2. **Hex→Base64：** `sm-crypto` 默认输出 Hex（128 chars），`decryptStr()` 期望 Base64 输入，需手动转换。
> 3. **cipherMode：** `1` = C1C3C2（国标 GM/T 0009-2012 默认），后端 Hutool SM2 也使用此排列。**如果解密失败，检查 cipherMode 是否需要改为 `0`（C1C2C3）。**
> 4. **密钥格式（已验证）：** 后端 `getEncoded()` 返回 PKCS#8（私钥）/ X.509（公钥）DER 编码 → Base64 存储；前端 sm-crypto 需要原始 EC 点 `04||x||y` → Hex 展示。`Sm2Utils.main()` 使用 `bcPub.getQ().getEncoded(false)` 提取原始点，同时输出两种格式，不要混用。
> 5. **公钥配置位置：** 将 Hex 格式公钥填入此文件 `publicKey` 变量，Base64 格式公私钥填入 `application.yml`。

### 2.3 修改登录页

**文件：** `eladmin-web/src/views/login.vue`

- 第 45 行：`import { encrypt } from '@/utils/rsaEncrypt'` → `import { encrypt } from '@/utils/sm2Encrypt'`
- Cookie 缓存机制（第 127 行 `user.password !== this.cookiePass`）：逻辑保持不变即可。迁移后用户浏览器中如存有旧的 RSA 加密 Cookie，与明文密码不匹配，会触发 SM2 重新加密；新 Cookie 将存储 SM2 密文，后续登录正常。

### 2.4 修改用户 API 调用

**文件：** `eladmin-web/src/api/system/user.js`

- 第 2 行：`import { encrypt } from '@/utils/rsaEncrypt'` → `import { encrypt } from '@/utils/sm2Encrypt'`
- `updatePass()`（第 44-53 行）和 `updateEmail()`（第 56-65 行）中的 `encrypt()` 调用保持不变（函数签名一致，入参、返回值类型不变）

### 2.5 清理旧前端文件

- 删除 `eladmin-web/src/utils/rsaEncrypt.js`

---

## 三、验证方案

### 3.1 单元测试

- **`Sm2UtilsTest`：** 验证 SM2 加解密往返一致性
  - `encryptByPublicKey(pubKey, plain)` → `decryptByPrivateKey(priKey, cipher)` → 得到原文
  - 测试空字符串、中文、长文本
- **`Sm3PasswordEncoderTest`：**
  - 相同密码两次 `encode()` 结果不同（盐不同）
  - `matches(原文, encode结果)` 返回 `true`
  - `matches(错误密码, encode结果)` 返回 `false`
  - `matches(原文, BCrypt旧格式)` 返回 `false`（不会崩溃）

### 3.2 前后端联调验证

1. 用 `Sm2Utils.main()` 生成新的 SM2 密钥对，得到三行输出：
   - 私钥（Base64）→ 配置到 `application.yml` 的 `sm2.private-key`
   - 公钥（Base64）→ 配置到 `application.yml` 的 `sm2.public-key`
   - 公钥（Hex）→ 配置到前端 `sm2Encrypt.js` 的 `publicKey`
2. 启动后端，用 API 工具先确认 `/auth/code` 正常获取验证码
3. 在后端用 `Sm2Utils.encryptByPublicKey()` 预加密一段测试密码，再用 `decryptByPrivateKey()` 解密，确认后端自身加解密链路通
4. **前后端 SM2 互通验证（关键）：** 用浏览器控制台调用 `encrypt("test")`，将 Base64 密文在后端用 `Sm2Utils.decryptByPrivateKey()` 解密，验证：
   - 解密后可得到原文 `"test"` ✓
   - 如果解密失败，检查：①cipherMode（1 vs 0）  ②04 前缀是否正确  ③Hex→Base64 转换是否正确
5. 确认互通后，完成完整登录流程（admin/123456）
6. 验证修改密码、重置密码、修改邮箱（需密码确认）功能均正常

### 3.3 回归验证

- 用新的 SM3 哈希更新 SQL 种子数据后，重新初始化数据库
- 使用默认密码 `123456` 登录 admin 和 test 账号
- 确认所有密码相关功能：登录 / 修改密码 / 重置密码 / 修改邮箱

---

## 四、不需要修改的文件

> 以下均已通过源码审查确认无需改动。

| 文件 | 原因 |
|------|------|
| `AuthUserDto.java` | 只承载字符串，密码字段不变 |
| `UserPassVo.java` | 只承载字符串（oldPass/newPass），不关心加密算法 |
| `JwtUserDto.java` | 只委托 `user.getPassword()`，不关心编码格式 |
| `User.java` | `password` 字段不变，只是存储内容从 BCrypt 变为 SM3 |
| `UserMapper.java` / `UserMapper.xml` | SQL 不变，只是存储的哈希值不同 |
| `UserServiceImpl.java` | 只传递已编码的密码，`createUser()` 和 `resetPwd()` 通过 `passwordEncoder` Bean 编码，不关心具体算法 |
| `TokenProvider.java` | JWT Token 生成逻辑与密码编码无关 |
| Alipay 相关文件 | 使用 Alipay SDK 自带的 RSA2（`alipay-sdk-java 4.38.4.ALL`），与用户密码体系无关 |
| `EncryptUtils.java` (DES) | 独立 DES 工具类，不用于用户密码 |
| `store/modules/user.js` | 只调用 login API，不直接处理加密 |
| `application-dev.yml` / `application-prod.yml` / `application-quartz.yml` | 均不含 RSA 配置项 |

---

## 五、关键风险点与缓解措施

| 风险 | 级别 | 缓解措施 |
|------|------|---------|
| `sm-crypto` `doEncrypt()` 输出不含 `04` 前缀，后端 Hutool 解密失败 | **高** | `sm2Encrypt.js` 中显式补 `04` 前缀，带防御性判断避免重复添加。经验证此为 `sm-crypto` 默认行为 |
| cipherMode 不匹配（C1C3C2 vs C1C2C3）导致跨端解密失败 | **高** | 两端均设 `1`（C1C3C2），联调第 4 步专门验证；如失败先排查此项 |
| 前后端密钥格式不同（Hex 原始点 vs Base64 PKCS#8/X.509） | **高** | `Sm2Utils.main()` 使用 `getQ().getEncoded(false)` 提取原始 EC 点，同时输出两种格式 |
| BouncyCastle 1.78.1 有已知 CVE（CVE-2024-29857/30172 已修复，但可能有其他低危漏洞） | **中** | 本项目 SM2/SM3 仅用于密码传输和哈希，不对外暴露 BC 接口；如安全审计严格可升级至最新 1.84 |
| `sm-crypto` Hex 输出 vs Hutool Base64 期望不一致 | **中** | `sm2Encrypt.js` 中显式做 Hex→Base64 转换 |
| BouncyCastle 版本与 Alipay SDK 或其他模块的传递依赖冲突 | **中** | 全项目搜索确认无直接 BC 依赖；如运行时冲突用 `mvn dependency:tree` 排查，必要时 `<exclusions>` |
| 旧 Cookie 中 RSA 密文导致首次登录异常 | **低** | login.vue 的 `cookiePass` 比较逻辑天然兜底——不匹配则重新加密 |
| SM3 5000 轮迭代性能 | **低** | 登录时约增加 5–50ms，可忽略；如性能敏感可降至 2048 轮 |
| `SecureUtil.generateKeyPair("SM2")` 在不同 Hutool 版本行为差异 | **低** | 已锁定 Hutool 5.8.35；如升级版本需回归验证密钥生成 |
