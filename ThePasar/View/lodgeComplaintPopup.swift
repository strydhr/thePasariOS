//
//  lodgeComplaintPopup.swift
//  ThePasar
//
//  Created by Satyia Anand on 08/10/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit

protocol sendComplaintNotificationDelegate {
    func showComplaintComfirmation(status:Bool)
}

class lodgeComplaintPopup: UIViewController {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var complaintTF: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    
    var delegate:sendComplaintNotificationDelegate?
    var receipt:ReceiptDocument?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTextField()
        complaintTF.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        complaintTF.layer.borderWidth = 1
        
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bgTapped)))
    }

    @objc func bgTapped(){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendBtnPressed(_ sender: UIButton) {
        errorHandler(complaintStr: complaintTF.text!)
    }
    

}

extension lodgeComplaintPopup{
    func initTextField(){
        complaintTF.text = "Type complaint here..."
        complaintTF.textColor = #colorLiteral(red: 0.8633741736, green: 0.8699255586, blue: 0.8700513244, alpha: 1)
        complaintTF.delegate = self
    }
    func errorHandler(complaintStr:String){
        if complaintStr.isEmpty{
            
        }else{
            ComplaintServices.instance.lodgeComplaint(receipt: receipt!, complaint: complaintStr) { (isSuccess) in
                if isSuccess{
                    
                    self.delegate?.showComplaintComfirmation(status: true)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}

extension lodgeComplaintPopup:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Type complaint here..."{
            textView.text = ""
            textView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
}
