//
//  addToOderPopup.swift
//  ThePasar
//
//  Created by Satyia Anand on 30/07/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CodableFirebase

protocol updateCartDelegate {
    func updatedCart(items:[itemPurchasing],hasDelivery:Bool,sendBy:Date?)
}

class addToOderPopup: UIViewController {
    // First Timers
    @IBOutlet weak var mainHintContainer: UIView!
    @IBOutlet weak var firstHint: UIView!
    @IBOutlet weak var secondHint: UIView!
    @IBOutlet weak var secondHintBlinky: UIImageView!
    
    var page = 1
    let defaults = UserDefaults.standard
    //
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var breakfastBtn: UIButton!
    @IBOutlet weak var lunchBtn: UIButton!
    @IBOutlet weak var dinnerBtn: UIButton!
    @IBOutlet weak var increaseBtn: UIButton!
    @IBOutlet weak var decreaseBtn: UIButton!
    @IBOutlet weak var timeTF: UITextField!
    @IBOutlet weak var orderCountTF: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var addToCartBtn: UIButton!
    
    @IBOutlet weak var mealsView: UIView!
    @IBOutlet weak var mealsSeparatorView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var delegate:updateCartDelegate?
    
    var productMaxStock:Int?
    
    var selectedProduct:Product?
    var orderCount = 1
    
    let timePicker = UIPickerView()
    let doneBtnTime = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector (donePickingTime))
    var category = [String]()
    
    var items = [itemPurchasing]()
    var hasDeliveryTime = false
    var deliveryTime:Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        loadDatas()
        initalSettings()
        scrollView.isScrollEnabled = false
        
        mainHintContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nextHint)))
        
        
    }
    
    @objc func donePickingTime(){
        breakfastBtn.isEnabled = true
        lunchBtn.isEnabled = true
        dinnerBtn.isEnabled = true
        timeTF.resignFirstResponder()
        
        //            timeTF.text = dateFormatter.string(from: timePicker.date)
        //            time = timePicker.date
        //
        //
        //            let fulldateFormat = DateFormatter()
        //            fulldateFormat.locale = Locale(identifier: "en_US_POSIX")
        //            fulldateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        //            print(fulldateFormat.string(from: timePicker.date))
        
        
        self.view.endEditing(true)
    }
    
    @objc func nextHint(){
        if page == 1{
            firstHint.isHidden = true
            secondHint.isHidden = false
            page = 2
        }else if page == 2{
//            secondHint.isHidden = true
            mainHintContainer.isHidden = true
        scrollView.isScrollEnabled = true
            defaults.set(true, forKey: "addOrderHintDone")
            
        }
    }
    
    @IBAction func breakfastBtnPressed(_ sender: UIButton) {
        bfastTimePicker()
    }
    @IBAction func lunchBtnPressed(_ sender: UIButton) {
        lunchTimePicker()
    }
    
    @IBAction func dinnerBtnPressed(_ sender: UIButton) {
        dinnerTimePicker()
    }
    @IBAction func minusBtnPressed(_ sender: UIButton) {
        if selectedProduct?.type == "Handmade"{
            if orderCount != 1{
                increaseBtn.isUserInteractionEnabled = true
                increaseBtn.tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
                orderCount -= 1
                orderCountTF.text = String(orderCount)
                let newTotal = Double(orderCount) * selectedProduct!.price
                totalLabel.text = "RM " + String(format: "%.2f", newTotal)
            }
            
        }else{
            if orderCount != 1{
                orderCount -= 1
                orderCountTF.text = String(orderCount)
                let newTotal = Double(orderCount) * selectedProduct!.price
                totalLabel.text = "RM " + String(format: "%.2f", newTotal)
            }
        }

    }
    @IBAction func addBtnPressed(_ sender: UIButton) {
        if selectedProduct?.type == "Handmade"{
            orderCount += 1
            orderCountTF.text = String(orderCount)
            let newTotal = Double(orderCount) * selectedProduct!.price
            totalLabel.text = "RM " + String(format: "%.2f", newTotal)
            
            if orderCount == selectedProduct?.count{
                increaseBtn.isUserInteractionEnabled = false
                increaseBtn.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            }
        }else{
            orderCount += 1
            orderCountTF.text = String(orderCount)
            let newTotal = Double(orderCount) * selectedProduct!.price
            totalLabel.text = "RM " + String(format: "%.2f", newTotal)
        }
        
    }
    
    @IBAction func addToCardBtnPressed(_ sender: UIButton) {
        errorHandler(readyTime: timeTF.text!)

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
        
        if hasDeliveryTime{
            print(deliveryTime)
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .month], from: deliveryTime!)
            print(components.hour)
            timeTF.text = "\((components.hour)!):00"
        }
    }
    
    func initalSettings(){
        orderCountTF.text = String(orderCount)
        totalLabel.text = "RM " + String(format: "%.2f", selectedProduct!.price)
        
        if selectedProduct?.type == "Handmade"{
            mealsView.isHidden = true
            heightConstraint.constant = 0
            mealsSeparatorView.isHidden = true
        }else{
            hasDeliveryTime = true
            let isFirstTime = UserDefaults.exist(key: "addOrderHintDone")
            print(isFirstTime)
            if isFirstTime == false{
                firstTimeHelper()
            }
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
    func bfastTimePicker(){
        lunchBtn.isEnabled = false
        dinnerBtn.isEnabled = false
        timeTF.isUserInteractionEnabled = true
        timePicker.delegate = self
        timePicker.dataSource = self
        timeTF.text = ""
        
        timeTF.inputView = timePicker
        timeTF.placeholder = "Meals ready by.."
        
        let newToolbar = UIToolbar()
        newToolbar.sizeToFit()
        
        
        newToolbar.setItems([doneBtnTime], animated: false)
        newToolbar.isUserInteractionEnabled = true
        timeTF.inputAccessoryView = newToolbar
        
        let calendar = Calendar.current
        let currentTime = Date()
        let components = calendar.dateComponents([.hour, .month], from: currentTime)
        
        category.removeAll()
        for i in 7...10{
            if i - components.hour! >= 2{
                category.append("\(i):00")
            }
        }
    }
    
    
    func lunchTimePicker(){
        breakfastBtn.isEnabled = false
        dinnerBtn.isEnabled = false
        timeTF.isUserInteractionEnabled = true
        timePicker.delegate = self
        timePicker.dataSource = self
        timeTF.text = ""
        
        timeTF.inputView = timePicker
        timeTF.placeholder = "Meals ready by.."
        
        let newToolbar = UIToolbar()
        newToolbar.sizeToFit()


        newToolbar.setItems([doneBtnTime], animated: false)
        newToolbar.isUserInteractionEnabled = true
        timeTF.inputAccessoryView = newToolbar

        let calendar = Calendar.current
        let currentTime = Date()
        let components = calendar.dateComponents([.hour, .month], from: currentTime)

        category.removeAll()
        for i in 11...14{
            if i - components.hour! >= 2{
                category.append("\(i):00")
            }
        }
    }
    
    
    func dinnerTimePicker(){
        breakfastBtn.isEnabled = false
        lunchBtn.isEnabled = false
        timeTF.isUserInteractionEnabled = true
        timePicker.delegate = self
        timePicker.dataSource = self
        timeTF.text = ""
        
        timeTF.inputView = timePicker
        timeTF.placeholder = "Meals ready by.."
        
        let newToolbar = UIToolbar()
        newToolbar.sizeToFit()
        
        
        newToolbar.setItems([doneBtnTime], animated: false)
        newToolbar.isUserInteractionEnabled = true
        timeTF.inputAccessoryView = newToolbar
        
        let calendar = Calendar.current
        let currentTime = Date()
        let components = calendar.dateComponents([.hour, .month], from: currentTime)
        
        category.removeAll()
        for i in 17...20{
            if i - components.hour! >= 2{
                category.append("\(i):00")
            }
        }
        
    }
    
    func errorHandler(readyTime:String){
        if selectedProduct?.type != "Handmade"{
            if readyTime.isEmpty{
                
            }else{
                //
                let selectedDateFormatter = DateFormatter()
                selectedDateFormatter.dateFormat = "yyyy-MM-dd"

                let timeFormatter = DateFormatter()
//                timeFormatter.dateFormat = "hh:mm a"
                timeFormatter.dateFormat = "HH:mm"
                timeFormatter.timeZone = TimeZone(secondsFromGMT: 0)

                let date = selectedDateFormatter.string(from: Date())
                let time = timeTF.text

                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.dateFormat = "yyyy-MM-dd 'at' HH:mm"
                let string = date + " at " + time!
                let finalDate = dateFormatter.date(from: string)
                let finalDateTimeStamp = Timestamp.init(date: finalDate!)
                //
                
                
                let updatedItem = itemPurchasing(productId: selectedProduct!.uid, productName: selectedProduct!.name, productPrice: selectedProduct!.price, itemCount: orderCount, hasDeliveryTime: true, colorClass: selectedProduct!.colorClass)
                items.append(updatedItem)
                deliveryTime = finalDate
                delegate?.updatedCart(items: items, hasDelivery: hasDeliveryTime, sendBy: deliveryTime)
                dismiss(animated: true, completion: nil)
                
            }
        }else{
            let updatedItem = itemPurchasing(productId: selectedProduct!.uid, productName: selectedProduct!.name, productPrice: selectedProduct!.price, itemCount: orderCount, hasDeliveryTime: false, colorClass: selectedProduct!.colorClass)
            items.append(updatedItem)
            if !hasDeliveryTime{
                deliveryTime = Date()
            }

            delegate?.updatedCart(items: items, hasDelivery: hasDeliveryTime, sendBy: deliveryTime)
            dismiss(animated: true, completion: nil)
        }
    }
    func firstTimeHelper(){
        mainHintContainer.isHidden = false
        firstHint.isHidden = false
        secondHint.isHidden = true
        page = 1
        
        self.secondHintBlinky.alpha = 0
        UIView.animate(withDuration: 1, delay: 0.0, options: [.curveLinear, .repeat, .autoreverse]) {
            self.secondHintBlinky.alpha = 1
        } completion: { (success) in
            
        }

    }
}
extension addToOderPopup:UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return category.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return category[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        doneBtnTime.isEnabled = true
        
        timeTF.text = category[row]
        
        
    }
    
}
