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
    
    //MARK:- Variables
    
    var userSelectedIndex = -1
    
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
            return 10
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
            return cell
        }
       
       
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == productDetailsCollection{
            return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
        }
        else{
            return CGSize(width: collectionView.bounds.width / 4 - 2, height: collectionView.bounds.height)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == productDetailsCollection{
            return 2
        }
        else{
            return 2
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == productDetailsCollection{
            return 2
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
    
}

