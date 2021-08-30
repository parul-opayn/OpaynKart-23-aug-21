//
//  ProductsCategoryViewController.swift
//  OpaynKart
//
//  Created by OPAYN on 16/08/21.
//

import UIKit
import SDWebImage

class ProductsCategoryViewController: UIViewController{
   
    //MARK:- IBOutlets
   
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var bannerPageControl: UIPageControl!
    @IBOutlet weak var categoriesCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    //MARK:- Variables
    
    var userSelectedIndex = -1
    var searchBar = UISearchBar()
    var searchTextField = UITextField()
    var viewModel = ProductsCategoryViewModel()
    
    //MARK:- Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        setUpTextField()
        homeAPI()
        productsAPI(type: "trending")
        NotificationCenter.default.addObserver(self, selector: #selector(isTokenExpired), name: .expiredToken, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isNavigationBarHidden = false
        self.navigationWithTwoRightButtons()
    }
    
    //MARK:- Custom Methods
    
    func setUpTextField(){
        searchTextField.placeholder = "Search Here"
        searchTextField.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width - 32, height: 32)
        searchTextField.borderStyle = .none
        searchTextField.returnKeyType = .search
        searchTextField.leftViewMode = .always
        searchTextField.delegate = self
        searchTextField.backgroundColor = UIColor(named: "AppLightGray")
        searchTextField.layer.cornerRadius = 8
        let imageView = UIImageView(frame: CGRect(x: 8.0, y: 10, width: 20.0, height: 20.0))
        let image = #imageLiteral(resourceName: "miniSearch")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit

        let view = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 40))
        view.addSubview(imageView)
        searchTextField.leftViewMode = .always
        searchTextField.leftView = view
        self.navigationItem.titleView = searchTextField
    }
    
    //MARK:- Objc Methods
    
    @objc func singleTap(sender: UITapGestureRecognizer) {
        self.searchBar.resignFirstResponder()
    }
    
    @objc func isTokenExpired(){
        if let index = self.tabBarController?.selectedIndex,let navController = self.tabBarController?.viewControllers?[index] as? UINavigationController, let visibleController = navController.viewControllers.last{
            print("visibleController = \(visibleController)")
            UserDefaults.standard.removeObject(forKey: "userData")
            UserDefault.sharedInstance?.removeUserData()
            UserDefault.sharedInstance?.updateUserData()
            visibleController.showAlertWithAction(Title: "Opayn Kart", Message: "Session Expired! Please login to continue", ButtonTitle: "OK") {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                vc.hidesBottomBarWhenPushed = true
                visibleController.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
    @objc func tappedWishlist(sender:UIButton){
        let wishlist = self.viewModel.productsModel[sender.tag].isWishlist ?? false
        var status = ""
        if wishlist{
            status = "0"
        }
        else{
            status = "1"
        }
        self.viewModel.productsModel[sender.tag].isWishlist = !wishlist
        self.productsCollectionView.reloadItems(at: [IndexPath(row: sender.tag, section: 0)])
        self.wishlistAPI(productId: viewModel.productsModel[sender.tag].id ?? "", status: status, atIndex: sender.tag)
    }
    
    //MARK:- IBActions
    

}

//MARK:- CollectionView Delegates

extension ProductsCategoryViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bannerCollectionView{
            return viewModel.home?.banner?.count ?? 0
        }
        else if collectionView == productsCollectionView{
            return viewModel.productsModel.count
        }
        else{
            return viewModel.home?.categories?.count ?? 0
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        if collectionView == bannerCollectionView{
            let cell = self.bannerCollectionView.dequeueReusableCell(withReuseIdentifier: "WalkThroughTableViewCell", for: indexPath) as! WalkThroughTableViewCell
            cell.bannerImage.sd_setImage(with: URL(string: (viewModel.home?.banner?[indexPath.row].image ?? "")), placeholderImage: #imageLiteral(resourceName: "placeholder Image"), options: .highPriority, context: nil)
            return cell
        }
        else if collectionView == productsCollectionView{
            let cell = self.productsCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
            cell.productNameLbl.text = viewModel.productsModel[indexPath.row].name ?? ""
            cell.productPPriceLbl.text = "$" + (viewModel.productsModel[indexPath.row].salePrice ?? "")
            cell.productImage.sd_setImage(with: URL(string:  (viewModel.productsModel[indexPath.row].images?.first ?? "")), placeholderImage: #imageLiteral(resourceName: "placeholder Image"), options: .highPriority, context: nil)
            cell.wishlistBtn.addTarget(self, action: #selector(tappedWishlist(sender:)), for: .touchUpInside)
            cell.wishlistBtn.tag = indexPath.row
            if viewModel.productsModel[indexPath.row].isWishlist ?? false{
                cell.wishlistBtn.setImage(#imageLiteral(resourceName: "filledWishlist").withRenderingMode(.alwaysTemplate).withTintColor(.red), for: .normal)
            }
            else{
                cell.wishlistBtn.setImage(#imageLiteral(resourceName: "emptyWishlist"), for: .normal)
            }
            cell.wishlistBtn.isHidden = true
            return cell
        }
        else{
            let cell = self.categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
            if self.userSelectedIndex == indexPath.row{
                cell.backView.backgroundColor = UIColor.orange.withAlphaComponent(0.2)
                cell.categorylabel.textColor = UIColor(named: "MainOrange")
            }
            else{
                cell.backView.backgroundColor = .lightGray
                cell.categorylabel.textColor = .white
            }
            
            if !cell.isLayoutDone{
                cell.categorylabel.changeFontSize()
                cell.isLayoutDone = true
            }
            cell.categorylabel.text = viewModel.home?.categories?[indexPath.row].name ?? ""
            return cell
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == bannerCollectionView{
            if UIDevice.current.userInterfaceIdiom == .pad{
                return CGSize(width: bannerCollectionView.bounds.width, height: bannerCollectionView.bounds.height)
            }
            else{
                return CGSize(width: bannerCollectionView.bounds.width, height: bannerCollectionView.bounds.height)
            }
          
        }
        else if collectionView == productsCollectionView{
            if UIDevice.current.userInterfaceIdiom == .pad{
                return CGSize(width: productsCollectionView.bounds.width / 3 - 8, height: productsCollectionView.bounds.height / 2)
            }
            else{
                return CGSize(width: productsCollectionView.bounds.width / 2 - 4, height: productsCollectionView.bounds.height / 1.5)
            }
        }
        else{
            
            if UIDevice.current.userInterfaceIdiom == .pad{
                return CGSize(width: categoryCollectionView.bounds.width / 6 - 2, height: categoryCollectionView.bounds.height)
            }
            else{
                    return CGSize(width: categoryCollectionView.bounds.width / 3 - 2, height: categoryCollectionView.bounds.height)
            }
            
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == bannerCollectionView{
            
        }
        else if collectionView == categoryCollectionView{
            self.userSelectedIndex = indexPath.row
            self.categoryCollectionView.reloadData()
            self.categoryCollectionView.scrollToItem(at: indexPath, at: .right, animated: true)
            self.categoryWiseproductsAPI(categoryId: self.viewModel.home?.categories?[indexPath.row].id ?? "")
            
        }
        else{
            let vc = self.storyboard?.instantiateViewController(identifier: "ProductDetailsViewController") as! ProductDetailsViewController
            vc.id = viewModel.productsModel[indexPath.row].id ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if  let collectionView = scrollView as? UICollectionView{
            if collectionView == self.bannerCollectionView{
                let x = scrollView.contentOffset.x
                let w = scrollView.bounds.size.width
                let currentPage = Int(ceil(x/w))
                print("collection view current page = \(currentPage)")
                self.bannerPageControl.currentPage = currentPage
            }
        }
       
       
    }
}

//MARK:- UISearchBar Delegates

extension ProductsCategoryViewController:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked(_ searchBar: UISearchBar)")
        self.searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarCancelButtonClicked")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidEndEditing")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searc text \(searchText)")
    }
}

//MARK:- UITextField Delegates

extension ProductsCategoryViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewViewController") as! SearchViewViewController
        textField.resignFirstResponder()
        vc.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
}

//MARK:-API Calls

extension ProductsCategoryViewController{
    
    func homeAPI(){
        Indicator.shared.showProgressView(self.view)
        self.viewModel.homeAPI { isSuccess, message in
            Indicator.shared.hideProgressView()
            if isSuccess{
                self.bannerPageControl.numberOfPages = self.viewModel.home?.banner?.count ?? 0
                self.bannerCollectionView.reloadData()
                self.categoryCollectionView.reloadData()
            }
            else{
                self.showToast(message: message)
            }
        }
    }
    
    
    func productsAPI(type:String){
        Indicator.shared.showProgressView(self.view)
        self.viewModel.productsAPI(type: type){ isSuccess, message in
            Indicator.shared.hideProgressView()
            if isSuccess{
                self.productsCollectionView.reloadData()
            }
            else{
                self.showToast(message: message)
            }
        }
    }
    
    func wishlistAPI(productId:String,status:String,atIndex:Int){
       // Indicator.shared.showProgressView(self.view)
        self.viewModel.wishlistItem(user_id:UserDefault.sharedInstance?.getUserDetails()?.id ?? "",product_id: productId,status: status){ isSuccess, message in
            //Indicator.shared.hideProgressView()
            if isSuccess{
                print("wishlist updated")
            }
            else{
                let model = self.viewModel.productsModel[atIndex]
                self.viewModel.productsModel[atIndex].isWishlist = !(model.isWishlist ?? false)
                self.productsCollectionView.reloadItems(at: [IndexPath(row: atIndex, section: 0)])
                self.showToast(message: message)
            }
        }
    }
    
    func categoryWiseproductsAPI(categoryId:String){
        Indicator.shared.showProgressView(self.view)
        self.viewModel.categoryWiseProducts(categoryId: categoryId){ isSuccess, message in
            Indicator.shared.hideProgressView()
            if isSuccess{
                self.productsCollectionView.reloadData()
            }
            else{
                self.productsCollectionView.reloadData()
                self.showToast(message: message)
            }
        }
    }
    
}

