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

class CartVC: UIViewController {
    @IBOutlet weak var cartTable: UITableView!
    @IBOutlet weak var confrimBtn: UIButton!
    
    var store:Store?
    var cartList = [itemPurchasing]()
    var hasDeliveryTime = false
    var deliveryTime:Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(cartList.count)
        
        cartTable.register(UINib(nibName: "cartCell", bundle: nil), forCellReuseIdentifier: "cartCell")
        cartTable.delegate = self
        cartTable.dataSource = self
        cartTable.reloadData()
    }
    
    @IBAction func confirmBtnPressed(_ sender: UIButton) {
//        let receipt = Receipts(items: cartList, date: Timestamp(), purchaserId: userGlobal!.uid, purchaserName: userGlobal!.name, purchaserAddress: userGlobal!.address, storeId: store!.uid, storeName: store!.name, ownerId: store!.ownerId)
        let deliveryTimeStamp = Timestamp.init(date: deliveryTime!)
        
        let receipt = Receipts(items: cartList, date: Timestamp(), hasDeliveryTime: hasDeliveryTime, deliveryTime: deliveryTimeStamp, purchaserId: userGlobal!.uid, purchaserName: userGlobal!.name, purchaserAddress: userGlobal!.address, storeId: store!.uid, storeName: store!.name, ownerId: store!.ownerId, hasDelivered: false)
        
        PurchaseServices.instance.confirmPurchase(receipt: receipt) { (isSuccess) in
            if isSuccess{
                self.navigationController?.popToRootViewController(animated: true)
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