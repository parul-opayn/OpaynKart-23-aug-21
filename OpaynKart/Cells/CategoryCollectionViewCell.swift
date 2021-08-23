//
//  CategoryCollectionViewCell.swift
//  OpaynKart
//
//  Created by OPAYN on 16/08/21.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    //MARK:- TopCollection Outlets
    
  
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var categorylabel: UILabel!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productPPriceLbl: UILabel!
   
    //MARK:- Outlets for Wishlist
    
    @IBOutlet weak var optionsBtn: UIButton!
    
    var isLayoutDone = false
}
