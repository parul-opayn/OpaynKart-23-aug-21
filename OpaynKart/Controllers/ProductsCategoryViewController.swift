//
//  ProductsCategoryViewController.swift
//  OpaynKart
//
//  Created by OPAYN on 16/08/21.
//

import UIKit

class ProductsCategoryViewController: UIViewController {
   
    //MARK:- IBOutlets
    
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    
    //MARK:- Variables
    
    var userSelectedIndex = -1
    var searchBar = UISearchBar()
    var searchTextField = UITextField()
    
    //MARK:- Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productsTableView.delegate = self
        productsTableView.dataSource = self
        let headerNib = UINib.init(nibName: "CategoryHeaderView", bundle: nil)
        productsTableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "ProductHeader")
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
       //searchBarSetup()
        setUpTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isNavigationBarHidden = false
        self.navigationWithTwoRightButtons()
       // searchBar.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        //self.navigationItem.titleView = searchBar
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
    
    //MARK:- IBActions
    

}

//MARK:- TableView Delegates

extension ProductsCategoryViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ProductHeader") as! ProductHeaderView
        //if let header = headerView{
            headerView.contentView.backgroundColor = .white
        //}
        if !headerView.isLayoutDone{
        headerView.titleLbl.changeFontSize()
        headerView.descriptionLbl.changeFontSize()
            headerView.isLayoutDone  = true
        }
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productsTableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell") as! CategoryTableViewCell
        cell.categoriesCollectionView.delegate = cell
        cell.categoriesCollectionView.dataSource = cell
        cell.controller = self
        self.updateCollectionHeight(collectionName: cell.categoriesCollectionView, collectionHeight: cell.collectionHeight)
        cell.categoriesCollectionView.reloadData()
        return cell
    }
    
    
}

//MARK:- CollectionView Delegates

extension ProductsCategoryViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bannerCollectionView{
            return 10
        }
        else{
            return 10
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        if collectionView == bannerCollectionView{
            let cell = self.bannerCollectionView.dequeueReusableCell(withReuseIdentifier: "WalkThroughTableViewCell", for: indexPath) as! WalkThroughTableViewCell
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
                cell.categorylabel.textColor = .darkGray
            }
            
            if !cell.isLayoutDone{
                cell.categorylabel.changeFontSize()
                cell.isLayoutDone = true
            }
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
        else{
            if UIDevice.current.userInterfaceIdiom == .pad{
                return CGSize(width: categoryCollectionView.bounds.width / 8 - 2, height: categoryCollectionView.bounds.height)
            }
            else{
                return CGSize(width: categoryCollectionView.bounds.width / 4 - 2, height: categoryCollectionView.bounds.height)
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
        else{
            self.userSelectedIndex = indexPath.row
            self.categoryCollectionView.reloadData()
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
