//
//  CartTableViewCell.swift
//  OpaynKart
//
//  Created by OPAYN on 17/08/21.
//

import UIKit

class CartTableViewCell: UITableViewCell {

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
