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


class Obfuscator {

    // MARK: - Properties
    fileprivate let keyBytesPointer: UnsafeMutableBufferPointer<UInt8>?
    fileprivate let obfuscatedBytesPointer: UnsafeMutableBufferPointer<UInt8>

    fileprivate let type: ObfuscationType

    // MARK: - Lyfecycle
    init(key: String? = nil, plainString: String, type: ObfuscationType = .Base64_XOR) {
        let keyBytes = [UInt8](key!.utf8)
        if key != nil {
            self.keyBytesPointer = Obfuscator.createUnsafeArray(array: keyBytes)
        } else {
            self.keyBytesPointer = nil
        }
        self.type = type
        let obfuscatedBytes = type.encode(key: keyBytes, plainString: plainString)!
        self.obfuscatedBytesPointer = Obfuscator.createUnsafeArray(array: obfuscatedBytes)
    }

    init(obfuscator: Obfuscator) {
        self.type = obfuscator.type
        let obfuscatedBytes = Array<UInt8>(obfuscator.obfuscatedBytesPointer)
        self.obfuscatedBytesPointer = Obfuscator.createUnsafeArray(array: obfuscatedBytes)
        if obfuscator.keyBytesPointer != nil {
            let keyBytes = Array<UInt8>(obfuscator.keyBytesPointer!)
            self.keyBytesPointer = Obfuscator.createUnsafeArray(array: keyBytes)
        } else {
            self.keyBytesPointer = nil
        }
    }

    deinit {
        // cleaning the memory
        obfuscatedBytesPointer.baseAddress?.deinitialize(count: obfuscatedBytesPointer.count)
        obfuscatedBytesPointer.baseAddress?.deallocate(capacity: obfuscatedBytesPointer.count)
        if keyBytesPointer != nil {
            keyBytesPointer!.baseAddress?.deinitialize(count: keyBytesPointer!.count)
            keyBytesPointer!.baseAddress?.deallocate(capacity: keyBytesPointer!.count)
        }
    }


    // MARK: - Public
    func plainString() -> String {
        let obfuscatedBytes = Array<UInt8>(obfuscatedBytesPointer)
        let keyBytes = (keyBytesPointer != nil) ? Array<UInt8>(keyBytesPointer!) : nil
        return type.decode(obfuscated: obfuscatedBytes, key: keyBytes)!
    }

    /*
    func stringPointer() -> UnsafeMutablePointer<String> {
        let string = plainString()
        let ptr = UnsafeMutablePointer<String>.allocate(capacity: 1)
        ptr.initialize(to: string)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            ptr.deinitialize()
            ptr.deallocate(capacity: 1)
        }
        return ptr
    }
     */


    // MARK: - Private
    private static func createUnsafeArray(array: [UInt8]) -> UnsafeMutableBufferPointer<UInt8> {
        let count = array.count
        let pointer = UnsafeMutablePointer<UInt8>.allocate(capacity: count)
        pointer.initialize(to: 0, count: count)
        for i in 0..<count {
            pointer.advanced(by: i).pointee = array[i]
        }
        return UnsafeMutableBufferPointer(start: pointer, count: count)
    }
}


extension Obfuscator: NSCopying {

    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Obfuscator(obfuscator: self)
        return copy
    }
}
