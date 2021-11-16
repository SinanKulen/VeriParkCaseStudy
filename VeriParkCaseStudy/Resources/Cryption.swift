//
//  Cryption.swift
//  VeriParkCaseStudy
//
//  Created by Sinan Kulen on 8.11.2021.
//


import Foundation
import CryptoSwift

private var aesKey: String? {
    return UserDefaults.standard.string(forKey: "aesKey")
}

private var aesIV: String? {
    return UserDefaults.standard.string(forKey: "aesIV")
}

extension String {
   func aesDecrypt() -> String {
       // let aesKey = aesKey, let aesIV = aesIV else { return ""}
        let key = [UInt8](base64: aesKey ?? "")
        let iv = [UInt8](base64: aesIV ?? "")
        let aes = try? AES(key: key, blockMode: CBC(iv: iv))
        
        let cipherdata = Data(base64Encoded: self)
        let ciphertext = try? aes?.decrypt(cipherdata!.bytes)
        guard let token = String(bytes:ciphertext!, encoding:String.Encoding.utf8) else {return "-"}
        return token
    }
    func aesEncryption() -> String? {
        let key = [UInt8](base64: aesKey ?? "")
        let iv = [UInt8](base64: aesIV ?? "")
        let aes = try? AES(key: key, blockMode: CBC(iv: iv))
        
        let cipherText = try? aes?.encrypt(Array(self.utf8))
        let base64String = cipherText?.toBase64()
        return base64String
    }
}
