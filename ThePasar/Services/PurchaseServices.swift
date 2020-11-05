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
    
//    func confirmPurchase(receipt:Order,requestComplete:@escaping(_ status: Bool)->()){
//        let docData = try! FirestoreEncoder().encode(receipt)
//        
//        db.collection("orders").addDocument(data: docData) { (error) in
//            if error == nil{
//                requestComplete(true)
//            }
//        }
//    }
    
    func confirmPurchase(receipt:Order)->Bool{
        let docData = try! FirestoreEncoder().encode(receipt)
        
        db.collection("orders").addDocument(data: docData)
        return true
            
        
    }
    
    func listPastPurchases(requestComplete:@escaping(_ list:[ReceiptDocument])->()){
        var receiptList = [ReceiptDocument]()
        let dbRef = db.collection("receipt").whereField("purchaserId", isEqualTo: (userGlobal?.uid)!).whereField("caseClosed", isEqualTo: true)
        dbRef.getDocuments { (snapshot, error) in
            print(snapshot?.count)
            if error == nil{
                guard let document = snapshot?.documents else {return}
                if document.isEmpty{
                    requestComplete(receiptList)
                }else{
                    for items in document{
                        let docData = items.data()
                        print(docData)
                        let receipt = try! FirestoreDecoder().decode(Receipts.self, from: docData)
                        let receiptDoc = ReceiptDocument(documentId: items.documentID, receipt: receipt)
                        receiptList.append(receiptDoc)
                        

                        
                    }
                    requestComplete(receiptList)
                    
                }
            }
        
        }
    }
}
