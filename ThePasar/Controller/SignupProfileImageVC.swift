//
//  SignupProfileImageVC.swift
//  ThePasar
//
//  Created by Satyia Anand on 23/07/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit
import GooglePlaces
import Firebase
import FirebaseAuth
import SVProgressHUD

class SignupProfileImageVC: UIViewController {
    @IBOutlet weak var userFullnameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var resultTable: UITableView!
    @IBOutlet weak var proceedBtn: UIButton!
    
    var fullname:String?
    var address:String?
    var selectedImage: UIImage?
    var isProfilePicSet = false
    var addressResult = [String]()
    var gmsFetcher: GMSAutocompleteFetcher!
    var resultAC = [GMSAutocompletePrediction]()
    
    let placeClient = GMSPlacesClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLayout()
        addressTF.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addAddress)))
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
        profileImage.isUserInteractionEnabled = true
    }
    
    @objc func addAddress(){
//        searchView.isHidden = false
//        searchbar.delegate = self
//        resultTable.delegate = self
//        resultTable.dataSource = self
//
//        let filter = GMSAutocompleteFilter()
//        filter.country = Locale.current.regionCode
//        gmsFetcher = GMSAutocompleteFetcher()
//        gmsFetcher.autocompleteFilter = filter
//        self.gmsFetcher.delegate = self
        
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
    @objc func  imageTapped(){
        let alert = UIAlertController(title: "Change Profile Image", message: "Please Select an Option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take A Photo", style: .default, handler: { (photoAlert) in
            let camera = UIImagePickerController()
            camera.sourceType = .camera
            camera.delegate = self
            camera.allowsEditing = true
            self.present(camera, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Choose From Library", style: .default, handler: { (libraryAlert) in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (libraryAlert) in
            print("Cancel")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func proceedBtnPressed(_ sender: UIButton) {
        errorHandler(address: address!)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SignupProfileImageVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        
        if let editedImage = info[.editedImage]{
            selectedImage = (editedImage as! UIImage)
        }else if let originalImage = info[.originalImage]{
            selectedImage = (originalImage as! UIImage)
        }
            self.profileImage.image = selectedImage
            isProfilePicSet = true
        
  

        dismiss(animated: true, completion: nil)
        
    }
    
    func uploadImages(image: UIImage,imageName: String,requestURL: @escaping(_ url:String)->()){
        let storage = Storage.storage()
        let storageRef = storage.reference().child("UsersFiles").child((Auth.auth().currentUser?.uid)!)
        
        if let uploaddata = image.jpegData(compressionQuality: 0.6){
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            let uploadTask = storageRef.child(imageName).putData(uploaddata, metadata: metaData)
//            SVProgressHUD.show()
            _ = uploadTask.observe(.success) { (snapshot) in
                print(snapshot.status)
//                SVProgressHUD.dismiss()
                storageRef.child(imageName).downloadURL(completion: { (url, _) in
                    let urlString = url?.absoluteString
                    
                    requestURL(urlString!)
                    
                    
                })
                
                
                
            }
        }
    }
}

extension SignupProfileImageVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell") else {return UITableViewCell()}
                   let result = addressResult[indexPath.row]
                   cell.textLabel?.text = result
                   cell.textLabel?.numberOfLines = 0
                   return cell
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
    
    
}
extension SignupProfileImageVC:GMSAutocompleteViewControllerDelegate{
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        addressTF.text = place.name
        address = place.formattedAddress
        dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error.localizedDescription)
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }

    

}


extension SignupProfileImageVC:UISearchBarDelegate,GMSAutocompleteFetcherDelegate{
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        for prediction in predictions{
            self.addressResult.append(prediction.attributedFullText.string)
            self.resultAC.append(prediction)
            resultTable.reloadData()
            
        }
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        print(error)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 3{
            self.addressResult.removeAll()
            self.resultAC.removeAll()
            gmsFetcher.sourceTextHasChanged(searchText)
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchView.isHidden = true
    }
    
    
}

extension SignupProfileImageVC{
    func initLayout(){
        userFullnameLabel.text = "Hello \((fullname)!)"
        
        addressTF.layer.cornerRadius = 17
        addressTF.layer.masksToBounds = true
        addressTF.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        addressTF.layer.borderWidth = 3
        addressTF.attributedPlaceholder = NSAttributedString(string: "Mailing Address", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
    }

    func errorHandler(address:String){
        if address.isEmpty{
            
        }else{
            SVProgressHUD.show()
            uploadImages(image: profileImage.image!, imageName: "profile") { (url) in
                AuthServices.instance.addUserToDatabase(name: self.fullname!, address: "", profileImage: url) { (isSuccess) in
                    if isSuccess{
                        let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "loggedIn")
                        mainVC?.modalPresentationStyle = .fullScreen
                        SVProgressHUD.dismiss()
                        let defaults = UserDefaults.standard
                        defaults.set(true, forKey: "isFirstTime")
//                        AuthServices.instance.updateDeviceToken(accType: accType!)
                        self.present(mainVC!, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
