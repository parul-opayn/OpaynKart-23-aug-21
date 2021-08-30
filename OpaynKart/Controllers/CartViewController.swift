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
    @IBOutlet weak var totalChargesLbl: UILabel!
    @IBOutlet weak var taxLbl: UILabel!
    @IBOutlet weak var deliveryChargesLbl: UILabel!
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var cartTableFooterView: UIView!
    @IBOutlet weak var payOnlineBtn: UIButton!
    @IBOutlet weak var codBtn: UIButton!
    @IBOutlet weak var proceedBtn: SetButton!
    
    //MARK:- Variables
    
    var viewModel = CartViewModel()
    
    //MARK:- Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationWithTitleOnly(titleString: "Cart")
        cartTableView.delegate = self
        cartTableView.dataSource = self
        self.adjustLayout()
        self.cartTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cartList()
        self.cartTableFooterView.isHidden = true
    }
    
    //MARK:- Custom Methods
    
    //MARK:- Objc Methods
    
    @objc func didTapDelete(sender:UIButton){
        self.showAlertWithActionOkandCancel(Title: "Opayn Kart", Message: "Are you sure you want to delete the item", OkButtonTitle: "OK", CancelButtonTitle: "Cancel") {
            self.deleteCart(pId: self.viewModel.cartList?.data?[sender.tag].id ?? "", atIndex: sender.tag)
        }
     
    }
    
    @objc func didTapAdd(sender:UIButton){
        var defaultQuanity = Int(viewModel.cartList?.data?[sender.tag].quantity ?? "0") ?? 0
        defaultQuanity += 1
        print("Quantity = \(defaultQuanity)")
        viewModel.cartList?.data?[sender.tag].quantity = "\(defaultQuanity)"
        self.cartTableView.reloadData()
        cartQuantity(pId: viewModel.cartList?.data?[sender.tag].id ?? "", quantity: defaultQuanity,atIndex: sender.tag,type: "add")
    }
    
    @objc func didTapRemove(sender:UIButton){
        var defaultQuanity = Int(viewModel.cartList?.data?[sender.tag].quantity ?? "0") ?? 0
        if defaultQuanity == 1{
            self.showToast(message: "You can't remove more items")
        }
        else{
            defaultQuanity -= 1
            print("Quantity = \(defaultQuanity)")
            viewModel.cartList?.data?[sender.tag].quantity = "\(defaultQuanity)"
            cartQuantity(pId: viewModel.cartList?.data?[sender.tag].id ?? "", quantity: defaultQuanity,atIndex: sender.tag,type: "minus")
        }
        self.cartTableView.reloadData()
       
    }
    
    //MARK:- IBActions
    
    @IBAction func tappedOnlineBtn(_ sender: UIButton) {
        payOnlineBtn.setImage(#imageLiteral(resourceName: "filledCircle"), for: .normal)
        codBtn.setImage(#imageLiteral(resourceName: "emptyCircle"), for: .normal)
    }
    
    @IBAction func tappedCODBtn(_ sender: UIButton) {
        codBtn.setImage(#imageLiteral(resourceName: "filledCircle"), for: .normal)
        payOnlineBtn.setImage(#imageLiteral(resourceName: "emptyCircle"), for: .normal)
    }
    
    @IBAction func tappedProceedBtn(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "AddressViewController") as! AddressViewController
        vc.displayDataFor = .cart
        vc.cartViewModel = self.viewModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Extensions
    
    
}

//MARK:- TableView Delegates

extension CartViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.cartList?.data?.count ?? 0 == 0{
            tableCollectionErrors(view: tableView, text: "No products found.")
        }
        else{
            tableCollectionErrors(view: tableView, text: "")
        }
        return viewModel.cartList?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: "CartTableViewCell") as! CartTableViewCell
        let model = viewModel.cartList?.data?[indexPath.row]
        cell.productNameLbl.text = model?.name ?? ""
        cell.productImage.sd_setImage(with: URL(string: model?.images?.first ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder Image"), options: .highPriority, context: nil)
        cell.quantityBtn.text = model?.quantity ?? "0"
        cell.priceLbl.text = "Price: $\(model?.salePrice ?? "")"
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
        
        cell.addBtn.tag = indexPath.row
        cell.addBtn.addTarget(self, action: #selector(didTapAdd(sender:)), for: .touchUpInside)
        
        cell.removeBtn.tag = indexPath.row
        cell.removeBtn.addTarget(self, action: #selector(didTapRemove(sender:)), for: .touchUpInside)
        return cell
    }
    
    
}


//MARK:- API Calls

extension CartViewController{
    
    func cartList(){
        Indicator.shared.showProgressView(self.view)
        self.viewModel.cartData(){[weak self] isSuccess, message in
            Indicator.shared.hideProgressView()
            guard let self = self else{return}
            
            if isSuccess{
                if self.viewModel.cartList?.data?.count ?? 0 == 0{
                    self.cartTableFooterView.isHidden = true
                    self.proceedBtn.isHidden = true
                }
                else{
                    self.cartTableFooterView.isHidden = false
                    self.cartTableView.reloadData()
                    self.proceedBtn.isHidden = false
                   // self.updateTableHeight(tableName: self.cartTableView, tableHeight: self.cartTableHeight)
                }
                self.cartTableView.reloadData()
               
            }
            else{
                self.showToast(message: message)
            }
        }
    }
    
    
    func deleteCart(pId:String,atIndex:Int){
        Indicator.shared.showProgressView(self.view)
        self.viewModel.deleteProductFromCart(productId: pId){[weak self] isSuccess, message in
            Indicator.shared.hideProgressView()
          
            guard let self = self else{return}
            if isSuccess{
                
                self.viewModel.cartList?.data?.remove(at: atIndex)
                
                if self.viewModel.cartList?.data?.count ?? 0 == 0{
                    self.cartTableFooterView.isHidden = true
                    self.proceedBtn.isHidden = true
                }
                else{
                    self.cartTableFooterView.isHidden = false
                    self.proceedBtn.isHidden = false
                    //self.updateTableHeight(tableName: self.cartTableView, tableHeight: self.cartTableHeight)
                }
                self.cartTableView.reloadData()
            }
            else{
                self.showToast(message: message)
            }
        }
    }

    func cartQuantity(pId:String,quantity:Int,atIndex:Int,type:String){
        
        self.viewModel.productQuantity(id: pId, quantity: quantity){[weak self] isSuccess, message in
          
            guard let self = self else{return}
            if isSuccess{
                print("quantity updated")
            }
            else{
                if type == "add"{
                    var defaultQuantity = Int(self.viewModel.cartList?.data?[atIndex].quantity ?? "") ?? 0
                    defaultQuantity -= 1
                    self.viewModel.cartList?.data?[atIndex].quantity = "\(defaultQuantity)"
                }
                else{
                    var defaultQuantity = Int(self.viewModel.cartList?.data?[atIndex].quantity ?? "") ?? 0
                    defaultQuantity += 1
                    self.viewModel.cartList?.data?[atIndex].quantity = "\(defaultQuantity)"
                }
                self.cartTableView.reloadData()
                self.showToast(message: message)
            }
        }
    }

    
}
