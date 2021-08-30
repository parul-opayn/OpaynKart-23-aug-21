//
//  AddressViewController.swift
//  OpaynKart
//
//  Created by OPAYN on 17/08/21.
//

import UIKit

class AddressViewController: UIViewController {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var addressTableView: UITableView!
    @IBOutlet weak var addAddressBtn: UIButton!
    @IBOutlet weak var priceViewHeight: NSLayoutConstraint!
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var taxLbl: UILabel!
    @IBOutlet weak var deliveryChargesLbl: UILabel!
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var priceView: UIView!
    
    //MARK:- Variables
    
    var viewModel = AddAddressViewModel()
    var cartViewModel = CartViewModel()
    var displayDataFor:addressPageFor = .address
    var dictToSend = [String:Any]()
    var selectedAddress = ""
    
    //MARK:- Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressTableView.delegate = self
        addressTableView.dataSource = self
        self.navigationWithBack(navtTitle: "My Address")
        addAddressBtn.changeFontSize()
        addAddressBtn.changeButtonLayout()
        addressTableView.tableFooterView = UIView()
        if displayDataFor == .cart{
            self.calcualteCartValues()
            self.priceViewHeight.constant = 250
            self.priceView.isHidden = false
            addressTableView.allowsSelection = true
        }
        else{
            self.priceViewHeight.constant = 0
            self.priceView.isHidden = true
            addressTableView.allowsSelection = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userAddressList()
    }
    
    //MARK:- Custom Methods
    
    func calcualteCartValues(){
        let mappedPrices = self.cartViewModel.cartList?.data?.map({Int($0.salePrice ?? "") ?? 0}) ?? []
        let total = mappedPrices.reduce(0,+)
        let tax = (total * 18) / 100
        self.totalPriceLbl.text = "$ \(total)"
        self.taxLbl.text = "$ \(tax)"
        self.deliveryChargesLbl.text = "$" + (self.cartViewModel.cartList?.settings?.deliveryFee ?? "")
        let delivery = Int(self.cartViewModel.cartList?.settings?.deliveryFee ?? "") ?? 0
        self.subTotalLbl.text = "$ \(total + tax + delivery)"
    }
    
    //MARK:- IBActions
    
    @IBAction func tappedNewAddressBtnq(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddAdressViewController") as! AddAdressViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tappedproceedBtn(_ sender: UIButton) {
        Indicator.shared.showProgressView(self.view)
        self.dictToSend = [:]
        var products = [[String:Any]]()
        for i in self.cartViewModel.cartList?.data ?? []{
            products.append(["product_id":i.id ?? "","quantity":i.quantity ?? ""])
        }
//        self.dictToSend["products"] = products
//        self.dictToSend["address_id"] = self.selectedAddress
//        self.dictToSend["tax"] = self.cartViewModel.cartList?.settings?.tax ?? ""
//        self.dictToSend["shipping"]  = self.cartViewModel.cartList?.settings?.deliveryFee ?? ""
//        print(dictToSend)
        cartViewModel.checkOut(products: products, addressId: self.selectedAddress, tax: self.cartViewModel.cartList?.settings?.tax ?? "", shipping: self.cartViewModel.cartList?.settings?.deliveryFee ?? "") {[weak self] isSuccess, message in
            Indicator.shared.hideProgressView()
            
            guard let self = self else{return}
            if isSuccess{
                print("API Success")
            }
            else{
                print("API Failure")
            }
        }
    }
    
}

//MARK:- TableView Delegates

extension AddressViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model = viewModel.addressModel
        if model.count == 0{
            tableCollectionErrors(view: tableView, text: "No data found")
        }
        else{
            tableCollectionErrors(view: tableView, text: "")
        }
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.addressTableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell") as! AddressTableViewCell
        let model = viewModel.addressModel[indexPath.row]
        cell.usernameLbl.text = model.fullName ?? ""
        cell.userMobileLbl3.text = model.phoneNumber ?? ""
        cell.userAdderessLbl.text = " \(model.houseNo ?? ""), \(model.area ?? ""),\(model.state ?? ""),\(model.pincode ?? "")"
        if displayDataFor == .address{
            cell.selectionImage.isHidden = true
        }
        else{
            cell.selectionImage.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            print("index path of delete: \(indexPath)")
            self.deleteAddress(id: self.viewModel.addressModel[indexPath.row].id ?? "", forIndex: indexPath.row)
            completionHandler(true)
        }
        
        let rename = UIContextualAction(style: .normal, title: "Edit") { (action, sourceView, completionHandler) in
            print("index path of edit: \(indexPath)")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddAdressViewController") as! AddAdressViewController
            vc.forIndex = indexPath.row
            vc.viewModel = self.viewModel
            vc.addressFor = .editAddress
            self.navigationController?.pushViewController(vc, animated: true)
            completionHandler(true)
        }
        
        if self.displayDataFor == .cart{
            let swipeActionConfig = UISwipeActionsConfiguration(actions: [rename])
            swipeActionConfig.performsFirstActionWithFullSwipe = false
            return swipeActionConfig
        }
        else{
            let swipeActionConfig = UISwipeActionsConfiguration(actions: [rename, delete])
            swipeActionConfig.performsFirstActionWithFullSwipe = false
            return swipeActionConfig
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if displayDataFor == .cart{
            self.selectedAddress = self.viewModel.addressModel[indexPath.row].id ?? ""
        }
    }
}


//MARK:- API Calls

extension AddressViewController{
    
    func userAddressList(){
        Indicator.shared.showProgressView(self.view)
        viewModel.userAddressList(){[weak self]isSuccess, message in
            Indicator.shared.hideProgressView()
            guard let self = self else{return}
            if isSuccess{
                self.addressTableView.reloadData()
            }
            else{
                self.showToast(message: message)
            }
        }
    }
    
    func deleteAddress(id:String,forIndex index:Int){
        Indicator.shared.showProgressView(self.view)
        viewModel.deleteaAddress(addressId: id){[weak self] isSuccess,message in
            Indicator.shared.hideProgressView()
            guard let self = self else{return}
            if isSuccess{
                self.viewModel.addressModel.remove(at: index)
                self.addressTableView.reloadData()
            }
            else{
                self.showToast(message: message)
            }
        }
    }
    
}
