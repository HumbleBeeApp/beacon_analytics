//
//  AppDelegate.swift
//  HumbleBeeT
//
//  Created by Masha Rosca on 11/2/16.
//  Copyright © 2016 Humble Bee. All rights reserved.
//

import UIKit

// 1. Add the ESTBeaconManagerDelegate protocol
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ESTBeaconManagerDelegate,  ESTTriggerManagerDelegate  {
    
    var window: UIWindow?
    
    // 2. Add a property to hold the beacon manager and instantiate it
    let beaconManager = ESTBeaconManager()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // 3. Set the beacon manager's delegate
        print("In app didFinishLaunching")
        self.beaconManager.delegate = self
        self.beaconManager.requestWhenInUseAuthorization()
        
        self.beaconManager.startMonitoringForRegion(CLBeaconRegion(
            proximityUUID: NSUUID(UUIDString: "DEA12345-BEE1-BEE2-BEE3-DEA123456BEE")!,
            major: 42188, minor: 8361, identifier: "monitored region"))
        
        UIApplication.sharedApplication().registerUserNotificationSettings(
            UIUserNotificationSettings(forTypes: .Alert, categories: nil))
        
        print("num regions:" + String(beaconManager.monitoredRegions.count))
        
        print(beaconManager.monitoredRegions.first as! CLBeaconRegion == CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, major: 42188, minor: 8361, identifier: "monitored region"))
        
        // 2. Set up your Estimote Cloud credentials
        ESTConfig.setupAppID("humblebee-lez", andAppToken: "c8a193666b5791651edb54ebce23cc4b")
        
        // 3. Enable analytics
        ESTConfig.enableRangingAnalytics(true)
        ESTConfig.enableMonitoringAnalytics(true)
        
        // 4. Start scanning for beacons
        self.beaconManager.startRangingBeaconsInRegion(CLBeaconRegion(
            proximityUUID: NSUUID(UUIDString: "DEA12345-BEE1-BEE2-BEE3-DEA123456BEE")!,
            identifier: "humblebeeacons"))
        
        print("End of app didFinishLaunching")
        
        return true
    }
    
    func beaconManager(manager: AnyObject, didEnterRegion region: CLBeaconRegion) {
        print("Hi, in didEnterRegion")
        let notification = UILocalNotification()
        notification.alertBody = "Entered region of yellow beacon!"
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

