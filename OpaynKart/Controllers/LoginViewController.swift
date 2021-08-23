//
//  LoginViewController.swift
//  OpaynKart
//
//  Created by OPAYN on 16/08/21.
//

import UIKit

class LoginViewController: UIViewController {

    
    //MARK:- IBOutlets
    @IBOutlet weak var singinHeadingLabel: UILabel!
    @IBOutlet weak var welcomeLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var passwordLbl: UILabel!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var forgotBtn: UIButton!
    @IBOutlet weak var signInBtn: SetButton!
    @IBOutlet weak var dontHaveAccountLbl3: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var spacingBetweenFields: NSLayoutConstraint!
    
    
    //MARK:- Variables
    
    //MARK:- Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        changeFontSizes()
        if UIDevice.current.userInterfaceIdiom == .pad{
            self.spacingBetweenFields.constant = 32
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK:- Custom Methods
    
    func changeFontSizes(){
        self.singinHeadingLabel.changeFontSize()
        self.signInBtn.changeFontSize()
        self.signInBtn.changeButtonLayout()
        self.welcomeLbl.changeFontSize()
        self.emailLbl.changeFontSize()
        self.emailTxtFld.changeFontSize()
        self.passwordLbl.changeFontSize()
        self.passwordTxtFld.changeFontSize()
        self.forgotBtn.changeFontSize()
        self.forgotBtn.changeButtonLayout()
        self.signInBtn.changeFontSize()
        self.dontHaveAccountLbl3.changeFontSize()
        self.registerBtn.changeFontSize()
        self.registerBtn.changeButtonLayout()
    }
    
    //MARK:- Objc Methods

    //MARK:- IBActions
    
    @IBAction func tappedRegisterBtn(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func tappedLoginBtn(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tappedForgotPassword(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Extensions
    
    
 
}
