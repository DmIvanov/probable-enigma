//
//  AlertTest.swift
//  probable-enigma
//
//  Created by Dmitrii on 26/07/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import XCTest
@testable import probable_enigma

class AlertTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
    }

    func testAlertBeingShown() {
        let okAction = UIAlertAction(
            title: "Yeah.. OK",
            style: .default) { (action) in
                print("Ok action chosen")
        }
        let cancelAction = UIAlertAction(
            title: "I think.. NO",
            style: .default) { (action) in
                print("Cancel action chosen")
        }
        let alertTitle = "TestTitle"
        let alertMessage = "TestMessage"

        let wrapper = AlertWrapper(testingMode: true)
        wrapper.showAlert(
            fromVC: UIViewController(),
            title: alertTitle,
            message: alertMessage,
            actions: [okAction, cancelAction]) { 

        }

        XCTAssertEqual(wrapper.title, alertTitle)
        XCTAssertEqual(wrapper.message, alertMessage)
        XCTAssertEqual(wrapper.actions[0], okAction)
        XCTAssertEqual(wrapper.actions[1], cancelAction)
    }
}
