//
//  AboutUsViewController.swift
//  OpaynKart
//
//  Created by OPAYN on 18/08/21.
//

import UIKit

class AboutUsViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var dataTxtView: UITextView!
    
    //MARK:- Variables
    
    var generalDatatype:generalContent = .aboutUs
    var viewModel = GeneralContentViewModel()
    
    //MARK:- Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        if self.generalDatatype == .aboutUs{
            self.navigationWithBack(navtTitle: "About Us")
        }
        else if self.generalDatatype == .privacyPolicy{
            self.navigationWithBack(navtTitle: "Privacy Policy")
        }
        else{
            self.navigationWithBack(navtTitle: "Terms and Conditions")
        }
        genralContentAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        if self.generalDatatype == .aboutUs{
            self.navigationWithBack(navtTitle: "About Us")
        }
        else if self.generalDatatype == .privacyPolicy{
            self.navigationWithBack(navtTitle: "Privacy Policy")
        }
        else{
            self.navigationWithBack(navtTitle: "Terms and Conditions")
        }
    }
    
    //MARK:- Custom Methods
    
    //MARK:- Objc Methods
    
    //MARK:- IBActions
    
    
}

//MARK:- API Calls

extension AboutUsViewController{
    
    func genralContentAPI(){
        
        var contentType = ""
        if self.generalDatatype == .aboutUs{
            contentType = "1"
        }
        else if self.generalDatatype == .privacyPolicy{
            contentType = "2"
        }
        else{
            contentType = "3"
        }
        Indicator.shared.showProgressView(self.view)
        viewModel.generalContent(type: contentType) {[weak self] isSuccess, message in
            Indicator.shared.hideProgressView()
            guard let self = self else{return}
            self.dataTxtView.text = self.viewModel.model?.content ?? ""
        }
    }
    
}
