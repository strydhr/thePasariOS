//
//  ViewProductsVC.swift
//  ThePasar
//
//  Created by Satyia Anand on 01/12/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

class ViewProductsVC: UIViewController {
    @IBOutlet weak var banner: GADBannerView!
    @IBOutlet weak var productTable: UITableView!
    
    var adId = "ca-app-pub-1330351136644118/2121027039"
//    var adId = "ca-app-pub-3940256099942544/2934735716"
    
    var productList = [ProductDocument]()
    
    //GPS Autorization
//    let CLLManager = CLLocationManager()
//    let cLLocationAuthStatus = CLLocationManager.authorizationStatus()
//    var currentGeopoint:GeoPoint?
//    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productTable.register(UINib(nibName: "productCell", bundle: nil), forCellReuseIdentifier: "productCell")
        productTable.delegate = self
        productTable.dataSource = self
        
//        gpsAuthorization()
        
        loadDatas()
        banner.adUnitID = adId
        banner.rootViewController = self
        banner.load(GADRequest())
        
    }
    @objc func backgroundTapped(){
        self.dismiss(animated: true, completion: nil)
    }

    

}
extension ViewProductsVC: UITableViewDelegate, UITableViewDataSource{
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
        cell.productDetails.text = product?.type
        if product?.count == 0 && product?.type != "Pastry"{
            cell.outOfStockView.isHidden = false
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = productList[indexPath.row].product
        tableView.deselectRow(at: indexPath, animated: true)
        let registerPopuP = UIAlertController(title: "Looking to choose a product?", message: "You need to register to enable to proceed further", preferredStyle: .alert)
        registerPopuP.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (buttonTapped) in

            try! Auth.auth().signOut()
            UserDefaults.standard.set(true, forKey: "seenWalkthrough")
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
//            self.present(controllerToBePresented!, animated: true, completion: nil)
//            UserDefaults.standard.set(true, forKey: "seenWalkthrough")
//            self.dismiss(animated: true, completion: nil)
            
        }))
        registerPopuP.addAction(UIAlertAction(title: "No", style: .default, handler: { (buttonTapped) in
            registerPopuP.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.backgroundTapped)))
            
            
        }))
        present(registerPopuP, animated: true, completion:  {
            
            registerPopuP.view.superview?.isUserInteractionEnabled = true
            registerPopuP.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.backgroundTapped)))
        })

        
    }
    
}
extension ViewProductsVC:CLLocationManagerDelegate{
//    func gpsAuthorization(){
//        CLLManager.delegate = self
//        CLLManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
//        CLLManager.requestWhenInUseAuthorization()
//
//        CLLManager.startUpdatingLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first{
//            print("updating...")
//            count += 1
//            if count == 1{
//                let currentLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//                currentGeopoint = GeoPoint.geopointWithLocation(location: currentLocation)
//                CLLManager.stopUpdatingLocation()
//            }
//
//            print(location.coordinate.latitude)
//        }
//
//
//
//    }
    
    func loadDatas(){
        
//        Auth.auth().signIn(withEmail: "anonymous@anonymous.com", password: "pohyee") { (res, err) in
            StoreServices.instance.listPreRegProducts() { (productlist) in
                self.productList = productlist
                self.productTable.reloadData()
//            }
        }
        
    }
    
    
}


