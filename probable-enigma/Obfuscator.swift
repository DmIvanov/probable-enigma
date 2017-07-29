//
//  Obfuscator.swift
//  probable-enigma
//
//  Created by Dmitrii on 28/07/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import Foundation


enum ObfuscationType {
    case Base64
    case XOR
    case Base64_XOR

    func encode(key: [UInt8]? = nil, plainString: String) -> ([UInt8]?) {
        switch self {
        case .Base64:
            let plainData = plainString.data(using: .utf8)
            let base64String = plainData?.base64EncodedString()
            let encoded = [UInt8](base64String!.utf8)
            return encoded
        case .XOR:
            guard let key = key else {return(nil)}
            let bytes = [UInt8](plainString.utf8)
            var encoded = [UInt8]()
            for b in bytes.enumerated() {
                encoded.append(b.element ^ key[b.offset % key.count])
            }
            return encoded
        case .Base64_XOR:
            guard let key = key else {return(nil)}
            let plainData = plainString.data(using: .utf8)
            guard plainData != nil else {return(nil)}
            let base64String = plainData!.base64EncodedString()
            let bytes = [UInt8](base64String.utf8)
            var encoded = [UInt8]()
            for b in bytes.enumerated() {
                encoded.append(b.element ^ key[b.offset % key.count])
            }
            return encoded
        }
    }

    func decode(obfuscated: [UInt8], key: [UInt8]?) -> String? {
        switch self {
        case .Base64:
            let obfuscatedString = String(bytes: obfuscated, encoding: .utf8)!
            let decodedData = Data(base64Encoded: obfuscatedString)
            let decodedStr = String(data: decodedData!, encoding: .utf8)
            return decodedStr
        case .XOR:
            guard let key = key else {return(nil)}
            var decoded = [UInt8]()
            for b in obfuscated.enumerated() {
                decoded.append(b.element ^ key[b.offset % key.count])
            }

            let decodedStr = String(bytes: decoded, encoding: .utf8)!
            return decodedStr
        case .Base64_XOR:
            guard let key = key else {return(nil)}
            var decoded = [UInt8]()
            for b in obfuscated.enumerated() {
                decoded.append(b.element ^ key[b.offset % key.count])
            }
            let str = String(bytes: decoded, encoding: .utf8)!
            let decodedData = Data(base64Encoded: str)
            let decodedString = String(data: decodedData!, encoding: .utf8)
            return decodedString
        }
    }
}


class Obfuscator: NSObject {

    fileprivate let keyBytes: [UInt8]?
    fileprivate let obfuscatedBytes: [UInt8]
    fileprivate let type: ObfuscationType

    init(key: String? = nil, plainString: String, type: ObfuscationType = .Base64_XOR) {
        if key != nil {
            self.keyBytes = [UInt8](key!.utf8)
        } else {
            self.keyBytes = nil
        }
        self.type = type
        self.obfuscatedBytes = type.encode(key: keyBytes, plainString: plainString)!
    }

    init(obfuscator: Obfuscator) {
        self.keyBytes = obfuscator.keyBytes
        self.obfuscatedBytes = obfuscator.obfuscatedBytes
        self.type = obfuscator.type
    }

    func plainString() -> String {
        return type.decode(obfuscated: obfuscatedBytes, key: keyBytes)!
    }
}


extension Obfuscator: NSCopying {

    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Obfuscator(obfuscator: self)
        return copy
    }
}
