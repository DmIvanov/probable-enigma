//
//  AlertWrapper.swift
//  probable-enigma
//
//  Created by Dmitrii on 26/07/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import UIKit

class AlertWrapper {

    func showAlert(fromVC: UIViewController, title: String, message: String, actions: [UIAlertAction], completion: @escaping ()->()) {
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
