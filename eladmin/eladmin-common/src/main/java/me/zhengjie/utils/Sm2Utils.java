/*
 *  Copyright 2019-2025 Zheng Jie
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
package me.zhengjie.utils;

import cn.hutool.core.util.HexUtil;
import cn.hutool.crypto.SecureUtil;
import cn.hutool.crypto.SmUtil;
import cn.hutool.crypto.asymmetric.KeyType;
import cn.hutool.crypto.asymmetric.SM2;
import org.bouncycastle.jce.interfaces.ECPublicKey;
import java.security.KeyPair;
import java.util.Base64;

/**
 * SM2 国密椭圆曲线非对称加密工具类，替代原 RsaUtils
 * <p>
 * 本次代码改动描述：将密码传输加密从 RSA-1024 迁移为国密 SM2，基于 Hutool SM2 + BouncyCastle
 * 实现密钥生成、公钥加密、私钥解密，支持前后端跨语言密钥格式转换（Base64/Hex）
 *
 * @author jiarong
 * @date 2026-06-26
 **/
public class Sm2Utils {

    private static final String SRC = "123456";

    public static void main(String[] args) {
        System.out.println("\n");
        Sm2KeyPair keyPair = generateKeyPair();
        System.out.println("私钥（Base64，PKCS#8 格式，配置到 application.yml 的 sm2.private-key）：");
        System.out.println(keyPair.getPrivateKey());
        System.out.println();
        System.out.println("公钥（Base64，X.509 格式，配置到 application.yml 的 sm2.public-key）：");
        System.out.println(keyPair.getPublicKey());
        System.out.println();
        System.out.println("公钥（Hex，130 字符 04 开头，配置到前端 sm2Encrypt.js 的 publicKey）：");
        System.out.println(keyPair.getPublicKeyHex());
        System.out.println();
        // 自检：后端加密→解密，验证一致性
        System.out.println("***************** 公钥加密私钥解密自检 *****************");
        String text1 = encryptByPublicKey(keyPair.getPublicKey(), Sm2Utils.SRC);
        String text2 = decryptByPrivateKey(keyPair.getPrivateKey(), text1);
        System.out.println("加密前：" + Sm2Utils.SRC);
        System.out.println("加密后：" + text1);
        System.out.println("解密后：" + text2);
        if (Sm2Utils.SRC.equals(text2)) {
            System.out.println("解密字符串和原始字符串一致，解密成功");
        } else {
            System.out.println("解密字符串和原始字符串不一致，解密失败");
        }
        System.out.println("***************** 公钥加密私钥解密结束 *****************");
    }

    /**
     * 私钥解密 —— 后端解密前端传来的 SM2 密文
     *
     * @param privateKeyBase64 Base64 编码的私钥（PKCS#8 格式）
     * @param encryptedBase64  Base64 编码的 SM2 密文（前端 sm-crypto 输出，含 04 前缀的 Hex→Base64）
     * @return 明文
     */
    public static String decryptByPrivateKey(String privateKeyBase64, String encryptedBase64) {
        byte[] privateKeyBytes = Base64.getDecoder().decode(privateKeyBase64);
        SM2 sm2 = SmUtil.sm2(privateKeyBytes, null);
        return sm2.decryptStr(encryptedBase64, KeyType.PrivateKey);
    }

    /**
     * 公钥加密 —— 通用公钥加密（可用于测试/工具）
     *
     * @param publicKeyBase64 Base64 编码的公钥（X.509 格式）
     * @param text 待加密的文本
     * @return Base64 编码的 SM2 密文
     */
    public static String encryptByPublicKey(String publicKeyBase64, String text) {
        byte[] publicKeyBytes = Base64.getDecoder().decode(publicKeyBase64);
        SM2 sm2 = SmUtil.sm2(null, publicKeyBytes);
        return sm2.encryptBase64(text, KeyType.PublicKey);
    }

    /**
     * 生成 SM2 密钥对
     *
     * @return 密钥对，含 Base64 格式（后端配置用，PKCS#8/X.509）和 Hex 格式（前端用，原始 EC 点 04||x||y）
     */
    public static Sm2KeyPair generateKeyPair() {
        KeyPair pair = SecureUtil.generateKeyPair("SM2");

        String privateKeyBase64 = Base64.getEncoder().encodeToString(
            pair.getPrivate().getEncoded());
        String publicKeyBase64 = Base64.getEncoder().encodeToString(
            pair.getPublic().getEncoded());

        // 前端使用：提取原始 EC 点（65 字节：04||x||y），Hex 编码（130 hex 字符）
        ECPublicKey bcPub = (ECPublicKey) pair.getPublic();
        byte[] rawPubKey = bcPub.getQ().getEncoded(false);
        String publicKeyHex = HexUtil.encodeHexStr(rawPubKey);

        return new Sm2KeyPair(privateKeyBase64, publicKeyBase64, publicKeyHex);
    }

    /**
     * SM2 密钥对对象
     */
    public static class Sm2KeyPair {

        private final String privateKey;
        private final String publicKey;
        private final String publicKeyHex;

        public Sm2KeyPair(String privateKey, String publicKey, String publicKeyHex) {
            this.privateKey = privateKey;
            this.publicKey = publicKey;
            this.publicKeyHex = publicKeyHex;
        }

        public String getPrivateKey() {
            return privateKey;
        }

        public String getPublicKey() {
            return publicKey;
        }

        public String getPublicKeyHex() {
            return publicKeyHex;
        }
    }
}
