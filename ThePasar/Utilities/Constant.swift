//
//  Constant.swift
//  ThePasar
//
//  Created by Satyia Anand on 22/07/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import Foundation

let GOOGLEAPI = "AIzaSyBJX4rJfXX71st5SdbqrDdEdBPQzZ0KIZw"
let serverKey = "AAAAUJA7Y08:APA91bG1yX3iyxgdhD3jFB-ag3TlD6HxixV_GAR3aOhz-QoIU7a2s51I_GpWUsCXiRaXSXvguU2kIysHmJfVK5wWlgpC2L17j9ROxba_avFWQ9ciVPZp9U-Aht95BMyGj0Jx2A_cDPz0"

var userGlobal:User?

struct Radius{
    var label:String
    var radius:Double
    
}

let radiusList = [Radius(label: "5 Km", radius: 5),Radius(label: "15 Km", radius: 15),Radius(label: "more than 15 Km", radius: 100)]

func getDateLabel(dates:Date)->String{
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    let dateStr = formatter.string(from: dates)
    return dateStr
}

func getTimeLabel(dates:Date)->String{
    let formatter = DateFormatter()
    formatter.dateFormat = "hh:mm a"
    let dateStr = formatter.string(from: dates)
    return dateStr
}
