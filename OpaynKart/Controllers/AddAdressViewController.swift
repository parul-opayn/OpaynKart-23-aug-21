//
//  AddAdressViewController.swift
//  OpaynKart
//
//  Created by OPAYN on 17/08/21.
//

import UIKit

class AddAdressViewController: UIViewController {

    @IBOutlet weak var useLocaionBtn: SetButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationWithBack(navtTitle: "Add Address")
        useLocaionBtn.changeFontSize()
        useLocaionBtn.changeFontSize()
        useLocaionBtn.changeButtonLayout()
    }
    

}
