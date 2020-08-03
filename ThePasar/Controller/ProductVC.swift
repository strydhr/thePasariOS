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
    
    var viewStore:Store?
    var productList = [ProductDocument]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productTable.register(UINib(nibName: "productCell", bundle: nil), forCellReuseIdentifier: "productCell")
        productTable.delegate = self
        productTable.dataSource = self
        
        loadDatas()
        
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
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = productList[indexPath.row].product
        tableView.deselectRow(at: indexPath, animated: true)
        let addToOrder = addToOderPopup()
        addToOrder.selectedProduct = product
        addToOrder.modalPresentationStyle = .fullScreen
        present(addToOrder, animated: true, completion: nil)
    }
    
    
}
extension ProductVC{
    func loadDatas(){
        StoreServices.instance.listMyStoreProducts(store: viewStore!) { (productlist) in
            self.productList = productlist
            self.productTable.reloadData()
        }
    }
}
