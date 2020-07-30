//
//  radiusSettingPopup.swift
//  ThePasar
//
//  Created by Satyia Anand on 30/07/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit

protocol updatedRadiusDelegate {
    func updatedRadius(radius:Double)
}

class radiusSettingPopup: UIViewController {
    @IBOutlet weak var radiusTF: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    
    var delegate:updatedRadiusDelegate?
    
    let radiusPicker = UIPickerView()
    let doneBtn = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector (donePicking))
    let category = radiusList
    var selectedRadius:Radius?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        radiusPicker.delegate = self
        radiusPicker.dataSource = self
        createRadiusPicker()
    }
    
    @objc func donePicking(){
        radiusTF.resignFirstResponder()
        
    }

    @IBAction func confirmBtnPressed(_ sender: UIButton) {
        if radiusTF.text!.isEmpty{
            dismiss(animated: true, completion: nil)
        }else{
            delegate?.updatedRadius(radius: selectedRadius!.radius)
            dismiss(animated: true, completion: nil)
        }
    }
    

}
extension radiusSettingPopup:UIPickerViewDelegate,UIPickerViewDataSource{
     func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
       
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return category.count
           
       }
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return category[row].label
       }
       
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           doneBtn.isEnabled = true
        radiusTF.text = category[row].label
        selectedRadius = category[row]
       }
    
    
}

extension radiusSettingPopup{
    func createRadiusPicker(){
        radiusPicker.showsSelectionIndicator = true
        radiusTF.inputView = radiusPicker
        radiusTF.placeholder = "Distance in Km"
        
        let newToolbar = UIToolbar()
        newToolbar.sizeToFit()
        
        
        newToolbar.setItems([doneBtn], animated: false)
        newToolbar.isUserInteractionEnabled = true
        radiusTF.inputAccessoryView = newToolbar
    }
}
