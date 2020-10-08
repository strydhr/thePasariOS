//
//  OrdersVC.swift
//  ThePasar
//
//  Created by Satyia Anand on 18/08/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit
import Firebase

class OrdersVC: UIViewController {
    var listener: ListenerRegistration?
    var listener2: ListenerRegistration?
    
    @IBOutlet weak var orderTable: UITableView!
    
    var ordersList = [OrderDocument]()
    var receiptList = [ReceiptDocument]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        loadDatas()
        orderTable.delegate = self
        orderTable.dataSource = self
        orderTable.separatorStyle = .none
        orderTable.register(UINib(nibName: "orderHeader", bundle: nil), forCellReuseIdentifier: "orderHeader")
        

    }
    

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        listener!.remove()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDatas()
    }


}
extension OrdersVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "orderHeader")as? orderHeader else {return UITableViewCell()}
        let order = ordersList[indexPath.row].order
        //
        let orderDoc = ordersList[indexPath.row]
        //
        cell.deliveryAddress.text = order?.storeName
        var totalItems = 0
        let items = order?.items
        for item in items!{
            totalItems += item.itemCount
        }
        if order?.confirmationStatus == 1{
            cell.confirmBtn.isHidden = true
        }else{
            cell.confirmBtn.isHidden = false
            if order?.confirmationStatus == 0{
                cell.confirmBtn.titleLabel?.text = "Rejected"
                cell.statusIcon.isHidden = false
                cell.statusIcon.image = UIImage(named: "rejected")
            }else{
                
                //
                if let sentItem = receiptList.firstIndex(where: {$0.receipt?.orderId == orderDoc.documentId}){
                    cell.confirmBtn.setTitle("Delivered", for: .normal)
                    
                }else{
                    
                    cell.confirmBtn.setTitle("Confirmed", for: .normal)
                    cell.confirmBtn.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                    cell.statusIcon.isHidden = false
                    cell.statusIcon.image = UIImage(named: "delivery")
                }
                //
            }
        }
        
        cell.orderCount.text = String(totalItems)
        cell.deliveryTime.text = getTimeLabel(dates: (order?.deliveryTime.dateValue())!)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOrder = ordersList[indexPath.row]
        if selectedOrder.order?.confirmationStatus == 0{
            let rejectedPopup = rejectedCommentPopup()
            rejectedPopup.order = selectedOrder.order
            rejectedPopup.modalPresentationStyle = .overCurrentContext
            present(rejectedPopup, animated: true, completion: nil)
        }
    }
    
}

extension OrdersVC{
    func loadDatas(){
        
        self.listener = OrderServices.instance.realtimeListUpdate2(requestComplete: { (orderlist) in
            self.ordersList = orderlist
            self.orderTable.reloadData()
        })
        
        self.listener2 = OrderServices.instance.realtimeDeliveryUpdate(requestComplete: { (receiptlist) in
            print("updated...")
            print(receiptlist.count)
            self.receiptList = receiptlist
            self.orderTable.reloadData()
        })
    }
}


