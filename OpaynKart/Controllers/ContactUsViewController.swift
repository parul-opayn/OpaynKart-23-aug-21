//
//  ContactUsViewController.swift
//  OpaynKart
//
//  Created by OPAYN on 18/08/21.
//

import UIKit
import GrowingTextView

class ContactUsViewController: UIViewController {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var titleTxtFld: UITextField!
    @IBOutlet weak var descriptionTxtView: GrowingTextView!
    
    //MARK:- Variables
    
    var viewModel = ContactUsViewModel()
    
    //MARK:- Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationWithBack(navtTitle: "Contact Us")
    }
    
    //MARK:- Custom Methods
    
    //MARK:- Objc Methods
    
    //MARK:- IBActions
   
    @IBAction func tappedSubmitBtn(_ sender: UIButton) {
        if titleTxtFld.text?.replacingOccurrences(of: " ", with: "") == ""{
            self.showToast(message: "Please enter title")
        }
        else if descriptionTxtView.text?.replacingOccurrences(of: " ", with: "") == ""{
            self.showToast(message: "Please enter description")
        }
        else{
            contactUs()
        }
    }
    
}

//MARK:- API Calls

extension ContactUsViewController{
    
    func contactUs(){
        Indicator.shared.showProgressView(self.view)
        viewModel.contactUs(title: titleTxtFld.text ?? "", description: descriptionTxtView.text ?? "", id: UserDefault.sharedInstance?.getUserDetails()?.id ?? "") {[weak self] isSuccess, message in
            Indicator.shared.hideProgressView()
            guard let self = self else{return}
            if isSuccess{
                self.navigationController?.popViewController(animated: true)
            }
            else{
                self.showToast(message: message)
            }
        }
    }
}
