import { sm2 } from 'sm-crypto'

// 公钥 Hex 格式：04||x||y，共 130 个十六进制字符
// 使用 Sm2Utils.main() 生成，取其中 "公钥（Hex）" 一行
const publicKey = '04a8fec5f3b4a4356028d61ffbc50edff288594ec3b88b2d66ac0542a69339ae53f6ddc0cf4d771316985726149eed6b9bb09f547ce5e992dd1e3d8abedbde4f4c'

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
  bytes.forEach(b => { binary += String.fromCharCode(b) })
  return btoa(binary)
}
