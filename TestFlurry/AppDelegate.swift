//
//  AppDelegate.swift
//  TestFlurry
//
//  Created by siva krishna on 26/02/21.
//

import UIKit
import Flurry_iOS_SDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate, FlurryMessagingDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        registerForNotifications(application)
        registerFlurryMessaging(launchOptions)
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        FlurryMessaging.setDeviceToken(deviceToken)
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("Push token : \(deviceTokenString)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("push notifications not available for device...")
    }
    
    func registerForNotifications(_ application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        application.registerForRemoteNotifications()
    }
    
    func registerFlurryMessaging(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        //Step1 : Call the Integration API
        FlurryMessaging.setAutoIntegrationForMessaging()
        
        //Step2 : (Optional): Get a callback
        FlurryMessaging.setMessagingDelegate(self)
        
        //Step3 : Start Flurry session
        let builder = FlurrySessionBuilder.init().withIncludeBackgroundSessions(inMetrics: true)
        Flurry.startSession("JQP5SUUPLAMD9NRE8667", withOptions: launchOptions, with: builder)
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

