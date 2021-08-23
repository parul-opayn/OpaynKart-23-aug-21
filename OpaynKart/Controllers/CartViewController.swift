//
//  CartViewController.swift
//  OpaynKart
//
//  Created by OPAYN on 17/08/21.
//

import UIKit

class CartViewController: UIViewController {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var cartTableHeight: NSLayoutConstraint!
    
    //MARK:- Variables
    
    //MARK:- Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationWithTitleOnly(titleString: "Cart")
        cartTableView.delegate = self
        cartTableView.dataSource = self
        updateTableHeight(tableName: cartTableView, tableHeight: cartTableHeight)
        self.adjustLayout()
    }
    
    //MARK:- Custom Methods
    
    //MARK:- Objc Methods
    
    //MARK:- IBActions
    
    //MARK:- Extensions
    
    
}

//MARK:- TableView Delegates

extension CartViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: "CartTableViewCell") as! CartTableViewCell
        return cell
    }
    
    
}
