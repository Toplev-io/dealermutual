//
//  AppDelegate.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 9/15/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import FirebaseMessaging
import Foundation
import Alamofire
import ObjectMapper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    let gcmMessageIDKey = "gcm.message_id"
    
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.1254901961, green: 0.4352941176, blue: 0.6509803922, alpha: 1)
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().isTranslucent = false
        
        
        
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        
        
        Messaging.messaging().delegate = self
        
       // [START register_for_notifications]
       if #available(iOS 10.0, *) {
           // For iOS 10 display notification (sent via APNS)
        UNUserNotificationCenter.current().delegate = self
        
       } else {
           let settings: UIUserNotificationSettings =
               UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
           application.registerUserNotificationSettings(settings)
       }
        
    
       UIApplication.shared.applicationIconBadgeNumber = 0
    
    
    
        UNUserNotificationCenter.current() // 1
              .requestAuthorization(options: [.alert, .sound, .badge]) { // 2
                  granted, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                print("Permission granted: \(granted)") // 3
                
          }
        
        // get application instance ID
        InstanceID.instanceID().instanceID {(result, error) in
            if let error = error {
                print("error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
            }
        }
        
        application.registerForRemoteNotifications()
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        if let firebaseUser = Auth.auth().currentUser {
            let currentAccount = DMUserAccount(with: firebaseUser)

            saveUserInDatabase(account:currentAccount, isOnline: false)
                   
        }
    }
    
    private func saveUserInDatabase(account: DMUserAccount,isOnline: Bool) {
           let keyOnlineStatusKey =  "isOnline"
           var jsonObject = account.toJSON()
           let userID = Auth.auth().currentUser?.uid ?? ""
           jsonObject[keyOnlineStatusKey] = isOnline
           Database.database().reference().child("users/\(userID)/\(keyOnlineStatusKey)").onDisconnectSetValue(false)
           Database.database().reference().child("users/\(userID)").setValue(jsonObject)
       }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
          // If you are receiving a notification message while your app is in the background,
          // this callback will not be fired till the user taps on the notification launching the application.
          // TODO: Handle data of notification
          
          // Print message ID.
          if let messageID = userInfo[gcmMessageIDKey] {
              print("Message ID: \(messageID)")
          }
          
          // Print full message.
          print(userInfo)
          
      }
      
      func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                       fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
          // If you are receiving a notification message while your app is in the background,
          // this callback will not be fired till the user taps on the notification launching the application.
          // TODO: Handle data of notification
          
          // Print message ID.
          
          if let messageID = userInfo[gcmMessageIDKey] {
              print("Message ID: \(messageID)")
          }
          
          UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
          
          // Print full message.
          print(userInfo)
          
          completionHandler(UIBackgroundFetchResult.newData)
          
          
      }
      
      func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
          print("Unable to register for remote notifications: \(error.localizedDescription)")
      }
      // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
      // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
      // the InstanceID token.
      func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
          print("APNs token retrieved: \(deviceToken)")
          
          //Messaging.messaging().apnsToken = deviceToken
          
      }
    
    
    func sendPush(text:String, token:String){
        
        guard let url = URL(string: "https://fcm.googleapis.com/fcm/send") else { return }
        let info = PushSenderInfo()
        info.to = token
        info.notification.body = text
        
        let serverKey = "AAAA_LqlG-g:APA91bE80e_XBCwNVuu7VK5XG7_xZQArP3Tk9DDps_wBzdUGbO63001j0sluyftCpltryKDL0sfByYRgR-yurWc3zBgm1h_A34Iv5oDDun-7He9eqN9XYh_AABEAcKT5ihLtNaeDSX7b"
        let headers: HTTPHeaders = ["Authorization" : "key=\(serverKey)"]
        let request = Alamofire.request(url, method: .post, parameters: info.toJSON(), encoding: JSONEncoding.default, headers: headers)
//        debugPrint(request)
        request.response { (response) in
//            print("response=\(response)")
            
        }
    }
    

    fileprivate class NotificationData: Mappable {
        var body: String = ""
        var title = "Dealer Mutual"
        var sound = "default"
        
        required init?(map: Map) {}
        
        init() {}
        
        func mapping(map: Map) {
            body <- map["body"]
            title <- map["title"]
            sound <- map["sound"]
        }
    }

    fileprivate class PushSenderInfo: Mappable {
        var to: String = ""
        var notification = NotificationData()
        var data = ["action" : "sale"]
        
        required init?(map: Map) {}
        
        init() {}
        
        func mapping(map: Map) {
            to <- map["to"]
            notification <- map["notification"]
            data <- map["data"]
        }
    }
 

      
}



// [END ios_10_message_handling]
//
extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        UserDefaults.standard.set(fcmToken, forKey: "token")
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
        
        _ = remoteMessage.appData
        
    }
    // [END ios_10_data_message]
}

 


