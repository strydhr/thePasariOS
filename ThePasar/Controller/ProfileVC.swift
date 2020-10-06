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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell")as? profileCell else {return UITableViewCell()}
        if indexPath.row == 0{
            cell.contentLabel.text = userGlobal?.name
        }else if indexPath.row == 1{
            let address = userGlobal?.address
            let wantedString = address?.components(separatedBy: ",")
            var add = ""
            for word in wantedString!{
                add.append("\(word)\n")
            }
            cell.contentLabel.text = add
            cell.editBtn.isHidden = false
            cell.delegate = self
        }else if indexPath.row == 2{
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
        case 2:
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
