//
//  Product.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 28/07/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit
import CodableFirebase
import Firebase

class Product: Codable {
    var uid:String
    var name: String
    var type:String
    var details:String
    var sid: String
    var count: Int
    var price: Double
    var availability:Bool
    var profileImage:String
    var hasCounter:Bool
    var colorClass:Int
    
    init(uid:String,name:String,type:String,details:String,sid:String,count:Int,price:Double,availability:Bool,profileImage:String,hasCounter:Bool,colorClass:Int) {
        self.uid = uid
        self.name = name
        self.type = type
        self.details = details
        self.sid = sid
        self.count = count
        self.price = price
        self.availability = availability
        self.profileImage = profileImage
        self.hasCounter = hasCounter
        self.colorClass = colorClass
    }
}

struct ProductDocument{
    var documentId:String?
    var product: Product?
}

class itemPurchasing: Codable{
    var productId:String
    var productName:String
    var productPrice:Double
    var itemCount:Int
    var hasDeliveryTime:Bool
    var deliveryTime:Timestamp
    var colorClass:Int
    
    init(productId:String,productName:String,productPrice:Double,itemCount:Int,hasDeliveryTime:Bool,deliveryTime:Timestamp,colorClass:Int) {
        self.productId = productId
        self.productName = productName
        self.productPrice = productPrice
        self.itemCount = itemCount
        self.hasDeliveryTime = hasDeliveryTime
        self.deliveryTime = deliveryTime
        self.colorClass = colorClass
    }
}
class Order: Codable{
    var items:[itemPurchasing]
    var date: Timestamp
    var hasDeliveryTime:Bool
    var deliveryTime:Timestamp
    var purchaserId:String
    var purchaserName:String
    var purchaserAddress:String
    var storeId:String
    var storeName:String
    var ownerId:String
    var hasDelivered:Bool
    var confirmationStatus:Int
    var comment:String
    
    init(items:[itemPurchasing],date:Timestamp,hasDeliveryTime:Bool,deliveryTime:Timestamp,purchaserId:String,purchaserName:String,purchaserAddress:String,storeId:String,storeName:String,ownerId:String,hasDelivered:Bool,confirmationStatus:Int,comment:String) {
        self.items = items
        self.date = date
        self.hasDeliveryTime = hasDeliveryTime
        self.deliveryTime = deliveryTime
        self.purchaserId = purchaserId
        self.purchaserName = purchaserName
        self.purchaserAddress = purchaserAddress
        self.storeId = storeId
        self.storeName = storeName
        self.ownerId = ownerId
        self.hasDelivered = hasDelivered
        self.confirmationStatus = confirmationStatus //0:rejected 1: unconfirmed 2: confirm
        self.comment = comment
    }
}

struct OrderDocument {
    var documentId:String?
    var order:Order?
}


class Receipts: Codable{
    var items:[itemPurchasing]
    var date: Timestamp
    var hasDeliveryTime:Bool
    var deliveryTime:Timestamp
    var purchaserId:String
    var purchaserName:String
    var purchaserAddress:String
    var storeId:String
    var storeName:String
    var ownerId:String
    var hasDelivered:Bool
    
    init(items:[itemPurchasing],date:Timestamp,hasDeliveryTime:Bool,deliveryTime:Timestamp,purchaserId:String,purchaserName:String,purchaserAddress:String,storeId:String,storeName:String,ownerId:String,hasDelivered:Bool) {
        self.items = items
        self.date = date
        self.hasDeliveryTime = hasDeliveryTime
        self.deliveryTime = deliveryTime
        self.purchaserId = purchaserId
        self.purchaserName = purchaserName
        self.purchaserAddress = purchaserAddress
        self.storeId = storeId
        self.storeName = storeName
        self.ownerId = ownerId
        self.hasDelivered = hasDelivered
    }
}
