//
//  AppDelegate.swift
//  ThePasar
//
//  Created by Satyia Anand on 21/07/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GMSPlacesClient.provideAPIKey(GOOGLEAPI)
        
        let tabBar = UITabBar.appearance()
        tabBar.barTintColor = UIColor.clear
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        
        let defaults = UserDefaults.standard
        
        if(!defaults.bool(forKey: "hasRunBefore")){
            do{
                try Auth.auth().signOut()
            }catch{
                
            }
            defaults.set(true, forKey: "hasRunBefore")
            defaults.synchronize()
            
        }else{
            if Auth.auth().currentUser != nil{
                print(Auth.auth().currentUser?.email)
                let userInfo = db.collection("User").document((Auth.auth().currentUser?.uid)!)
                userInfo.getDocument { (snapshot, err) in
                    if err == nil{
                        if snapshot!.exists{
                            guard let snapShot = snapshot?.data() else {return}
                            userGlobal = try! FirestoreDecoder().decode(User.self, from: snapShot )
                            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                            let authVC = storyboard.instantiateViewController(withIdentifier: "loggedIn")
                            authVC.modalPresentationStyle = .fullScreen
                            self.window?.makeKeyAndVisible()
                            
                            self.window?.rootViewController?.present(authVC, animated: true, completion: nil )
                        }else{
                            try! Auth.auth().signOut()
                        }
                        
                    }
                }
                
                
            }        }
        
        
        return true
    }



}

