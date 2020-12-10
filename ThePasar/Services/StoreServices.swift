//
//  StoreServices.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 28/07/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CodableFirebase
import GeoFire
import Geofirestore

class StoreServices {
    static let instance = StoreServices()
    
    func addStore(
        store:Store,requestComplete:@escaping(_ status:Bool)->()){
        let docData = try! FirestoreEncoder().encode(store)
        
        db.collection("store").document(store.uid).setData(docData) { (error) in
            if error == nil{
                requestComplete(true)
            }
        }
    }
    
    func addItem(item:Product,requestComplete:@escaping(_ status:Bool)->()){
        let docData = try! FirestoreEncoder().encode(item)
        
        db.collection("product").document(item.uid).setData( docData){ (error) in
            if error == nil{
                requestComplete(true)
            }
        }
    }
    
    func listMyStore(requestComplete:@escaping(_ storeList:[StoreDocument])->()){
        var storeList = [StoreDocument]()
        
        let dbRef = db.collection("store").whereField("ownerId", isEqualTo: (userGlobal?.uid)!)
        dbRef.getDocuments { (snapshot, error) in
            if error == nil{
                guard let document = snapshot?.documents else {return}
                if document.isEmpty{
                    requestComplete(storeList)
                }else{
                    for items in document{
                        let docData = items.data()
                        let store = try! FirestoreDecoder().decode(Store.self, from: docData)
                        let storeDoc = StoreDocument(documentId: items.documentID, store: store)
                        storeList.append(storeDoc)

                        
                    }
                    requestComplete(storeList)
                    
                }
            }
        
        }
    }
    
    func listMyStoreProducts(store:Store,requestComplete:@escaping(_ productList:[ProductDocument])->()){
        var productList = [ProductDocument]()
        
        let dbRef = db.collection("product").whereField("sid", isEqualTo: store.uid).whereField("isDisabled", isEqualTo: false)
        dbRef.getDocuments { (snapshot, error) in
            if error == nil{
                guard let document = snapshot?.documents else {return}
                if document.isEmpty{
                    requestComplete(productList)
                }else{
                    for items in document{
                        let docData = items.data()
                        let product = try! FirestoreDecoder().decode(Product.self, from: docData)
                        let productDoc = ProductDocument(documentId: items.documentID, product: product)
                        productList.append(productDoc)

                        
                    }
                    requestComplete(productList)
                    
                }
            }
        
        }
    }
    
    func geoSearchStore(currentLocation:GeoPoint,radiusSetting:Double,requestComplete: @escaping(_ restaurantList: [StoreDocument])->()){
        var storeList = [StoreDocument]()
        
        let dbRef = db.collection("store")
        let geoSearch = GeoFirestore(collectionRef: dbRef)
        
        let query:GFSQuery = geoSearch.query(withCenter: currentLocation, radius: radiusSetting)
        _ = query.observe(.documentEntered, with: { (docId, location) in
            let doc = docId
            dbRef.document(doc!).getDocument(completion: { (snapshot, error) in
                guard let snapShot = snapshot?.data() else {return}
                let store = try! FirestoreDecoder().decode(Store.self, from: snapShot )
                let storeDoc = StoreDocument(documentId: doc, store: store)
                storeList.append(storeDoc)
                
                requestComplete(storeList)
            })
            
        })
    }
    
    func listPreRegProducts(requestComplete:@escaping(_ productList:[ProductDocument])->()){
        var productList = [ProductDocument]()
        
        let dbRef = db.collection("product").whereField("availability", isEqualTo: true)
        dbRef.getDocuments { (snapshot, error) in
            if error == nil{
                guard let document = snapshot?.documents else {return}
                if document.isEmpty{
                    requestComplete(productList)
                }else{
                    for items in document{
                        let docData = items.data()
                        let product = try! FirestoreDecoder().decode(Product.self, from: docData)
                        let productDoc = ProductDocument(documentId: items.documentID, product: product)
                        productList.append(productDoc)

                        
                    }
                    requestComplete(productList)
                    
                }
            }
        
        }
    }
    
}
