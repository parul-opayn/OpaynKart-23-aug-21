//
//  SignUpViewController.swift
//  OpaynKart
//
//  Created by OPAYN on 16/08/21.
//

import UIKit

class SignUpViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var registerHeadingLabel: UILabel!
    @IBOutlet weak var fillFormLbl: UILabel!
    @IBOutlet weak var fullNameLbl: UILabel!
    @IBOutlet weak var fullNameTxtFld: UITextField!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var createPasswordLbl: UILabel!
    @IBOutlet weak var createPasswordTxtFld: UITextField!
    @IBOutlet weak var reapeatPasswordLbl: UILabel!
    @IBOutlet weak var repeatTxtFld: UITextField!
    @IBOutlet weak var registerBtn: SetButton!
    @IBOutlet weak var alreadyHaveAccntLbl: UILabel!
    @IBOutlet weak var signnBtn: UIButton!
    @IBOutlet weak var fieldStackView: UIStackView!
    
    //MARK:- Variables
        
    //MARK:- Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        //self.navigationWithBack(navtTitle: "")
        changeFontAndSizes()
    }
    
    //MARK:- Custom Methods

    func changeFontAndSizes(){
        registerHeadingLabel.changeFontSize()
        fillFormLbl.changeFontSize()
        fullNameLbl.changeFontSize()
        fullNameTxtFld.changeFontSize()
        emailLbl.changeFontSize()
        emailTxtFld.changeFontSize()
        createPasswordLbl.changeFontSize()
        createPasswordTxtFld.changeFontSize()
        reapeatPasswordLbl.changeFontSize()
        repeatTxtFld.changeFontSize()
        registerBtn.changeButtonLayout()
        registerBtn.changeFontSize()
        alreadyHaveAccntLbl.changeFontSize()
        signnBtn.changeButtonLayout()
        signnBtn.changeFontSize()
        self.fieldStackView.changeSpacin()
    }
    
    //MARK:- Objc Methods
    
    //MARK:- IBActions
    
    @IBAction func tappedSigninBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:- Extensions
    
}
