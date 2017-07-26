//
//  ViewController.swift
//  probable-enigma
//
//  Created by Dmitrii on 26/07/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showAlertView()
        }
    }

    func showAlertView() {
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
        AlertWrapper().showAlert(
            from: self,
            title: "Great title for the alert",
            message: "The message is even better!",
            actions: [okAction, cancelAction],
            completion: {
                print("Alert presenting is finished.")
        })
    }
}

