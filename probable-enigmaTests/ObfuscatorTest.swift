//
//  ObfuscatorTest.swift
//  probable-enigma
//
//  Created by Dmitrii on 29/07/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import XCTest
@testable import probable_enigma


class ObfuscatorTest: XCTestCase {

    private let key = NSFileVersion.description() + UIMotionEffect.description() // random classes to make a key
    private let plainString = "plainString"

    override func setUp() {
        super.setUp()
    }

    func testXORDefaultEncoding() {
        let obfuscator = Obfuscator(key: key, plainString: plainString)
        XCTAssertEqual(obfuscator.plainString(), plainString)
    }

    func testXOREncoding() {
        let obfuscator = Obfuscator(key: key, plainString: plainString, type: .XOR)
        XCTAssertEqual(obfuscator.plainString(), plainString)
    }

    func testBase64Encoding() {
        let obfuscator = Obfuscator(key: key, plainString: plainString, type: .Base64)
        XCTAssertEqual(obfuscator.plainString(), plainString)
    }

    func testBase64XOREncoding() {
        let obfuscator = Obfuscator(key: key, plainString: plainString, type: .Base64_XOR)
        XCTAssertEqual(obfuscator.plainString(), plainString)
    }


    func testCopying() {
        let obfuscator = Obfuscator(key: key, plainString: plainString)
        let copy = obfuscator.copy() as! Obfuscator
        XCTAssertEqual(obfuscator.plainString(), copy.plainString())
    }
}
