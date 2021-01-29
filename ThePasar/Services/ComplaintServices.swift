//
//  ComplaintServices.swift
//  ThePasar
//
//  Created by Satyia Anand on 08/10/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CodableFirebase

class ComplaintServices {
    static let instance = ComplaintServices()
    
    func lodgeComplaint(receipt:ReceiptDocument,complaint:String,requestComplete:@escaping(_ status:Bool)->()){
        let complaint = Complaint(items: receipt.receipt!.items, date: Timestamp(), deliveryTime: receipt.receipt!.deliveryTime, purchaserId: receipt.receipt!.purchaserId, purchaserName: receipt.receipt!.purchaserName, purchaserAddress: receipt.receipt!.purchaserAddress,purchaserPhone: receipt.receipt!.purchaserPhone, storeId: receipt.receipt!.storeId, storeName: receipt.receipt!.storeName, ownerId: receipt.receipt!.ownerId, receiptId: receipt.documentId!, complaint: complaint, isResolved: false)
        
        let docData = try! FirestoreEncoder().encode(complaint)
        db.collection("complaints").addDocument(data: docData) { (error) in
            if error == nil{
                requestComplete(true)
            }else{
                requestComplete(false)
            }
        }
        
    }
}
