//
//  MainTabVC.swift
//  ThePasar
//
//  Created by Satyia Anand on 24/07/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import MapKit

class MainTabVC: UIViewController {
    // First Timers
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var firstBlinking: UIImageView!
    @IBOutlet weak var firstHint: UIView!
    
    @IBOutlet weak var secondHint: UIView!
    @IBOutlet weak var secondBlinking: UIImageView!
    
    var page = 1
    let defaults = UserDefaults.standard
    //
    
    @IBOutlet weak var storeTable: UITableView!
    
    
    var settings = UIBarButtonItem()
    
    //GPS Autorization
    let CLLManager = CLLocationManager()
    let cLLocationAuthStatus = CLLocationManager.authorizationStatus()
    var currentGeopoint:GeoPoint?
    
    var storeList = [StoreDocument]()
    var selectedStore:Store?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
//        gpsAuthorization()
        
        mainContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nextHint)))
        
        settings = UIBarButtonItem(image: UIImage(named: "setting"), style: .done, target: self, action: #selector(radiusSetting))
        navigationItem.rightBarButtonItems = [settings]
        
        storeTable.register(UINib(nibName: "storeCell", bundle: nil), forCellReuseIdentifier: "storeCell")
        storeTable.delegate = self
        storeTable.dataSource = self
        
        getStoreWithinLocation(radius: 2)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let isFirstTime = UserDefaults.exist(key: "mainTabHintDone")
        print(isFirstTime)
        if isFirstTime == false{
            firstTimeHelper()
        }else{
            let hintEnable = self.defaults.bool(forKey: "mainTabHintDone")
            if hintEnable == false{
                    self.firstTimeHelper()

            }
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewProductSegue"{
            let destination = segue.destination as! ProductVC
            destination.viewStore = selectedStore
        }
    }
    
    @objc func radiusSetting(){
       let settings = radiusSettingPopup()
        settings.delegate = self
        present(settings, animated: true, completion: nil)
    }
    
    @objc func nextHint(){
        if page == 1{
            firstHint.isHidden = true
            secondHint.isHidden = false
            page = 2
        }else if page == 2{
            secondHint.isHidden = true
            mainContainer.isHidden = true
            defaults.set(true, forKey: "mainTabHintDone")
            
        }
    }

}

extension MainTabVC{
//    func gpsAuthorization(){
//        CLLManager.delegate = self
//        CLLManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
//        CLLManager.requestWhenInUseAuthorization()
//        CLLManager.startUpdatingLocation()
//    }
    
    func getStoreWithinLocation(radius:Double){
        let currentLocation = CLLocation(latitude: (userGlobal?.l[0])!, longitude: (userGlobal?.l[1])!)
        currentGeopoint = GeoPoint.geopointWithLocation(location: currentLocation)
        StoreServices.instance.geoSearchStore(currentLocation: self.currentGeopoint!, radiusSetting: radius) { (storelist) in
            self.storeList = storelist
            self.storeList.sort(by: {!($0.store?.isClosed)! && (($1.store?.isClosed) != nil)})
            self.storeTable.reloadData()
        }
    }
    
    func firstTimeHelper(){
        mainContainer.isHidden = false
        firstHint.isHidden = false
        secondHint.isHidden = true
        page = 1
        
        self.secondBlinking.alpha = 0
        self.firstBlinking.alpha = 0
        UIView.animate(withDuration: 1, delay: 0.0, options: [.curveLinear, .repeat, .autoreverse]) {
            self.firstBlinking.alpha = 1
            self.secondBlinking.alpha = 1
        } completion: { (success) in
            
        }

    }
    
    
}

//extension MainTabVC: CLLocationManagerDelegate{
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first{
//            print("updating...")
//            CLLManager.stopUpdatingLocation()
//        }
//
//
//
//    }
//}

extension MainTabVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "storeCell")as? storeCell else {return UITableViewCell()}
        let store = storeList[indexPath.row].store
        cell.storeImage.cacheImage(imageUrl: store!.profileImage)
        cell.storeLabel.text = store?.name
        cell.storeType.text = store?.type
        
        cell.storeAddress.numberOfLines = 0
        cell.storeAddress.text = store?.location
        
        if store?.isClosed == true{
            cell.statusContainer.isHidden = false
            cell.statusLabel.isHidden  = false
        }else{
            cell.statusContainer.isHidden = true
            cell.statusLabel.isHidden  = true
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let store = storeList[indexPath.row].store
        selectedStore = store
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "viewProductSegue", sender: self)
    }
    
    
}
extension MainTabVC:updatedRadiusDelegate{
    func updatedRadius(radius: Double) {
        getStoreWithinLocation(radius: radius)
    }
    
    
}
