//
//  SubOrderDetailsViewController.swift
//  OpaynKart
//
//  Created by OPAYN on 30/08/21.
//

import UIKit

class SubOrderDetailsViewController: UIViewController {

    //MARK:- IBOutlets
    
    @IBOutlet weak var subOrdersTableVIew: UITableView!
    
    //MARK:- Varaibles
    
    var viewModel = MyOrdersViewModel()
    var forIndex = -1
    
    //MARK:- Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subOrdersTableVIew.delegate = self
        subOrdersTableVIew.dataSource = self
        self.navigationWithBack(navtTitle: "My Orders")
        subOrdersTableVIew.tableFooterView = UIView()
    }

}

//MARK:- TableView Delegates

extension SubOrderDetailsViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.myorders[forIndex].products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = subOrdersTableVIew.dequeueReusableCell(withIdentifier: "MyOrdersTableViewCell") as! MyOrdersTableViewCell
        let model = viewModel.myorders[forIndex].products?[indexPath.row]
        cell.orderImage.changeViewLayout()
        cell.orderImage.changeLayout()
        cell.deliveredOnLbl.text = "Product Id: \(model?.id ?? "")"
        cell.productDetailsLbl.text = "Price: $\(model?.price ?? "")"
        cell.orderImage.sd_setImage(with: URL(string: model?.images?.first ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder Image"), options: .highPriority, context: nil)
        let orderDate = Singleton.sharedInstance.UTCToLocal(date: viewModel.myorders[indexPath.row].created_at ?? "", fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "yyyy-MM-dd")
        cell.dateLbl.text = orderDate
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
       // self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
