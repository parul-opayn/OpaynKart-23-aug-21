//
//  FiltersViewController.swift
//  OpaynKart
//
//  Created by OPAYN on 18/08/21.
//

import UIKit
import DropDown
import RangeSeekSlider

protocol didApplyFilters {
    func filtersData(data:[String:Any])
}

class FiltersViewController: UIViewController {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var sortByBtn: UIButton!
    @IBOutlet weak var sortByValue: UILabel!
    @IBOutlet weak var colorValueLbl: UILabel!
    @IBOutlet weak var categoryValueLbl: UILabel!
    @IBOutlet weak var slider: RangeSeekSlider!
    @IBOutlet weak var subcategoryLbl: UILabel!
    @IBOutlet weak var subCategoryView: UIView!
    @IBOutlet weak var subCategoryViewHeight: NSLayoutConstraint!
    
    //MARK:- Variables
    
    let dropdown = DropDown()
    var sort = false
    var viewController = UIViewController()
    var homeViewModel = ProductsCategoryViewModel()
    var delegate:didApplyFilters?
    var categoriesData = [String]()
    var subCategoriesData = [String]()
    var subCatIds = [String]()
    var selectedCatId = ""
    var selectedSubCatId = ""
    
    //MARK:- Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
    }
    
    //MARK:- Custom Methods
    
    func tickForTack()->Bool{
        if !sort{
            sort = true
        }
        else{
            sort = false
        }
        return sort
    }
    
    func setUpData(){
        if let parentCont = viewController as? ProductsCategoryViewController{
            self.homeViewModel = parentCont.viewModel
            self.categoriesData = self.homeViewModel.home?.categories?.map({$0.name ?? ""}) ?? []
        }
    }
    
    //MARK:- Objc Methods
    
    //MARK:- IBActions
    
    @IBAction func tappedApplyFilter(_ sender: UIButton) {
        homeViewModel.filters(minPrice: "\(Int(self.slider.selectedMinValue))", maxPrice: "\(Int(self.slider.selectedMaxValue))", categoryId: self.selectedCatId, subCategoryId: self.selectedSubCatId, search: "") { isSuccess, message in
           
            if isSuccess{
                self.delegate?.filtersData(data: ["result":"success"])
            }
            else{
                self.delegate?.filtersData(data: ["result":"fail"])
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func sortByDropDown(_ sender: UIButton) {
       
        dropdown.dataSource = ["Low to High","High to Low","Popularity","Relevance"]
        dropdown.direction = .bottom
       dropdown.anchorView = sender
        dropdown.bottomOffset = CGPoint(x: 0, y:sender.frame.size.height)
        dropdown.width = sender.frame.width
        dropdown.heightAnchor.constraint(equalToConstant: 40).isActive = true
        dropdown.selectionAction = {
            [weak self] (index:Int,item:String) in
            guard let self = self else{return}
            self.sortByValue.text  = item
        }
        dropdown.show()
    }
    @IBAction func tapepdColorBtn(_ sender: UIButton) {
        dropdown.dataSource = ["Red","Yellow","Blue","Green"]
        dropdown.anchorView = sender
        dropdown.direction = .bottom
        dropdown.anchorView = sender
        dropdown.bottomOffset = CGPoint(x: 0, y:sender.frame.size.height)
        dropdown.width = sender.frame.width
        dropdown.heightAnchor.constraint(equalToConstant: 40).isActive = true
        dropdown.show()
        dropdown.selectionAction = {
            [weak self] (index:Int,item:String) in
            guard let self = self else{return}
            self.colorValueLbl.text  = item
        }
        
    }
    @IBAction func tappedCategoryBtn(_ sender: UIButton) {
        dropdown.dataSource = self.categoriesData
        dropdown.anchorView = sender
        dropdown.direction = .any
        dropdown.bottomOffset = CGPoint(x: 0, y:sender.frame.size.height)
        dropdown.width = sender.frame.width
        dropdown.heightAnchor.constraint(equalToConstant: 40).isActive = true
        dropdown.show()
        dropdown.selectionAction = {
            [weak self] (index:Int,item:String) in
            guard let self = self else{return}
            self.categoryValueLbl.text  = item
            let subCat = self.homeViewModel.home?.categories?[index].subCategories?.map({$0.name ?? ""}) ?? []
            self.subCategoriesData = subCat
            self.subCatIds = self.homeViewModel.home?.categories?[index].subCategories?.map({$0.id ?? ""}) ?? []
            self.selectedCatId = self.homeViewModel.home?.categories?[index].id ?? ""
            
            if subCat.count == 0{
                self.subCategoryView.isHidden = true
                self.subCategoryViewHeight.constant = 0
            }
            else{
                self.subCategoryView.isHidden = false
                self.subCategoryViewHeight.constant = 70
            }
        }
    }
    
    @IBAction func tappedSubCategoryBtn(_ sender: UIButton) {
        dropdown.dataSource = self.subCategoriesData
        dropdown.anchorView = sender
        dropdown.direction = .any
        dropdown.bottomOffset = CGPoint(x: 0, y:sender.frame.size.height)
        dropdown.width = sender.frame.width
        dropdown.heightAnchor.constraint(equalToConstant: 40).isActive = true
        dropdown.show()
        dropdown.selectionAction = {
            [weak self] (index:Int,item:String) in
            guard let self = self else{return}
            self.subcategoryLbl.text  = item
            self.selectedSubCatId = self.subCatIds[index]
        }
    }
    
    @IBAction func tappedView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedCloseBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
