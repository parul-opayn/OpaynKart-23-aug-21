//
//  wishlistViewController.swift
//  OpaynKart
//
//  Created by OPAYN on 17/08/21.
//

import UIKit
import DropDown

class wishlistViewController: UIViewController{
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var wishlistCollectionView: UICollectionView!
    
    //MARK:- Variables
    
    var dropdown = DropDown()
    var viewModel = WishlistViewmodel()
    
    //MARK:- Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wishlistCollectionView.delegate = self
        wishlistCollectionView.dataSource = self
        self.navigationWithTitleOnly(titleString: "Wishlist")
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        wishlist()
    }
    
    //MARK:- Custom Methods
    
    //MARK:- Objc Methods
    
    @objc func didTapOptions(sender:UIButton){
//        dropdown.dataSource = ["Remove from wishlist"]
//        dropdown.anchorView = sender
//        dropdown.bottomOffset = CGPoint(x: -100 - sender.frame.width, y: sender.frame.height + 8)
//       // dropdown.width = 100
//        dropdown.show()
        
        wishlistAPI(productId: self.viewModel.wishlistModel[sender.tag].id ?? "", status: "0", atIndex: sender.tag)
        
    }
    
    //MARK:- IBActions
    
}

//MARK:- CollectionView Delegates

extension wishlistViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.wishlistModel.count == 0{
            tableCollectionErrors(view: collectionView, text: "No Items to display")
        }
        else{
            tableCollectionErrors(view: collectionView, text: "")
        }
        return viewModel.wishlistModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.wishlistCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        cell.optionsBtn.addTarget(self, action: #selector(didTapOptions), for: .touchUpInside)
        cell.optionsBtn.tag = indexPath.row
        let model = viewModel.wishlistModel[indexPath.row]
        cell.productImage.sd_setImage(with: URL(string: model.images?.first ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder Image"), options: .highPriority, context: nil)
        cell.productNameLbl.text = model.name ?? "N/A"
        cell.productPPriceLbl.text = "$\(model.salePrice ?? "0")"
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad{
            return CGSize(width: wishlistCollectionView.bounds.width / 4 - 2, height: wishlistCollectionView.bounds.height / 4)
        }
        else{
            return CGSize(width: wishlistCollectionView.bounds.width / 2 - 2, height: wishlistCollectionView.bounds.height / 3 - 2)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

//MARK:- API Calls

extension wishlistViewController{
    
    func wishlist(){
        Indicator.shared.showProgressView(self.view)
        viewModel.wishlist(userId: UserDefault.sharedInstance?.getUserDetails()?.id ?? "") {[weak self] isSuccess, message in
            Indicator.shared.hideProgressView()
            guard let self = self else{return}
            if isSuccess{
                self.wishlistCollectionView.reloadData()
            }
            else{
                self.showToast(message: message)
            }
        }
    }
    
    func wishlistAPI(productId:String,status:String,atIndex:Int){
        Indicator.shared.showProgressView(self.view)
        self.viewModel.wishlistItem(user_id:UserDefault.sharedInstance?.getUserDetails()?.id ?? "",product_id: productId,status: status){ isSuccess, message in
            Indicator.shared.hideProgressView()
            if isSuccess{
                print("wishlist updated")
                self.viewModel.wishlistModel.remove(at: atIndex)
                self.wishlistCollectionView.reloadData()
            }
            else{
                self.showToast(message: message)
            }
        }
    }
    
}
