//
//  EditProfileViewController.swift
//  OpaynKart
//
//  Created by OPAYN on 17/08/21.
//

import UIKit

class EditProfileViewController: UIViewController {
   
    //MARK:- IBOutlets
    
    @IBOutlet weak var userProfileImageView: SetImage!
    @IBOutlet weak var usernameTxtFld: UITextField!
    @IBOutlet weak var emailTxtFd: UITextField!
    
    //MARK:- Variables
    
    var viewModel = EditProfileViewModel()
    var imagePicker:ImagePicker?
    var imageData = Data()
    var imageName = ""
    var imageType = ""
    var profileModel:Profile?
    
    //MARK:- Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.navigationWithBack(navtTitle: "Edit Profile")
        displayUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    
    //MARK:- Custom Methods
    
    func displayUserData(){
        self.usernameTxtFld.text =  profileModel?.name ?? (UserDefault.sharedInstance?.getUserDetails()?.name ?? "")
        self.emailTxtFd.text = profileModel?.email ?? (UserDefault.sharedInstance?.getUserDetails()?.email ?? "")
        self.userProfileImageView.sd_setImage(with: URL(string: URLS.baseUrl.getDescription() + (profileModel?.image ?? (UserDefault.sharedInstance?.getUserDetails()?.image ?? ""))), placeholderImage: #imageLiteral(resourceName: "profilePlaceholder"), options: .highPriority, context: nil)
    }
    
    //MARK:- Objc Methods
    
    //MARK:- IBActions
    
    @IBAction func tappedEditProfile(_ sender: UIButton) {
        imagePicker?.media = .photosGalleryAndCamera
        imagePicker?.showPickerAlert(view: self.view)
    }
    
    @IBAction func tappedUpdateBtn(_ sender: UIButton) {
        if usernameTxtFld.text?.replacingOccurrences(of: " ", with: "") == ""{
            self.showToast(message: "Please enter your name.")
        }
        else{
         EditProfile()
        }
    }
    
}

//MARK:- API Calls

extension EditProfileViewController{
    
    func EditProfile(){
        Indicator.shared.showProgressView(self.view)
        viewModel.editProfile(imageName: self.imageName, imageData: self.imageData, imageMimeType: self.imageType, userName: self.usernameTxtFld.text ?? "", userId: UserDefault.sharedInstance?.getUserDetails()?.id ?? "") { isSuccess,message in
            Indicator.shared.hideProgressView()
            if isSuccess{
                self.navigationController?.popViewController(animated: true)
            }
            else{
                self.showToast(message: message)
            }
        }
    }

}

//MARK:- ImagePicker Delegates

extension EditProfileViewController:ImagePickerDelegate{

    func didSelect(Mediadata: Data?, uploadType: whatToUpload?) {
        if let data = Mediadata{
            self.userProfileImageView.image = UIImage(data: data)
            self.imageData = data
            self.imageName = self.generateUniqueName(withSuffix: ".jpeg")
            self.imageType = "image/jpeg"
        }
        else{
            self.showToast(message: "Could not pick image")
        }
    }
    
}
