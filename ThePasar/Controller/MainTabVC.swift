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
        gpsAuthorization()
        
        settings = UIBarButtonItem(image: UIImage(named: "setting"), style: .done, target: self, action: #selector(radiusSetting))
        navigationItem.rightBarButtonItems = [settings]
        
        storeTable.register(UINib(nibName: "storeCell", bundle: nil), forCellReuseIdentifier: "storeCell")
        storeTable.delegate = self
        storeTable.dataSource = self
        
        getStoreWithinLocation(radius: 2)
        
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

}

extension MainTabVC{
    func gpsAuthorization(){
        CLLManager.delegate = self
        CLLManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        CLLManager.requestWhenInUseAuthorization()
        CLLManager.startUpdatingLocation()
    }
    
    func getStoreWithinLocation(radius:Double){
        let currentLocation = CLLocation(latitude: (userGlobal?.l[0])!, longitude: (userGlobal?.l[1])!)
        currentGeopoint = GeoPoint.geopointWithLocation(location: currentLocation)
        StoreServices.instance.geoSearchStore(currentLocation: self.currentGeopoint!, radiusSetting: radius) { (storelist) in
            self.storeList = storelist
            self.storeTable.reloadData()
        }
    }
}

extension MainTabVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            print("updating...")
            CLLManager.stopUpdatingLocation()
        }
        
        
        
    }
}

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
