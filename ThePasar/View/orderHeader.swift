//
//  orderHeader.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 05/08/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit

protocol rejectOrderDelegate{
    func rejectOrder(item:Receipts)
}
protocol confirmOrderDelegate{
    func confirmOrder(item:Receipts)
}


class orderHeader: UITableViewCell {
    @IBOutlet weak var deliveryTime: UILabel!
    @IBOutlet weak var deliveryAddress: UILabel!
    @IBOutlet weak var orderCount: UILabel!
    @IBOutlet weak var statusIcon: UIImageView!
    
    @IBOutlet weak var confirmBtn: UIButton!
    
    var delegate: rejectOrderDelegate?
    var delegate2: confirmOrderDelegate?
    var item: Receipts?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        confirmBtn.layer.cornerRadius = 15
        confirmBtn.clipsToBounds = true
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
