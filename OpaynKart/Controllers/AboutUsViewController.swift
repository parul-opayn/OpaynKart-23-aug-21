//
//  AboutUsViewController.swift
//  OpaynKart
//
//  Created by OPAYN on 18/08/21.
//

import UIKit

class AboutUsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationWithBack(navtTitle: "About Us")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationWithBack(navtTitle: "About Us")
    }

}
