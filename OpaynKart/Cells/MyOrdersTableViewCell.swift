//
//  MyOrdersTableViewCell.swift
//  OpaynKart
//
//  Created by OPAYN on 17/08/21.
//

import UIKit

class MyOrdersTableViewCell: UITableViewCell {

    @IBOutlet weak var orderImage: UIImageView!
    @IBOutlet weak var deliveredOnLbl: UILabel!
    @IBOutlet weak var productDetailsLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var quantityLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
