//
//  ProfileViewController.swift
//  OpaynKart
//
//  Created by OPAYN on 17/08/21.
//

import UIKit
import SkeletonView

class ProfileViewController: UIViewController {

    //MARK:- IBOutlets
    
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    //MARK:- Variables
    
    var namesData = ["Edit Profile","Change Password","Wishlist","Address","My Orders","Logout"]
    var imagesData = [UIImage(named: "filledProfile"),UIImage(named: "password"),UIImage(named: "filledWishlist"),UIImage(named: "filledHome"),UIImage(named: "bag"),UIImage(named: "logout")]
    var viewModel = MyProfileViewModel()
    
    //MARK:- Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTableView.delegate = self
        profileTableView.dataSource = self
        self.navigationWithTitleOnly(titleString: "Profile")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        profileAPI()
    }
    
    //MARK:- Custom Methods
    
    
    //MARK:- Objc Methods
    
    //MARK:- IBActions
    
    //MARK:- Extensions
    
}

//MARK:- TableView Delegates

extension ProfileViewController:UITableViewDelegate,UITableViewDataSource,SkeletonTableViewDataSource,SkeletonTableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namesData.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namesData.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = profileTableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell") as! CategoryTableViewCell
        cell.nameLabel.text = namesData[indexPath.row]
        cell.settingImage.image = imagesData[indexPath.row]?.withRenderingMode(.alwaysOriginal)
        return cell
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "CategoryTableViewCell"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
            vc.profileModel = self.viewModel.profileData
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case 1:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordViewController") as! ResetPasswordViewController
            vc.email = UserDefault.sharedInstance?.getUserDetails()?.email ?? "N/A"
            vc.displayDataFor = .changePassword
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case 2:
            self.navigationController?.popViewController(animated: true)
            self.tabBarController?.selectedIndex  = 2
            break
        case 3:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddressViewController") as! AddressViewController
            self.navigationController?.pushViewController(vc, animated: true)
        break
        case 4:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyOrdersViewController") as! MyOrdersViewController
            self.navigationController?.pushViewController(vc, animated: true)
        break
        case 5:
            UserDefaults.standard.removeObject(forKey: "userData")
            UserDefault.sharedInstance?.removeUserData()
            UserDefault.sharedInstance?.updateUserData()
            UserDefaults.standard.removeObject(forKey: "token")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            break
        }
    }
    
}

//MARK:- API Calls

extension ProfileViewController{
    
    func profileAPI(){
//        let gradient = SkeletonGradient(baseColor: .lightGray)
//        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
//        view.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
        Indicator.shared.showProgressView(self.view)
        self.viewModel.myProfileAPI {[weak self] isSuccess, message in
            guard let self = self else{return}
            Indicator.shared.hideProgressView()
           // self.view.hideSkeleton()
            if isSuccess{
                self.usernameLbl.text = self.viewModel.profileData?.name ?? ""
                self.emailLbl.text = self.viewModel.profileData?.email ?? ""
                self.userProfileImage.sd_setImage(with: URL(string: URLS.baseUrl.getDescription() + (self.viewModel.profileData?.image ?? "")), placeholderImage: #imageLiteral(resourceName: "profilePlaceholder"), options: .highPriority, context: nil)
            }
            else{
                self.showToast(message: message)
            }
        }
    }
}
