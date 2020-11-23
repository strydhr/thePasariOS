//
//  HistoryVC.swift
//  ThePasar
//
//  Created by Satyia Anand on 08/10/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit

class HistoryVC: UIViewController {
    // First Timers
    @IBOutlet weak var mainHintContainer: UIView!
    @IBOutlet weak var hintBlinky: UIImageView!
    @IBOutlet weak var firstHint: UIView!
    
    let defaults = UserDefaults.standard
    //
    
    @IBOutlet weak var historyTable: UITableView!
    
    var historyList = [ReceiptDocument]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDatas()
        historyTable.delegate = self
        historyTable.dataSource = self
        historyTable.register(UINib(nibName: "receiptHeader", bundle: nil), forCellReuseIdentifier: "receiptHeader")
        
        mainHintContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nextHint)))
        
    }
    
    
    @objc func nextHint(){

            firstHint.isHidden = true
            mainHintContainer.isHidden = true

            defaults.set(true, forKey: "historyHintDone")
            

    }

}

extension HistoryVC{
    func loadDatas(){
        PurchaseServices.instance.listPastPurchases { (historylist) in
            self.historyList = historylist.sorted(by: {$0.receipt!.deliveryTime.dateValue().compare($1.receipt!.deliveryTime.dateValue()) == .orderedDescending})
            self.historyTable.reloadData()
            let isFirstTime = UserDefaults.exist(key: "historyHintDone")
            print(isFirstTime)
            if isFirstTime == false{
                if self.historyList.count > 0 {
                    self.firstTimeHelper()
                }
                
            }
        }
    }
    func firstTimeHelper(){
        mainHintContainer.isHidden = false
        firstHint.isHidden = false
        
        self.hintBlinky.alpha = 0
        UIView.animate(withDuration: 1, delay: 0.0, options: [.curveLinear, .repeat, .autoreverse]) {
            self.hintBlinky.alpha = 1
        } completion: { (success) in
            
        }

    }
}
extension HistoryVC:UITableViewDelegate,UITableViewDataSource{
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return historyList.count
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyList.count
    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "receiptHeader")as? receiptHeader else {return UITableViewCell()}
//        let header = historyList[section]
//        cell.deliveryAddress.text = header.receipt?.purchaserAddress
////        cell.delegate = self
//        cell.item = header
//        var totalItems = 0
//        for item in header.receipt!.items{
//            totalItems += item.itemCount
//        }
//
//        cell.orderCount.text = String(totalItems)
//        if header.receipt!.hasDeliveryTime{
//            cell.deliveryTime.text = getTimeLabel(dates: header.receipt!.deliveryTime.dateValue())
//        }else{
//            cell.deliveryTime.text = getDateLabel(dates: header.receipt!.deliveryTime.dateValue())
//        }
//
//
//        return cell
//    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 115
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "receiptHeader")as? receiptHeader else {return UITableViewCell()}
        let header = historyList[indexPath.row]
        cell.deliveryAddress.text = header.receipt?.purchaserAddress
//        cell.delegate = self
        cell.item = header
        var totalItems = 0
        for item in header.receipt!.items{
            totalItems += item.itemCount
        }
        
        cell.orderCount.text = String(totalItems)
        if header.receipt!.hasDeliveryTime{
            cell.deliveryTime.text = getDateLabel(dates: header.receipt!.deliveryTime.dateValue())
        }else{
            cell.deliveryTime.text = getDateLabel(dates: header.receipt!.deliveryTime.dateValue())
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let selectedReceipt = historyList[indexPath.row]
//        let complaintPopup = lodgeComplaintPopup()
//        complaintPopup.receipt = selectedReceipt
//        complaintPopup.delegate = self
//        complaintPopup.modalPresentationStyle = .custom
//        present(complaintPopup, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let complaint = complaintAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [complaint])
    }
    
    func complaintAction(at indexPath:IndexPath) -> UIContextualAction {
        let done = UIContextualAction(style: .normal, title: "Lodge") { (action, view, completion) in
            let selectedReceipt = self.historyList[indexPath.row]
            let complaintPopup = lodgeComplaintPopup()
            complaintPopup.receipt = selectedReceipt
            complaintPopup.delegate = self
            complaintPopup.modalPresentationStyle = .custom
            self.present(complaintPopup, animated: true, completion: nil)

            
        }
        done.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        
        return done
    }
}

extension HistoryVC:sendComplaintNotificationDelegate{
    func showComplaintComfirmation(status: Bool) {
        if status{
            print("Sent")
            DispatchQueue.main.async {
                let appliedDoneAlert = UIAlertController(title: "You have lodge a complaint", message: "The restaurant owner will be notified", preferredStyle: .alert)
                self.present(appliedDoneAlert, animated: true, completion: nil)
                let timer = DispatchTime.now() + 3.5
                DispatchQueue.main.asyncAfter(deadline: timer, execute: {
                    appliedDoneAlert.dismiss(animated: true, completion: nil)

                })
            }
            
            
        }
    }
    
    
}
