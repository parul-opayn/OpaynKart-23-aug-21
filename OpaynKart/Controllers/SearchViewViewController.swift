//
//  SearchViewViewController.swift
//  OpaynKart
//
//  Created by OPAYN on 20/08/21.
//

import UIKit

class SearchViewViewController: UIViewController {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    
    //MARK:- Variables
    
    //MARK:- Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.tableFooterView = UIView()
        cancelBtn.changeButtonLayout()
        cancelBtn.changeFontSize()
        setUpTextField()
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
        self.navigationItem.titleView = searchTextField
    }
    
    //MARK:- Objc Methods
    
    //MARK:- IBActions
    
    @IBAction func tappedCancelBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

//MARK:-TableView Delegates/Datasources

extension SearchViewViewController:UITableViewDelegate,UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell") as! AddressTableViewCell
        return cell
    }
}


//MARK:- UITextField Delegates

extension SearchViewViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
