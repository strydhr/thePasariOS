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
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //ADmob
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        //Notification Setup
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        if #available(iOS 13.0,*){
            window!.overrideUserInterfaceStyle = .light
        }
        
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
        
    
        
        // Firebase Configuration
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
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                            let preRegVC = storyboard.instantiateViewController(withIdentifier: "ViewProductsVC")
                            preRegVC.modalPresentationStyle = .fullScreen
                            self.window?.makeKeyAndVisible()
                            
                            self.window?.rootViewController?.present(preRegVC, animated: true, completion: nil )
                        }
                        
                    }
                }
                
                
            }else{
//            //Head to prereg view
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let preRegVC = storyboard.instantiateViewController(withIdentifier: "ViewProductsVC")
            preRegVC.modalPresentationStyle = .fullScreen
            self.window?.makeKeyAndVisible()

            self.window?.rootViewController?.present(preRegVC, animated: true, completion: nil )
            }
            
            
        }
        
        
        return true
    }


    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    
    func application(_ application: UIApplication,
                 didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken as Data
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        // Print full message.
        print(userInfo)

    }

    // This method will be called when app received push notifications in foreground
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    { completionHandler([UNNotificationPresentationOptions.alert,UNNotificationPresentationOptions.sound,UNNotificationPresentationOptions.badge])
    }


    // MARK:- Messaging Delegates
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
            }
        }
    }


    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("received remote notification")
    }



    

}

