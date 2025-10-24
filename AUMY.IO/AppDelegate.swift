//
//  AppDelegate.swift
//  AUMY.IO
//
//  Created by iOS Developer on 03/10/25.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import CoreLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let locationManager = CLLocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        KeyboardStateListener.shared.start()
        initializeLocation()
        
        UNUserNotificationCenter.current().delegate = self
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.alert, .sound]) { (granted, error) in
            guard granted else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        
        let notification = launchOptions?[.remoteNotification]
        
        if let data = notification, let notificationData = data as? [AnyHashable : Any] {
            self.application(application, didReceiveRemoteNotification: notificationData)
        }
        
        if let launchOpts = launchOptions as [UIApplication.LaunchOptionsKey: Any]? {
            if let _ = launchOpts[UIApplication.LaunchOptionsKey.remoteNotification] as? NSDictionary { }
        } else {
            //go with the regular flow
        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

extension AppDelegate: CLLocationManagerDelegate {
    func initializeLocation() {
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinates = manager.location?.coordinate else { return }
        CurrentLocation.latitude = coordinates.latitude.roundToPlace(7)
        CurrentLocation.longitude = coordinates.longitude.roundToPlace(7)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenID = deviceToken.map { data in String(format: "%02.2hhx", data) }
        UserDefaults.standard[.deviceToken] = deviceTokenID.joined()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        if let uuidString = UIDevice.current.identifierForVendor?.uuidString {
            let data = Data(uuidString.utf8)
            let deviceTokenID = data.map { data in String(format: "%02.2hhx", data) }
            UserDefaults.standard[.deviceToken] = deviceTokenID.joined()
        } else {
            UserDefaults.standard[.deviceToken] = "please check device token"
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .banner])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) { }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) { }
}
