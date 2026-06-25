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
package me.zhengjie.modules.security.config;

import cn.hutool.core.util.HexUtil;
import cn.hutool.core.util.RandomUtil;
import cn.hutool.crypto.digest.SM3;
import org.springframework.security.crypto.password.PasswordEncoder;
import java.nio.charset.StandardCharsets;

/**
 * SM3 国密哈希 PasswordEncoder，替代 BCryptPasswordEncoder
 * <p>
 * 本次代码改动描述：将密码存储哈希从 BCrypt 迁移为国密 SM3 + 随机盐 + 5000 轮迭代，
 * 编码格式为 {sm3}saltHex:hashHex，实现 Spring Security PasswordEncoder 接口
 *
 * @author jiarong
 * @date 2026-06-26
 **/
public class SM3PasswordEncoder implements PasswordEncoder {

    /** 编码前缀，为未来 DelegatingPasswordEncoder 平滑迁移预留 */
    private static final String PREFIX = "{sm3}";
    /** 盐长度（字节），128 位超过国标要求的 64 位 */
    private static final int SALT_BYTES = 16;
    /** SM3 迭代轮数，远超国标 GM/T 0002-2012 建议的 1024 轮 */
    private static final int ITERATIONS = 5000;
    /** SM3 哈希输出长度（字节） */
    private static final int SM3_OUTPUT_BYTES = 32;

    /**
     * 编码密码
     * 算法：H0 = SM3(rawSalt || rawPassword)，H1 = SM3(H0)，…，H5000 = SM3(H4999)
     * 格式：{sm3}saltHex:hashHex
     *
     * @param rawPassword 明文密码
     * @return 编码后的密码字符串
     */
    @Override
    public String encode(CharSequence rawPassword) {
        byte[] salt = RandomUtil.randomBytes(SALT_BYTES);
        byte[] hash = iteratedSM3(salt, rawPassword.toString().getBytes(StandardCharsets.UTF_8));
        return PREFIX + HexUtil.encodeHexStr(salt) + ":" + HexUtil.encodeHexStr(hash);
    }

    /**
     * 验证密码
     *
     * @param rawPassword     明文密码
     * @param encodedPassword 编码后的密码字符串
     * @return 是否匹配
     */
    @Override
    public boolean matches(CharSequence rawPassword, String encodedPassword) {
        if (encodedPassword == null || !encodedPassword.startsWith(PREFIX)) {
            // 旧 BCrypt 格式（$2a$10$...）或无效格式，返回 false
            return false;
        }
        try {
            String content = encodedPassword.substring(PREFIX.length());
            int colonIndex = content.indexOf(':');
            if (colonIndex <= 0) {
                return false;
            }
            String saltHex = content.substring(0, colonIndex);
            String storedHashHex = content.substring(colonIndex + 1);

            byte[] salt = HexUtil.decodeHex(saltHex);
            byte[] computedHash = iteratedSM3(salt, rawPassword.toString().getBytes(StandardCharsets.UTF_8));
            String computedHashHex = HexUtil.encodeHexStr(computedHash);

            return storedHashHex.equals(computedHashHex);
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * 5000 轮迭代 SM3 哈希
     * H0 = SM3(salt || password)，H_i = SM3(H_{i-1}) for i = 1..ITERATIONS
     *
     * @param salt         随机盐字节数组
     * @param passwordBytes 密码 UTF-8 字节数组
     * @return 最终迭代结果的字节数组（32 字节）
     */
    private byte[] iteratedSM3(byte[] salt, byte[] passwordBytes) {
        SM3 sm3 = new SM3();
        // 首轮：salt + password
        byte[] input = new byte[salt.length + passwordBytes.length];
        System.arraycopy(salt, 0, input, 0, salt.length);
        System.arraycopy(passwordBytes, 0, input, salt.length, passwordBytes.length);
        byte[] result = sm3.digest(input);
        // 后续迭代
        for (int i = 1; i < ITERATIONS; i++) {
            result = sm3.digest(result);
        }
        return result;
    }

    /**
     * 静态工具方法：对指定明文生成 SM3 哈希，用于手动生成 SQL 种子数据的密码哈希
     * 可单独运行此 main 方法生成种子用户的新密码
     */
    public static void main(String[] args) {
        SM3PasswordEncoder encoder = new SM3PasswordEncoder();
        String hash = encoder.encode("123456");
        System.out.println("admin/test 用户新密码哈希：");
        System.out.println(hash);
        // 验证
        System.out.println("验证 123456：" + encoder.matches("123456", hash));
        System.out.println("验证 wrong：" + encoder.matches("wrong", hash));
    }
}
