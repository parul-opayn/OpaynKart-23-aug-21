//
//  wishlistViewController.swift
//  OpaynKart
//
//  Created by OPAYN on 17/08/21.
//

import UIKit
import DropDown

class wishlistViewController: UIViewController {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var wishlistCollectionView: UICollectionView!
    
    //MARK:- Variables
    
    var dropdown = DropDown()
    
    //MARK:- Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wishlistCollectionView.delegate = self
        wishlistCollectionView.dataSource = self
        self.navigationWithTitleOnly(titleString: "Wishlist")
    }
    
    //MARK:- Custom Methods
    
    //MARK:- Objc Methods
    
    @objc func didTapOptions(sender:UIButton){
        dropdown.dataSource = ["Remove from wishlist"]
        dropdown.anchorView = sender
        dropdown.bottomOffset = CGPoint(x: -100 - sender.frame.width, y: sender.frame.height + 8)
       // dropdown.width = 100
        dropdown.show()
    }
    
    //MARK:- IBActions
    
}

//MARK:- CollectionView Delegates

extension wishlistViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.wishlistCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        cell.optionsBtn.addTarget(self, action: #selector(didTapOptions), for: .touchUpInside)
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
