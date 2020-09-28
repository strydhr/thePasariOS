//
//  rejectedReasonPopup.swift
//  ThePasar
//
//  Created by Satyia Anand on 24/09/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit

class rejectedReasonPopup: UIViewController {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var reasonLabel: UITextField!
    
    var reason:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reasonLabel.text = reason
        bgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closePopup)))
    }

    @objc func closePopup(){
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
