//
//  AlertTest.swift
//  probable-enigma
//
//  Created by Dmitrii on 26/07/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import XCTest
@testable import probable_enigma


class ViewControllerMock: UIViewController {

    var alertToPresent: UIViewController?

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        alertToPresent = viewControllerToPresent
    }
}


class AlertTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }

    func testAlertBeingShown() {
        let testTitle = "Title"
        let testMessage = "Message"

        let mockController = ViewControllerMock()
        let mockAlert = UIAlertController()
        let alertWrapper = AlertWrapper(alert: mockAlert)
        let firstAction = UIAlertAction()
        let secondAction = UIAlertAction()

        alertWrapper.showAlert(
            from: mockController,
            title: testTitle,
            message: testMessage,
            actions: [firstAction, secondAction]
        )

        XCTAssertEqual(mockAlert.title, testTitle)
        XCTAssertEqual(mockAlert.message, testMessage)
        XCTAssertEqual(mockAlert.actions[0], firstAction)
        XCTAssertEqual(mockAlert.actions[1], secondAction)
        XCTAssertEqual(mockController.alertToPresent, mockAlert)
    }
}
