//
//  AppDelegate.swift
//  trip-circuit
//
//  Created by Vijay Selvaraj on 2/4/16.
//  Copyright © 2016 Vijay Selvaraj. All rights reserved.
//

import UIKit
import LocationKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LKLocationManagerDelegate {

    var window: UIWindow?
    let locationManager = LKLocationManager()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        // The debug flag is not necessary (and should not be enabled in prod)
        // but does help to ensure things are working correctly
        self.locationManager.debug = true
        self.locationManager.apiToken = "a0901652d0845189"
        self.locationManager.advancedDelegate = self
        //self.locationManager.startMonitoringVisits()
        let visitFilter = LKVisitFilter(venueCategory: "Grocery")
        self.locationManager.startMonitoringVisitsWithFilter(visitFilter)
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil))
                
        return true
    }
    
    func locationManager(manager: LKLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            print("You are currently at: \(location)")
            let localNotification = UILocalNotification()
            localNotification.alertBody = "\(location)"
            localNotification.timeZone = NSTimeZone.localTimeZone()
            localNotification.fireDate = NSDate()
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        }
    }
    
    func locationManager(manager: LKLocationManager, didStartVisit visit: LKVisit) {
        // Print out the street number and street name of the place where this
        // visit started
        print("Started visit at \(visit.place.subThoroughfare), \(visit.place.thoroughfare)")
        
        let locationItem = LocationItem(visit: visit)
        let localNotification = UILocalNotification()
        localNotification.alertBody = "Visit started at \(locationItem.title)"
        localNotification.timeZone = NSTimeZone.localTimeZone()
        localNotification.fireDate = NSDate()
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        
        
        let myAlert = UIAlertView()
        myAlert.title = "Visit started "
        myAlert.message = "\(locationItem.title)"
        myAlert.addButtonWithTitle("Ok")
        myAlert.delegate = self
        myAlert.show()
        
        
    }
    
    func locationManager(manager: LKLocationManager, didEndVisit visit: LKVisit) {
        // Print out the street number and street name of the place where this
        // visit started
        print("Ended visit at \(visit.place.subThoroughfare), \(visit.place.thoroughfare)")
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

