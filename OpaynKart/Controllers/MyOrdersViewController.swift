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
    @IBOutlet weak var searchTxtFld: UITextField!
    @IBOutlet weak var filtersBtn: UIButton!
    
    //MARK:- Variables
    
    var viewModel = MyOrdersViewModel()
    
    //MARK:- Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
        self.navigationWithBack(navtTitle: "My Orders")
        filtersBtn.changeButtonLayout()
        filtersBtn.changeFontSize()
        self.ordersTableView.tableFooterView = UIView()
        setUpTextField()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        myOrdersAPI()
    }
    
    //MARK:- Custom Methods
    
    func setUpTextField(){
        searchTxtFld.placeholder = "Search Here"
        searchTxtFld.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width - 32, height: 32)
        searchTxtFld.borderStyle = .none
        searchTxtFld.returnKeyType = .search
        searchTxtFld.leftViewMode = .always
        //searchTxtFld.delegate = self
        searchTxtFld.backgroundColor = UIColor(named: "AppLightGray")
        searchTxtFld.layer.cornerRadius = 8
        let imageView = UIImageView(frame: CGRect(x: 8.0, y: 10, width: 20.0, height: 20.0))
        let image = #imageLiteral(resourceName: "miniSearch")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit

        let view = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 40))
        view.addSubview(imageView)
        searchTxtFld.leftViewMode = .always
        searchTxtFld.leftView = view
        searchTxtFld.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    //MARK:- Objc Methods
    
    @objc func textFieldDidChange(sender:UITextField){
        if sender.text ?? "" == ""{
            self.viewModel.myorders = self.viewModel.temp
        }
        else{
            self.viewModel.myorders.removeAll()
            self.viewModel.myorders = viewModel.temp.filter({($0.orderID?.lowercased().contains(sender.text?.lowercased() ?? "") ?? false)})
        }
        self.ordersTableView.reloadData()
    }
    
    @objc func didTapCancelOrder(sender:UIButton){
       
        self.showAlertWithActionOkandCancel(Title: "Opayn Kart", Message: "Are you sure you want to cancel this order?", OkButtonTitle: "OK", CancelButtonTitle: "Cancel") {
            self.cancelProduct(orderId: self.viewModel.myorders[sender.tag].orderID ?? "")
        }
       
    }
    
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
        return viewModel.myorders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ordersTableView.dequeueReusableCell(withIdentifier: "MyOrdersTableViewCell") as! MyOrdersTableViewCell
        cell.orderImage.changeViewLayout()
        cell.orderImage.changeLayout()
        cell.deliveredOnLbl.text = "Order Id: \(viewModel.myorders[indexPath.row].orderID ?? "")"
        cell.productDetailsLbl.text = "Price: $\(viewModel.myorders[indexPath.row].total ?? "")"
        cell.orderImage.sd_setImage(with: URL(string: viewModel.myorders[indexPath.row].products?.first?.images?.first ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder Image"), options: .highPriority, context: nil)
        let orderDate = Singleton.sharedInstance.UTCToLocal(date: viewModel.myorders[indexPath.row].created_at ?? "", fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "yyyy-MM-dd")
        cell.dateLbl.text = orderDate
        cell.quantityLbl.text = "Total Qty: \(viewModel.myorders[indexPath.row].products?.count ?? 0)"
        cell.cancelOrderBtn.tag = indexPath.row
        cell.cancelOrderBtn.addTarget(self, action: #selector(didTapCancelOrder(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubOrderDetailsViewController") as! SubOrderDetailsViewController
        vc.forIndex = indexPath.row
        vc.viewModel = self.viewModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK:- API Calls

extension MyOrdersViewController{
    
    func myOrdersAPI(){
        Indicator.shared.showProgressView(self.view)
        viewModel.myOrders { isSuccess, message in
            Indicator.shared.hideProgressView()
            if isSuccess{
                self.ordersTableView.reloadData()
            }
            else{
                self.showToast(message: message)
            }
        }
    }
    
    func cancelProduct(orderId:String){
        Indicator.shared.showProgressView(self.view)
        viewModel.cancelOrder(id: orderId) { isSuccess, message in
            Indicator.shared.hideProgressView()
            if isSuccess{
                self.showToast(message: "Order Cancelled succesfully.")
            }
            else{
                self.showToast(message: message)
            }
        }
    }
    
}
