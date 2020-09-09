//
//  OrderServices.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 06/08/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CodableFirebase

class OrderServices {
    static let instance = OrderServices()
    
    
    func listMyOders(requestComplete:@escaping(_ orderList:[Receipts])->()){
        var orderList = [Receipts]()
        
        let dbRef = db.collection("receipts").whereField("ownerId", isEqualTo: (userGlobal?.uid)!).whereField("hasDelivered", isEqualTo: false)
        dbRef.getDocuments { (snapshot, error) in
            print(snapshot?.count)
            if error == nil{
                guard let document = snapshot?.documents else {return}
                if document.isEmpty{
                    requestComplete(orderList)
                }else{
                    for items in document{
                        let docData = items.data()
                        print(docData)
                        let receipts = try! FirestoreDecoder().decode(Receipts.self, from: docData)
                        orderList.append(receipts)

                        
                    }
                    requestComplete(orderList)
                    
                }
            }
        
        }
    }
    
//    func realtimeListUpdate(requestComplete:@escaping(_ orderList:[Receipts])->()){
//                var orderList = [Receipts]()
//
//        let dbRef = db.collection("receipts").whereField("ownerId", isEqualTo: (userGlobal?.uid)!).whereField("hasDelivered", isEqualTo: false)
//        dbRef.addSnapshotListener { (snapshot, error) in
//             if error == nil{
//                           guard let document = snapshot?.documents else {return}
//                           if document.isEmpty{
//                               requestComplete(orderList)
//                           }else{
//                               for items in document{
//                                   let docData = items.data()
//                                   print(docData)
//                                   let receipts = try! FirestoreDecoder().decode(Receipts.self, from: docData)
//                                   orderList.append(receipts)
//
//
//                               }
//                               requestComplete(orderList)
//
//                           }
//                       }
//        }
//
//    }
    func realtimeListUpdate2(requestComplete:@escaping(_ orderList:[OrderDocument])->()){
        var orderList = [OrderDocument]()
        let todaysDate = Date()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: todaysDate)
        let dbRef = db.collection("orders").whereField("purchaserId", isEqualTo: (userGlobal?.uid)!).whereField("date", isGreaterThanOrEqualTo: startOfDay)
        dbRef.addSnapshotListener { (snapshot, error) in
            if error == nil{
                guard let document = snapshot else {return}
                document.documentChanges.forEach { (diff) in
                    if(diff.type == .added){
                        let order = try! FirestoreDecoder().decode(Order.self, from: diff.document.data())
                        let orderDoc = OrderDocument(documentId: diff.document.documentID, order: order)
                        orderList.append(orderDoc)
                    }
                    if(diff.type == .modified){
                        let neworder = try! FirestoreDecoder().decode(Order.self, from: diff.document.data())
                        if let modifiedOrderIndex = orderList.firstIndex(where: {$0.documentId == diff.document.documentID}){
                            orderList[modifiedOrderIndex].order = neworder
                        }
                        
                    }
                    
                    requestComplete(orderList)
                }
//                if document.isEmpty{
//                    requestComplete(orderList)
//                }else{
//                    for items in document{
//                        let docData = items.data()
//                        print(docData)
//                        let receipts = try! FirestoreDecoder().decode(Receipts.self, from: docData)
//                        orderList.append(receipts)
//                        
//                        
//                    }
//                    requestComplete(orderList)
//                    
//                }
            }
        }
        
    }
    func confirmOrder(order:OrderDocument,requestComplete:@escaping(_ status:Bool)->()){
        db.collection("orders").document(order.documentId!).updateData(["isConfirmed":true]) { (error) in
            if error == nil{
                requestComplete(true)
            }
        }
    }
    
    func rejectOrder(order:OrderDocument,requestComplete:@escaping(_ status:Bool)->()){
        db.collection("orders").document(order.documentId!).delete { (error) in
            if error == nil{
                requestComplete(true)
            }
        }
    }
}