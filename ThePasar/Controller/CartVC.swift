//
//  CartVC.swift
//  ThePasar
//
//  Created by Satyia Anand on 04/08/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit
import CodableFirebase
import FirebaseFirestore
import Firebase
import GoogleMobileAds
import CoreLocation

class CartVC: UIViewController {
    @IBOutlet weak var cartTable: UITableView!
    @IBOutlet weak var confrimBtn: UIButton!
    
    var interstitial:GADInterstitial!
    var adId = "ca-app-pub-1330351136644118~5969026295"
    
    var store:Store?
    var cartList = [itemPurchasing]()
    var hasDeliveryTime = false
    var deliveryTime:Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interstitial = GADInterstitial(adUnitID: adId)
        let request = GADRequest()
        interstitial.load(request)
//        confrimBtn.isHidden = true
        
        cartTable.register(UINib(nibName: "cartCell", bundle: nil), forCellReuseIdentifier: "cartCell")
        cartTable.delegate = self
        cartTable.dataSource = self
        cartTable.reloadData()
    }
    

    
    @IBAction func confirmBtnPressed(_ sender: UIButton) {
        let stockItems = cartList.filter({$0.hasDeliveryTime == false})
        let readyItems = cartList.filter({$0.hasDeliveryTime == true})
        var stockSuccess = false
        var readySuccess = false
        
        
        if stockItems.count > 0{
            let deliveryTimeStamp = Timestamp.init(date: deliveryTime!)
            var address = ""
            if userGlobal?.unitNumber != ""{
                address = userGlobal!.unitNumber + ", " + userGlobal!.address
            }else{
                address = userGlobal!.address
            }

            let order = Order(items: stockItems, date: Timestamp(), hasDeliveryTime: false, deliveryTime: deliveryTimeStamp, purchaserId: userGlobal!.uid, purchaserName: userGlobal!.name, purchaserAddress: address,lat: userGlobal!.l[0], lng: userGlobal!.l[1], purchaserPhone: userGlobal!.phone, purchaserDeviceToken: (store?.deviceToken)!, storeId: store!.uid, storeName: store!.name, ownerId: store!.ownerId, hasDelivered: false,confirmationStatus: 1,comment: "")
           stockSuccess = PurchaseServices.instance.confirmPurchase(receipt: order)

//            PurchaseServices.instance.confirmPurchase(receipt: order) { (isSuccess) in
//                if isSuccess{
//                    stockSuccess = true
//                    //                    self.navigationController?.popToRootViewController(animated: true)
//                }
//            }
        }
//
        if readyItems.count > 0{
            let deliveryTimeStamp = Timestamp.init(date: deliveryTime!)
            var address = ""
            if userGlobal?.unitNumber != ""{
                address = userGlobal!.unitNumber + ", " + userGlobal!.address
            }else{
                address = userGlobal!.address
            }

            let order = Order(items: readyItems, date: Timestamp(), hasDeliveryTime: true, deliveryTime: deliveryTimeStamp, purchaserId: userGlobal!.uid, purchaserName: userGlobal!.name, purchaserAddress: address,lat: userGlobal!.l[0], lng: userGlobal!.l[1], purchaserPhone: userGlobal!.phone, purchaserDeviceToken: (store?.deviceToken)!, storeId: store!.uid, storeName: store!.name, ownerId: store!.ownerId, hasDelivered: false,confirmationStatus: 1,comment: "")

            readySuccess = PurchaseServices.instance.confirmPurchase(receipt: order)
//            PurchaseServices.instance.confirmPurchase(receipt: order) { (isSuccess) in
//                if isSuccess{
//                    readySuccess = true
//                    //                    self.navigationController?.popToRootViewController(animated: true)
//                }
//            }
        }

        if readySuccess == true || stockSuccess == true{
            if self.interstitial.isReady{
                let coor1 = CLLocation(latitude: (store?.l[0])!, longitude: (store?.l[1])!)
                let coor2 = CLLocation(latitude: userGlobal!.l[0], longitude: userGlobal!.l[1])
                let dist = String(format: "%0.2f", coor1.distance(from: coor2)/1000)
                NotificationServices.instance.sendNotification(deviceToken: (store?.deviceToken)!, title: "New Order", body: "from \((dist)) Km away")
//                self.confrimBtn.isHidden = false
                self.interstitial.present(fromRootViewController: self)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }else{
                print("No Ads")
            }
            
        }
        
        
    }

}

extension CartVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell")as? cartCell else {return UITableViewCell()}
        let item = cartList[indexPath.row]
        cell.itemName.text = item.productName
        cell.itemCount.text = String(item.itemCount)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }
    
    
}
