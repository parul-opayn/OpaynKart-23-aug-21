//
//  SideMenuViewController.swift
//  OpaynKart
//
//  Created by OPAYN on 18/08/21.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userImageView: SetImage!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var userImageHeight: NSLayoutConstraint!
    @IBOutlet weak var userImageWidth: NSLayoutConstraint!
    
    //MARK:- Variables
    
    var data = ["Shop by Categories","Contact Us","About us","Privacy Policy","Terms and Conditions","FAQ"]
    var viewController = UIViewController()
    
    //MARK:- Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.navigationController?.isNavigationBarHidden = true
        changeFontSizes()
    }
    
    //MARK:- Custom Methods
    
    //MARK:- Objc Methods
    
    func changeFontSizes(){
        userNameLbl.changeFontSize()
        userEmailLbl.changeFontSize()
        if UIDevice.current.userInterfaceIdiom == .pad{
            self.userImageHeight.constant = 120
            self.userImageWidth.constant = 120
        }
    }
    
    //MARK:- IBActions
    
    @IBAction func tappedBackBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}


//MARK:- TableView Delegates

extension SideMenuViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell") as! AddressTableViewCell
        cell.menuItemLabel.text = data[indexPath.row]
        //cell.menuImage.changeLayout()
        cell.menuItemLabel.changeFontSize()
       // cell.menuImage.changeLayout()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShopByCategoriesViewController") as! ShopByCategoriesViewController
            vc.hidesBottomBarWhenPushed = true
            self.viewController.navigationController?.pushViewController(vc, animated: true)
            self.dismiss(animated: true, completion: nil)
            break
        case 1:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
            vc.hidesBottomBarWhenPushed = true
            self.viewController.navigationController?.pushViewController(vc, animated: true)
            self.dismiss(animated: true, completion: nil)
            break
        case 2:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
            vc.hidesBottomBarWhenPushed = true
            self.viewController.navigationController?.pushViewController(vc, animated: true)
            self.dismiss(animated: true, completion: nil)
            break
        case 3:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
            vc.hidesBottomBarWhenPushed = true
            self.viewController.navigationController?.pushViewController(vc, animated: true)
            self.dismiss(animated: true, completion: nil)
            break
        case 4:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsConditionsViewController") as! TermsConditionsViewController
            vc.hidesBottomBarWhenPushed = true
            self.viewController.navigationController?.pushViewController(vc, animated: true)
            self.dismiss(animated: true, completion: nil)
        case 5:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FAQViewController") as! FAQViewController
            vc.hidesBottomBarWhenPushed = true
            self.viewController.navigationController?.pushViewController(vc, animated: true)
            self.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
}
