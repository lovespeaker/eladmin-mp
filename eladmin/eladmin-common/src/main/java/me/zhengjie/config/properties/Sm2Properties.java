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
package me.zhengjie.config.properties;

import lombok.Data;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
 * SM2 国密配置属性，替代原 RsaProperties
 * <p>
 * 本次代码改动描述：将 RSA 配置迁移为 SM2 国密配置，新增 publicKey 属性用于后端测试/工具场景的加密操作
 *
 * @author jiarong
 * @date 2026-06-26
 **/
@Data
@Component
public class Sm2Properties {

    public static String privateKey;

    public static String publicKey;

    @Value("${sm2.private-key}")
    public void setPrivateKey(String privateKey) {
        Sm2Properties.privateKey = privateKey;
    }

    @Value("${sm2.public-key}")
    public void setPublicKey(String publicKey) {
        Sm2Properties.publicKey = publicKey;
    }
}
