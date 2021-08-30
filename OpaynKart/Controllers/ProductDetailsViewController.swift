//
//  ProductDetailsViewController.swift
//  OpaynKart
//
//  Created by OPAYN on 17/08/21.
//

import UIKit

class ProductDetailsViewController: UIViewController {

    //MARK:- IBOutlets
    
    @IBOutlet weak var productDetailsCollection: UICollectionView!
    @IBOutlet weak var sizeCollectionView: UICollectionView!
    @IBOutlet weak var reviewsTableView: UITableView!
    @IBOutlet weak var DetailsLabel: UILabel!
    @IBOutlet weak var detailsBtn: UIButton!
    @IBOutlet weak var detailsBtnView: UIView!
    @IBOutlet weak var reviewBtn: UIButton!
    @IBOutlet weak var reviewsBtnView: UIView!
    @IBOutlet weak var reviewTableHeight: NSLayoutConstraint!
    @IBOutlet weak var addToCartBtn: SetButton!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productPriceLbl: UILabel!
    @IBOutlet weak var wishBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    //MARK:- Variables
    
    var userSelectedIndex = -1
    var viewModel = ProductDetailsViewModel()
    var id = ""
    //MARK:- Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsBtn.setTitleColor(UIColor(named: "MainOrange"), for: .normal)
        detailsBtnView.isHidden = false
        reviewBtn.setTitleColor(.black, for: .normal)
        reviewsBtnView.isHidden = true
        reviewsTableView.isHidden = true
        DetailsLabel.isHidden = false
        reviewsTableView.delegate = self
        reviewsTableView.dataSource = self
        reviewTableHeight.constant = 0
        delegateAndDataSources()
        self.navigationWithCart()
        fontsAdjustment()
        productDetailsAPI()
    }
    
    //MARK:- Custom Methods
    
    func delegateAndDataSources(){
        self.reviewsTableView.delegate = self
        self.reviewsTableView.dataSource = self
        self.sizeCollectionView.delegate = self
        self.sizeCollectionView.dataSource = self
        self.productDetailsCollection.delegate = self
        self.productDetailsCollection.dataSource = self
    }
    
    func fontsAdjustment(){
        detailsBtn.changeButtonLayout()
        detailsBtn.changeFontSize()
        
        reviewBtn.changeButtonLayout()
        reviewBtn.changeFontSize()
        
        addToCartBtn.changeButtonLayout()
        addToCartBtn.changeFontSize()
    }
    
    //MARK:- Objc Methods
    
    //MARK:- IBActions
    
    @IBAction func tappedDetailsBtn(_ sender: UIButton) {
        detailsBtn.setTitleColor(UIColor(named: "MainOrange"), for: .normal)
        detailsBtnView.isHidden = false
        reviewBtn.setTitleColor(.black, for: .normal)
        reviewsBtnView.isHidden = true
        reviewsTableView.isHidden = true
        DetailsLabel.isHidden = false
        self.reviewTableHeight.constant = 0
    }
    @IBAction func tappedReviewsBtn(_ sender: UIButton) {
        reviewBtn.setTitleColor(UIColor(named: "MainOrange"), for: .normal)
        reviewsBtnView.isHidden = false
        detailsBtn.setTitleColor(.black, for: .normal)
        detailsBtnView.isHidden = true
        reviewsTableView.isHidden = false
        DetailsLabel.isHidden = true
        self.reviewsTableView.reloadData()
        self.updateTableHeight(tableName: reviewsTableView, tableHeight: reviewTableHeight)
    }
    
    @IBAction func tappedWishlistBtn(_ sender: UIButton) {
        
        if UserDefaults.standard.value(forKey: "token") != nil{
          
            let wishStatus = self.viewModel.detailsModel?.wishlist_status
            if self.viewModel.detailsModel != nil{
                if !(wishStatus ?? false){
                    self.viewModel.detailsModel?.wishlist_status = true
                    wishlistAPI(productId: self.id, status: "")
                    self.wishBtn.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
                }
                else{
                    self.viewModel.detailsModel?.wishlist_status = false
                    self.wishBtn.setImage(#imageLiteral(resourceName: "emptyWishlist"), for: .normal)
                    wishlistAPI(productId: self.id, status: "")
                }
            }
            else{
                self.wishBtn.setImage(#imageLiteral(resourceName: "emptyWishlist"), for: .normal)
            }
        }
        else{
            self.showAlert(Title: "OPayn Kart", Message: "Login required.", ButtonTitle: "Ok")
        }
    }
    
    @IBAction func tappedAddToCart(_ sender: UIButton) {
        
        if UserDefaults.standard.value(forKey: "token") != nil{
          addProductToCart()
        }
        else{
            self.showAlert(Title: "OPayn Kart", Message: "Login required.", ButtonTitle: "Ok")
        }
    }
}

//MARK:- TableView Delegates

extension ProductDetailsViewController:UITableViewDelegate,UITableViewDataSource{
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reviewsTableView.dequeueReusableCell(withIdentifier: "ReviewsTableViewCell") as! ReviewsTableViewCell
        return cell
    }
    
    
}

//MARK:- CollectionView Delegates

extension ProductDetailsViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == sizeCollectionView{
            return 10
        }
        else{
            return viewModel.detailsModel?.images?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == sizeCollectionView{
            let cell = self.sizeCollectionView.dequeueReusableCell(withReuseIdentifier: "SizeCollectionViewCell", for: indexPath) as! SizeCollectionViewCell
            if self.userSelectedIndex == indexPath.row{
                cell.backView.backgroundColor = UIColor.orange.withAlphaComponent(0.2)
                cell.sizeLabel.textColor = UIColor(named: "MainOrange")
            }
            else{
                cell.backView.backgroundColor = .lightGray
                cell.sizeLabel.textColor = .darkGray
            }
            return cell
        }
        else{
            let cell = self.productDetailsCollection.dequeueReusableCell(withReuseIdentifier: "ProductDetailsCollectionViewCell", for: indexPath) as! ProductDetailsCollectionViewCell
            cell.productImageView.sd_setImage(with: URL(string: viewModel.detailsModel?.images?[indexPath.row] ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder Image"), options: .highPriority, context: nil)
            return cell
        }
       
       
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == productDetailsCollection{
            return CGSize(width: collectionView.bounds.width - 0, height: collectionView.bounds.height)
        }
        else{
           
           return CGSize(width: collectionView.bounds.width / 4 - 2, height: collectionView.bounds.height)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == productDetailsCollection{
            return 0
        }
        else{
            return 2
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == productDetailsCollection{
            return 0
        }
        else{
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == sizeCollectionView{
            self.userSelectedIndex = indexPath.row
            self.sizeCollectionView.reloadData()
        }
       
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if  let collectionView = scrollView as? UICollectionView{
            if collectionView == self.productDetailsCollection{
                let x = scrollView.contentOffset.x
                let w = scrollView.bounds.size.width
                let currentPage = Int(ceil(x/w))
                print("collection view current page = \(currentPage)")
                self.pageControl.currentPage = currentPage
            }
        }
       
       
    }
    
}

//MARK:- API Calls

extension ProductDetailsViewController{
    
    func productDetailsAPI(){
        Indicator.shared.showProgressView(self.view)
        self.viewModel.productDetails(productId: self.id){ isSuccess, message in
            Indicator.shared.hideProgressView()
            if isSuccess{
                self.productDetailsCollection.reloadData()
                if self.viewModel.detailsModel?.wishlist_status ?? false{
                    self.wishBtn.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
                }
                else{
                    self.wishBtn.setImage(#imageLiteral(resourceName: "emptyWishlist"), for: .normal)
                }
                self.pageControl.numberOfPages = self.viewModel.detailsModel?.images?.count ?? 0
                self.productNameLbl.text = self.viewModel.detailsModel?.name ?? ""
                self.productPriceLbl.text = "$" + (self.viewModel.detailsModel?.salePrice ?? "")
                self.DetailsLabel.text = self.viewModel.detailsModel?.productDetailsModelDescription ?? ""
            }
            else{
                self.pageControl.numberOfPages = self.viewModel.detailsModel?.images?.count ?? 0
                self.showToast(message: message)
            }
        }
    }
    
    func wishlistAPI(productId:String,status:String){
        
        self.viewModel.wishlistItem(user_id:UserDefault.sharedInstance?.getUserDetails()?.id ?? "",product_id: productId,status: status){ isSuccess, message in
            if isSuccess{
                print("wishlist updated")
            }
            else{
                let wishStatus = self.viewModel.detailsModel?.wishlist_status
                if self.viewModel.detailsModel != nil{
                    if !(wishStatus ?? false){
                        self.viewModel.detailsModel?.wishlist_status = true
                        self.wishBtn.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
                    }
                    else{
                        self.viewModel.detailsModel?.wishlist_status = false
                        self.wishBtn.setImage(#imageLiteral(resourceName: "emptyWishlist"), for: .normal)
                    }
                }
                else{
                    self.wishBtn.setImage(#imageLiteral(resourceName: "emptyWishlist"), for: .normal)
                }
                self.showToast(message: message)
            }
        }
    }
    
    
    func addProductToCart(){
        Indicator.shared.showProgressView(self.view)
        self.viewModel.addToCart(productId: self.id,quantity:1){ isSuccess, message in
            Indicator.shared.hideProgressView()
            if isSuccess{
                self.showToast(message: "Product added to cart.")
                self.tabBarController?.selectedIndex = 1
            }
            else{
                self.showToast(message: message)
            }
        }
    }

}
