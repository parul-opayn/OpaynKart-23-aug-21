//
//  PrivacyPolicyViewController.swift
//  OpaynKart
//
//  Created by OPAYN on 18/08/21.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {

    //MARK:- IBOutlets
    
    //MARK:- Variables
    
    //MARK:- Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationWithBack(navtTitle: "Privacy Policy")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationWithBack(navtTitle: "Privacy Policy")
    }
    
    //MARK:- Custom Methods
    
    //MARK:- Objc Methods
    
    //MARK:- IBActions
       
}
