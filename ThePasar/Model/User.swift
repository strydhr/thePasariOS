//
//  User.swift
//  ThePasar
//
//  Created by Satyia Anand on 24/07/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit
import CodableFirebase
import Firebase

class User: Codable {
    var uid:String
    var name: String
    var phone:String
    var address: String
    var profileImage:String
    var isActivated:Bool
    var isActive:Bool
    var deviceToken:String?
    
    init(uid:String,name:String,phone:String,address:String,profileImage:String,isActivated:Bool,isActive:Bool) {
        self.uid = uid
        self.name = name
        self.phone = phone
        self.address = address
        self.profileImage = profileImage
        self.isActivated = isActivated
        self.isActive = isActive
    }
}
