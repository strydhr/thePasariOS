//
//  AuthServices.swift
//  HomePlus
//
//  Created by Satyia Anand on 20/02/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CodableFirebase

let db = Firestore.firestore()

class AuthServices {
    static let instance = AuthServices()
    
    func registerNewUser(email:String,password:String,requestComplete:@escaping(_ status: Bool,_ error: Error?)->()){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error == nil{
                requestComplete(true,nil)
            }else{
                requestComplete(false,error!)
            }
        }
    }
    func addUserToDatabase(name:String,address:String,unit:String,lat:Double,lng:Double,geohash:String,profileImage:String,requestComplete:@escaping(_ status: Bool)->()){
        
        let user = User(uid: Auth.auth().currentUser!.uid, name: name, phone: "", address: address, unitNumber: unit, lat: lat, lng: lng, g: geohash, profileImage: profileImage, isActivated: true, isActive: true)
        
        let docData = try! FirestoreEncoder().encode(user)
        
        db.collection("User").document((Auth.auth().currentUser?.uid)!).setData(docData, completion: { (err) in
            if let error = err{
                print("Error Adding New User:\(error)")
            }else{
               requestComplete(true)
                
                
            }
        })
    }
     func loginUser(withEmail email: String,andPassword password: String,requestComplete: @escaping(_ status: Bool,_ error: Error?)->()){
    
    
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if error == nil{
                    requestComplete(true,nil)
                }else{
                    requestComplete(false,error!)
                }
            }
    
    
        }
    
    func updateUserInfo(newAddress:String,newUnitNumber:String,lat:Double,lng:Double,geohash:String,requestComplete:@escaping(_ status: Bool)->()){
        db.collection("User").document(userGlobal!.uid).updateData(["address":newAddress,"unitNumber":newUnitNumber,"l":[lat,lng],"g":geohash]){(error) in
            if error == nil{
                requestComplete(true)
            }
        }
    }
}


