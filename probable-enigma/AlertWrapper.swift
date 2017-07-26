//
//  AlertWrapper.swift
//  probable-enigma
//
//  Created by Dmitrii on 26/07/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import UIKit


class AlertWrapper {

    // MARK: - Properties

    private let alert: UIAlertController


    // MARK: - Lyfecycle

    init(alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)) {
        self.alert = alert
    }


    // MARK: - Public

    func showAlert(from: UIViewController, title: String, message: String, actions: [UIAlertAction], completion: (() -> Void)? = nil)
    {
        alert.title = title
        alert.message = message
        actions.forEach { alert.addAction($0) }

        from.present(alert, animated: true, completion: completion)
    }

}

