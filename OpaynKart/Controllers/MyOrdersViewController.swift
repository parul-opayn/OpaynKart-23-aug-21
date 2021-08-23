//
//  MyOrdersViewController.swift
//  OpaynKart
//
//  Created by OPAYN on 17/08/21.
//

import UIKit

class MyOrdersViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var ordersTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filtersBtn: UIButton!
    
    //MARK:- Variables
    
    //MARK:- Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
        self.navigationWithBack(navtTitle: "My Orders")
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        filtersBtn.changeButtonLayout()
        filtersBtn.changeFontSize()
    }
    
    //MARK:- Custom Methods
    
    //MARK:- Objc Methods
    
    //MARK:- IBActions
    
    @IBAction func tappedFilters(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FiltersViewController") as! FiltersViewController
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
}

//MARK:- TableView Delegates

extension MyOrdersViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ordersTableView.dequeueReusableCell(withIdentifier: "MyOrdersTableViewCell") as! MyOrdersTableViewCell
        cell.orderImage.changeViewLayout()
        cell.orderImage.changeLayout()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
