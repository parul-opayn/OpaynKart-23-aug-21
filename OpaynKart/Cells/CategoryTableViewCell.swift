//
//  CategoryTableViewCell.swift
//  OpaynKart
//
//  Created by OPAYN on 16/08/21.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    
    //MARK:- IBOutlets
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    
    
    
    //MARK:- Oulets for Profile
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var settingImage: UIImageView!
    
    //MARK:- Outets for Shop By Category
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptonLbl: UILabel!
    @IBOutlet weak var categoryImageHeight: NSLayoutConstraint!
    @IBOutlet weak var categoryImageWidth: NSLayoutConstraint!
    
    //MARK:- Variables
    
    var controller = UIViewController()
    var isLayoutDone = false
    
    //MARK:- Life Cycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}


//MARK:- CollectionView Delegates

extension CategoryTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        if !cell.isLayoutDone{
            cell.productNameLbl.changeFontSize()
            cell.productPPriceLbl.changeFontSize()
            cell.isLayoutDone = true
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            if width <= 0 || height <= 0{
                return CGSize(width: width / 4.5, height: height)
            }
            else{
            return CGSize(width: width / 4.5 - 8, height: categoriesCollectionView.bounds.height)
            }
        }
        else{
            
            if width <= 0 || height <= 0{
                print("Found negative at \(indexPath)")
                return CGSize(width: width / 2.5, height: collectionView.bounds.height)
            }
            else{
                return CGSize(width: width / 2.5, height: height)
            }
            
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.controller.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        self.controller.navigationController?.pushViewController(vc, animated: true)
    }
    
}
