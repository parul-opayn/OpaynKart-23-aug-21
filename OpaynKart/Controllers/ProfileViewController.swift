//
//  ProfileViewController.swift
//  OpaynKart
//
//  Created by OPAYN on 17/08/21.
//

import UIKit

class ProfileViewController: UIViewController {

    //MARK:- IBOutlets
    
    @IBOutlet weak var profileTableView: UITableView!
    
    //MARK:- Variables
    
    var namesData = ["Edit Profile","Wishlist","Address","My Orders","Logout"]
    var imagesData = [UIImage(named: "filledProfile"),UIImage(named: "filledWishlist"),UIImage(named: "filledHome"),UIImage(named: "bag"),UIImage(named: "logout")]
    
    //MARK:- Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTableView.delegate = self
        profileTableView.dataSource = self
        self.navigationWithTitleOnly(titleString: "Profile")
    }
    
    //MARK:- Custom Methods
    
    //MARK:- Objc Methods
    
    //MARK:- IBActions
    
    //MARK:- Extensions
    
}

//MARK:- TableView Delegates

extension ProfileViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = profileTableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell") as! CategoryTableViewCell
        cell.nameLabel.text = namesData[indexPath.row]
        cell.settingImage.image = imagesData[indexPath.row]?.withRenderingMode(.alwaysOriginal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 1:
            self.navigationController?.popViewController(animated: true)
            self.tabBarController?.selectedIndex  = 2
            break
        case 2:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddressViewController") as! AddressViewController
            self.navigationController?.pushViewController(vc, animated: true)
        break
        case 3:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyOrdersViewController") as! MyOrdersViewController
            self.navigationController?.pushViewController(vc, animated: true)
        break
        case 4:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            break
        }
    }
    
}
