//
//  ForgotPasswordViewController.swift
//  OpaynKart
//
//  Created by OPAYN on 17/08/21.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationWithBack(navtTitle: "Forgot Password")
    }

}
