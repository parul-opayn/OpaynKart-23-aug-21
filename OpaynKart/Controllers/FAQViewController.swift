//
//  FAQViewController.swift
//  OpaynKart
//
//  Created by OPAYN on 18/08/21.
//

import UIKit

class FAQViewController: UIViewController {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var faqTableView: UITableView!
    @IBOutlet weak var searchTextField: SetTextField!
    
    
    //MARK:- Variables
    
    var userSelectedIndex = -1
    
    //MARK:- Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextField()
        faqTableView.delegate = self
        faqTableView.dataSource = self
        self.navigationController?.isNavigationBarHidden = false
        self.navigationWithBack(navtTitle: "FAQ")
        
    }
    
    //MARK:- Custom Methods
    
    func setUpTextField(){
        searchTextField.placeholder = "Search Here"
        searchTextField.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width - 32, height: 32)
        searchTextField.borderStyle = .none
        searchTextField.returnKeyType = .search
        searchTextField.leftViewMode = .always
        searchTextField.delegate = self
        searchTextField.backgroundColor = UIColor(named: "AppLightGray")
        searchTextField.layer.cornerRadius = 8
        let imageView = UIImageView(frame: CGRect(x: 8.0, y: 10, width: 20.0, height: 20.0))
        let image = #imageLiteral(resourceName: "miniSearch")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit

        let view = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 40))
        view.addSubview(imageView)
        searchTextField.leftViewMode = .always
        searchTextField.leftView = view
    }
    
    //MARK:- Objc Methods
    
    
    
    //MARK:- IBActions
    
    
}


//MARK:- TableView Delegates

extension FAQViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.faqTableView.dequeueReusableCell(withIdentifier: "ContactUsTableViewCell") as! ContactUsTableViewCell
        if userSelectedIndex == indexPath.row{
            cell.answerLabel.isHidden = false
            cell.answerLabel.numberOfLines = 0
            cell.arrowImage.image = #imageLiteral(resourceName: "down")
        }
        else{
            cell.answerLabel.isHidden = true
            cell.answerLabel.numberOfLines = 1
            cell.arrowImage.image = #imageLiteral(resourceName: "up")
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row selected")
        if userSelectedIndex == indexPath.row{
            userSelectedIndex = -1
        }
        else{
            userSelectedIndex = indexPath.row
        }
        self.faqTableView.reloadData()
    }
    
}

//MARK:- UITextField Delegates

extension FAQViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
