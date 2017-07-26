//
//  AlertWrapper.swift
//  probable-enigma
//
//  Created by Dmitrii on 26/07/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import UIKit


class AlertWrapper {

    var testingMode = false
    var title = ""
    var message = ""
    var actions = [UIAlertAction]()

    init(testingMode: Bool = false) {
        self.testingMode = testingMode
    }

    func showAlert(fromVC: UIViewController, title: String, message: String, actions: [UIAlertAction], completion: @escaping ()->()) {
        self.title = title
        self.message = message
        self.actions = actions

        if !testingMode {
            showUIAlert(fromVC: fromVC, completion: completion)
        }
    }

    private func showUIAlert(fromVC: UIViewController, completion: @escaping ()->()) {
        let alertVC = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        for action in actions {
            alertVC.addAction(action)
        }
        fromVC.present(alertVC, animated: true, completion: completion)
    }
}

