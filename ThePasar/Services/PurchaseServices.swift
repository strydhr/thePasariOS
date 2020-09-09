//
//  PurchaseServices.swift
//  ThePasar
//
//  Created by Satyia Anand on 05/08/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CodableFirebase

class PurchaseServices {
    static let instance = PurchaseServices()
    
    func confirmPurchase(receipt:Order,requestComplete:@escaping(_ status: Bool)->()){
        let docData = try! FirestoreEncoder().encode(receipt)
        
        db.collection("orders").addDocument(data: docData) { (error) in
            if error == nil{
                requestComplete(true)
            }
        }
    }
}
