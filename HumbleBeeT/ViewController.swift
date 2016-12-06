//
//  ViewController.swift
//  HumbleBeeT
//
//  Created by Masha Rosca on 11/2/16.
//  Copyright © 2016 Humble Bee. All rights reserved.
//

import UIKit

// 1. Add the ESTBeaconManagerDelegate protocol
class ViewController: UIViewController, ESTBeaconManagerDelegate, ESTTriggerManagerDelegate  {
    
    // 2. Add the trigger manager
    let triggerManager = ESTTriggerManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 3. Set the trigger manager's delegate
        self.triggerManager.delegate = self
        self.beaconManager.delegate = self
        
        // 4. We need to request this authorization for every beacon manager
        self.beaconManager.requestAlwaysAuthorization()
        
        let rule2 = ESTMotionRule.motionStateEquals(
            true, forNearableIdentifier: "76d89c929d8bb0b9")
        
        let trigger = ESTTrigger(rules: [rule2], identifier: "shoe")
        
        self.triggerManager.startMonitoringForTrigger(trigger)
        
    }
    
    
    // 2. Add the beacon manager and the beacon region
    let beaconManager = ESTBeaconManager()
    let beaconRegion = CLBeaconRegion(
        proximityUUID: NSUUID(UUIDString: "DEA12345-BEE1-BEE2-BEE3-DEA123456BEE")!,
        identifier: "ranged region")
    
    @IBOutlet weak var centerLabel: UILabel!
    
    let placesByBeacons = [
        "52708:50717": [
            "Beetroot": 1,
        ],
        "42188:8361": [
            "Yellow": 1
        ],
        "43895:61361": [
            "Candy": 1
        ]

    ]
    
    func placesNearBeacon(beacon: CLBeacon) -> [String]? {
        let beaconKey = "\(beacon.major):\(beacon.minor)"
        if let places = self.placesByBeacons[beaconKey] {
            let sortedPlaces = Array(places).sort() { $0.1 < $1.1 }.map { $0.0 }
            return sortedPlaces
        }
        return nil
    }
    
    func beaconManager(manager: AnyObject, didEnterRegion region: CLBeaconRegion) {
        centerLabel.text = "entered"
    }
    
    func beaconManager(manager: AnyObject, didExitRegion region: CLBeaconRegion) {
        centerLabel.text = "exited"
    }
    
    func beaconManager(manager: AnyObject, didRangeBeacons beacons: [CLBeacon],
                       inRegion region: CLBeaconRegion) {
        if let nearestBeacon = beacons.first, places = placesNearBeacon(nearestBeacon) {
            // TODO: update the UI here
            print(places) // TODO: remove after implementing the UI
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.beaconManager.startRangingBeaconsInRegion(self.beaconRegion)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        //self.beaconManager.stopRangingBeaconsInRegion(self.beaconRegion)
    }
    
    func triggerManager(manager: ESTTriggerManager!,
                        triggerChangedState trigger: ESTTrigger!) {
        if (trigger.identifier == "shoe" && trigger.state == true) {
            centerLabel.text = "Shoe moving"
            print("shoe moving")
            let notification = UILocalNotification()
            notification.alertBody = "The shoe is moving"
            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        } else {
            centerLabel.text = "Shoe not moving"
            print("shoe not moving")
            
        }
    }


}

