//
//  ProductVC.swift
//  ThePasar
//
//  Created by Satyia Anand on 30/07/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit

class ProductVC: UIViewController {
    @IBOutlet weak var productTable: UITableView!
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var btnHeightConstraint: NSLayoutConstraint!
    
    var viewStore:Store?
    var productList = [ProductDocument]()
    
    var cartItems = [itemPurchasing]()
    var theresDeliveryTime = false
    var deliveryTime:Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productTable.register(UINib(nibName: "productCell", bundle: nil), forCellReuseIdentifier: "productCell")
        productTable.delegate = self
        productTable.dataSource = self
        
        loadDatas()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cartSegue"{
            let destination = segue.destination as! CartVC
            destination.cartList = cartItems
            destination.store = viewStore
            destination.hasDeliveryTime = theresDeliveryTime
            destination.deliveryTime = deliveryTime
        }
    }
    
    @IBAction func proceedBtnPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "cartSegue", sender: self)
    }
    

}
extension ProductVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 91
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "productCell")as? productCell else {return UITableViewCell()}
        let product = productList[indexPath.row].product
        cell.productImage.cacheImage(imageUrl: product!.profileImage)
        cell.productName.text = product?.name
        cell.productPrice.text = "RM" + String(format: "%.2f", product!.price)
        cell.productDetails.text = product?.details
        if product?.count == 0 && product?.type != "Pastry"{
            cell.outOfStockView.isHidden = false
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = productList[indexPath.row].product
        tableView.deselectRow(at: indexPath, animated: true)
        let addToOrder = addToOderPopup()
        addToOrder.selectedProduct = product
        addToOrder.items = cartItems
        addToOrder.delegate = self
        addToOrder.hasDeliveryTime = theresDeliveryTime
        addToOrder.deliveryTime = deliveryTime
        addToOrder.modalPresentationStyle = .fullScreen
        present(addToOrder, animated: true, completion: nil)
        
        let hasDeliveryTime = cartItems.filter({$0.hasDeliveryTime == true}).first
        if hasDeliveryTime != nil{
            
        }
    }
    
}
extension ProductVC{
    func loadDatas(){
        StoreServices.instance.listMyStoreProducts(store: viewStore!) { (productlist) in
            self.productList = productlist
            self.productTable.reloadData()
        }
    }
    
    func initlayout(){
        if cartItems.count == 0{
            btnHeightConstraint.constant = 0
        }
    }
    
    func enableProceedBtn(){
        if productList.count > 0{
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
                self.btnHeightConstraint.constant = 40
            } completion: { (isSuccess) in
                self.proceedBtn.isHidden = false
            }

        }
    }
}

extension ProductVC:updateCartDelegate{
    func updatedCart(items: [itemPurchasing], hasDelivery: Bool, sendBy: Date?) {
        cartItems = items
//        if hasDelivery{
            theresDeliveryTime = hasDelivery
            deliveryTime = sendBy
            
//        }
       enableProceedBtn()
    }
    
    
}
