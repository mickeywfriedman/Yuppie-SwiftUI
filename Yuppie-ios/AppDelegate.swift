//
//  AppDelegate.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 11/28/20.
//

import UIKit
import PushNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let pushNotifications = PushNotifications.shared


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        self.pushNotifications.start(instanceId: "69c2e5bf-1617-4e4e-b726-8b545a670c91")
        self.pushNotifications.start(instanceId: "a16e61ec-9ae8-43ee-8d21-f8e101ac0f5e")
        self.pushNotifications.registerForRemoteNotifications()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: String) -> Bool {
        if extensionPointIdentifier == UIApplication.ExtensionPointIdentifier.keyboard.rawValue {
            return false
        }
        return true
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.pushNotifications.registerDeviceToken(deviceToken)
    }
    
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let data = userInfo["data"] as! [String: Any]
        let message = ReceivedMessages(id: data["id"] as! String, sender: data["sender"] as! String, sentTime: data["sentTime"] as! String,  message: data["message"] as! String, type: data["type"] as! Int)
        self.pushNotifications.handleNotification(userInfo: userInfo)
        print(userInfo)
        NotificationCenter.default
                    .post(name: NSNotification.Name ("com.messages." + (data["sender"] as! String)),
                     object: message)
        
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

