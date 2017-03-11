//
//  AdminTableViewCell.swift
//  AppShop
//
//  Created by Admin on 11/03/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class AdminCustomTableViewCell: UITableViewCell {

    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
