//
//  cartCell.swift
//  ThePasar
//
//  Created by Satyia Anand on 04/08/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit

class cartCell: UITableViewCell {
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemCount: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeLabelHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
