//
//  FiltersViewController.swift
//  OpaynKart
//
//  Created by OPAYN on 18/08/21.
//

import UIKit
import DropDown

class FiltersViewController: UIViewController {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var sliderValue: UILabel!
    @IBOutlet weak var sortByBtn: UIButton!
    @IBOutlet weak var colorBtn: UIButton!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var sortByValue: UILabel!
    @IBOutlet weak var colorValueLbl: UILabel!
    @IBOutlet weak var categoryValueLbl: UILabel!
    
    //MARK:- Variables
    
    let dropdown = DropDown()
    var sort = false
    
    //MARK:- Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    //MARK:- Objc Methods
    
    //MARK:- IBActions
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        sliderValue.text = String(format: "%.0f", sender.value)
    }
    
    @IBAction func tappedApplyFilter(_ sender: UIButton) {
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
        dropdown.dataSource = ["Men","Women","Children"]
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
        }
    }
    @IBAction func tappedView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedCloseBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
