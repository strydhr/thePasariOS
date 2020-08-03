//
//  addToOderPopup.swift
//  ThePasar
//
//  Created by Satyia Anand on 30/07/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit

class addToOderPopup: UIViewController {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var breakfastBtn: UIButton!
    @IBOutlet weak var lunchBtn: UIButton!
    @IBOutlet weak var dinnerBtn: UIButton!
    @IBOutlet weak var timeTF: UITextField!
    @IBOutlet weak var orderCountTF: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var addToCartBtn: UIButton!
    
    @IBOutlet weak var mealsView: UIView!
    @IBOutlet weak var mealsSeparatorView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    var selectedProduct:Product?
    var orderCount = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDatas()
        initalSettings()
    }
    @IBAction func breakfastBtnPressed(_ sender: UIButton) {
    }
    @IBAction func lunchBtnPressed(_ sender: UIButton) {
    }
    
    @IBAction func dinnerBtnPressed(_ sender: UIButton) {
    }
    @IBAction func minusBtnPressed(_ sender: UIButton) {
        if orderCount != 1{
            orderCount -= 1
            orderCountTF.text = String(orderCount)
            let newTotal = Double(orderCount) * selectedProduct!.price
            totalLabel.text = "RM " + String(format: "%.2f", newTotal)
        }
    }
    @IBAction func addBtnPressed(_ sender: UIButton) {
        orderCount += 1
        orderCountTF.text = String(orderCount)
        let newTotal = Double(orderCount) * selectedProduct!.price
        totalLabel.text = "RM " + String(format: "%.2f", newTotal)
    }
    
    @IBAction func addToCardBtnPressed(_ sender: UIButton) {
    }
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension addToOderPopup{
    func loadDatas(){
        productName.text = selectedProduct?.name
        productImage.cacheImage(imageUrl: selectedProduct!.profileImage)
        productDescription.text = selectedProduct?.details
        productPrice.text = "RM " + String(format: "%.2f", selectedProduct!.price)
    }
    
    func initalSettings(){
        orderCountTF.text = String(orderCount)
        totalLabel.text = "RM " + String(format: "%.2f", selectedProduct!.price)
        
        if selectedProduct?.type == "Handmade"{
            mealsView.isHidden = true
            heightConstraint.constant = 0
            mealsSeparatorView.isHidden = true
        }
        
        let calendar = Calendar.current
        let currentTime = Date()
        let components = calendar.dateComponents([.hour, .month], from: currentTime)
        
        let breakfast = 8
        let lunch = 12
        let dinner = 19
       
        if ((6..<9).contains(components.hour!) ){
            breakfastBtn.isEnabled = true
        }else{
            breakfastBtn.isEnabled = false
            breakfastBtn.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        }
        
        if ((6..<13).contains(components.hour!) ){
            lunchBtn.isEnabled = true
        }else{
            lunchBtn.isEnabled = false
            lunchBtn.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        }
        if ((6..<20).contains(components.hour!) ){
            dinnerBtn.isEnabled = true
        }else{
            dinnerBtn.isEnabled = false
            dinnerBtn.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        }
    }
}
