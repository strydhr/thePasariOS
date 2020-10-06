//
//  updateAddressPopup.swift
//  ThePasar
//
//  Created by Satyia Anand on 29/09/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit
import GooglePlaces
import Firebase
import FirebaseAuth
import SVProgressHUD

protocol doneUpdateProfileDelegate {
    func updatedProfile(user:User)
}

class updateAddressPopup: UIViewController {
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var unitNumberTF: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    
    var delegate:doneUpdateProfileDelegate?
    
    var address:String?
    var unitNo:String?
    var latitude:Double?
    var longitude:Double?
    var geoHash:String?
    var addressResult = [String]()
    var gmsFetcher: GMSAutocompleteFetcher!
    var resultAC = [GMSAutocompletePrediction]()
    
    let placeClient = GMSPlacesClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        background.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bgtapped)))
        addressTF.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addAddress)))
        
    }

    @objc func bgtapped(){
        dismiss(animated: true, completion: nil)
    }
    @objc func addAddress(){
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        let fields:GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) | UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.coordinate.rawValue) | GMSPlaceField.addressComponents.rawValue | GMSPlaceField.formattedAddress.rawValue)!
        autocompleteController.placeFields = fields

        let filter = GMSAutocompleteFilter()
        filter.country = "MY"
        filter.type = .address
        autocompleteController.autocompleteFilter = filter

        present(autocompleteController, animated: true, completion: nil)
        
    }


    @IBAction func confirmBtnPressed(_ sender: UIButton) {
        errorHandler(address: address!, unitNumber: unitNumberTF.text!)
    }
    
}

extension updateAddressPopup{
    func errorHandler(address:String,unitNumber:String){
        if address.isEmpty{
            
        }else{
            if unitNumber.isEmpty{
                unitNo = ""
            }else{
                unitNo = unitNumber
            }
            SVProgressHUD.show()
            AuthServices.instance.updateUserInfo(newAddress: address, newUnitNumber: unitNo!, lat: self.latitude!, lng: self.longitude!, geohash: self.geoHash!) { (isSuccess) in
                if isSuccess{
                    SVProgressHUD.dismiss()
                    userGlobal?.address = address
                    userGlobal?.unitNumber = self.unitNo!
                    self.delegate?.updatedProfile(user: userGlobal!)
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
        }
    }
}

extension updateAddressPopup:GMSAutocompleteViewControllerDelegate{
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        addressTF.text = place.name
        address = place.formattedAddress
        latitude = place.coordinate.latitude
        longitude = place.coordinate.longitude
        geoHash = place.coordinate.geohash(length: 10)
        dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error.localizedDescription)
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }

}

//extension updateAddressPopup:UISearchBarDelegate,GMSAutocompleteFetcherDelegate{
//    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
//        for prediction in predictions{
//            self.addressResult.append(prediction.attributedFullText.string)
//            self.resultAC.append(prediction)
//            resultTable.reloadData()
//
//        }
//    }
//
//    func didFailAutocompleteWithError(_ error: Error) {
//        print(error)
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText.count > 3{
//            self.addressResult.removeAll()
//            self.resultAC.removeAll()
//            gmsFetcher.sourceTextHasChanged(searchText)
//        }
//    }
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        searchView.isHidden = true
//    }
//
//
//}
