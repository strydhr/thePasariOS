//
//  ProfileVC.swift
//  ThePasar
//
//  Created by Satyia Anand on 28/09/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {
    @IBOutlet weak var profileTable: UITableView!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTable.delegate = self
        profileTable.dataSource = self
        profileTable.separatorStyle = .none
        profileTable.register(UINib(nibName: "profileCell", bundle: nil), forCellReuseIdentifier: "profileCell")
        
    }
    

    @objc func backgroundTapped(){
        self.dismiss(animated: true, completion: nil)
    }

}
extension ProfileVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell")as? profileCell else {return UITableViewCell()}
        if indexPath.row == 0{
            cell.contentLabel.text = userGlobal?.name
        }else if indexPath.row == 1{
            let address = userGlobal?.address
            let wantedString = address?.components(separatedBy: ", ")
            var add = ""
            if userGlobal?.unitNumber != ""{
                add = "\((userGlobal?.unitNumber)!)\n"
            }
            
            for word in wantedString!{
                add.append("\(word)\n")
            }
            cell.contentLabel.text = add
            cell.editBtn.isHidden = false
            cell.isAddress = true
            cell.delegate = self
        }else if indexPath.row == 2{
            cell.contentLabel.text = userGlobal?.phone
            cell.editBtn.isHidden = false
            cell.delegate = self
        }else if indexPath.row == 3{
            cell.contentLabel.text = "Enable Hints"
        }else if indexPath.row == 4{
            cell.contentLabel.text = "Log Out"
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 3:
//            let domain = Bundle.main.bundleIdentifier
//            defaults.removePersistentDomain(forName: domain!)
//            defaults.synchronize()
//            UserDefaults.clear()
//            let orderHint = defaults.string(forKey: "historyHintDone")
            defaults.setValue(false, forKey: "historyHintDone")
            defaults.setValue(false, forKey: "orderHintDone")
            defaults.setValue(false, forKey: "mainTabHintDone")
            

        case 4:
            let logOutPopUP = UIAlertController(title: "Logout?", message: "Are you sure you want to log out?", preferredStyle: .alert)
            logOutPopUP.addAction(UIAlertAction(title: "Logout", style: .default, handler: { (buttonTapped) in
                do{
                    try Auth.auth().signOut()
                    let initialVC = self.storyboard?.instantiateViewController(withIdentifier: "initialVC")
                    //probelm logging out then sign new acc
                    userGlobal = nil
                    
                    //
                    initialVC?.modalPresentationStyle = .fullScreen
                    self.present(initialVC!, animated: true, completion: nil)
                } catch{
                    print(error)
                    
                }
                
                
            }))
            present(logOutPopUP, animated: true, completion:  {
                
                logOutPopUP.view.superview?.isUserInteractionEnabled = true
                logOutPopUP.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.backgroundTapped)))
            })
        default:
            print("None")
        }
    }
    
}

extension ProfileVC:editProfileDetailsDelegate,doneUpdateProfileDelegate{
    func editNumber(user: User) {
        var phone:UITextField!
        let alert = UIAlertController(title: "Change Number", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            userGlobal?.phone = phone.text!
            AuthServices.instance.updateUserNumber(newNumber: phone.text!) { (isSuccess) in
                if isSuccess{
                    self.profileTable.reloadData()
                }
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        alert.addTextField { (tf) in
            tf.placeholder = "Phone Number"
            tf.keyboardType = .phonePad
            phone = tf
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func updatedProfile(user: User) {
        profileTable.reloadData()
    }
    
    func editDetails(user: User) {
        let updateAddress = updateAddressPopup()
        updateAddress.delegate = self
        updateAddress.modalPresentationStyle = .custom
        present(updateAddress, animated: true, completion: nil)
    }
    
    
}

extension UserDefaults{
    class func clear(){
        guard let domain = Bundle.main.bundleIdentifier else {return}
        standard.removePersistentDomain(forName: domain)
        standard.synchronize()
    }
    
    class func exist(key:String)->Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
