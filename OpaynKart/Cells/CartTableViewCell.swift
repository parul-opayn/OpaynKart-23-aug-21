//
//  CartTableViewCell.swift
//  OpaynKart
//
//  Created by OPAYN on 17/08/21.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productImage: SetImage!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var sizeLbl: UILabel!
    @IBOutlet weak var colorLbl: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var addBtn: SetButton!
    @IBOutlet weak var removeBtn: SetButton!
    @IBOutlet weak var saveForLaterBtn: UIButton!
    
    @IBOutlet weak var quantityBtn: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.adjustLayout()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
