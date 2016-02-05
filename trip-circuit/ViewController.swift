//
//  ViewController.swift
//  trip-circuit
//
//  Created by Vijay Selvaraj on 2/4/16.
//  Copyright © 2016 Vijay Selvaraj. All rights reserved.
//

import UIKit
import LocationKit



class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, LKLocationManagerDelegate {
    var visitsDict:NSMutableDictionary?
    var visits: [LKPlacemark] = []
   
    // {'venue':{'visits':1, 'total_duration':1}}
    
    
    
    let locationManager = LKLocationManager()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.debug = true
        self.locationManager.apiToken = "a0901652d0845189"
        self.locationManager.advancedDelegate = self
        //        let visitFilter = LKVisitFilter(venueCategory: "Grocery")
        //        self.locationManager.startMonitoringVisitsWithFilter(visitFilter)
        self.locationManager.startMonitoringVisits()

        
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visits.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        
        cell.textLabel?.text = (self.visitsDict?.allKeys as! [String])[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func locationManager(manager: LKLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        
        self.locationManager.requestPlace { (place: LKPlacemark?, error: NSError?) -> Void in
            if let place = place {
                print("Welcome to \(place.name)")
                
                let localNotification = UILocalNotification()
                localNotification.alertBody = "You are currently at: \(place.name)"
                localNotification.timeZone = NSTimeZone.localTimeZone()
                localNotification.fireDate = NSDate()
                UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
                
                self.visits.append(place)
                
                let placeExists = self.visitsDict![place.name!] != nil

                if !placeExists {
                    self.visitsDict![place.name!] = NSMutableDictionary()
                }
                
                self.visitsDict![place.name!]?.setValue(1, forKey: "visits")
                self.visitsDict![place.name!]?.setValue(1, forKey: "total_time")
                
                
                
            } else if error != nil {
                print("Uh oh, got an error: \(error)")
            } else {
                print("Your current place couldn't be determined")
            }
        }
        
        self.tableView.reloadData()
        self.tableView.reloadInputViews()
        
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
        myAlert.title = "Visit  started "
        myAlert.message = "location: \(locationItem.title)"
        myAlert.addButtonWithTitle("Ok")
        myAlert.delegate = self
        myAlert.show()
        
    }
    
    func locationManager(manager: LKLocationManager, didEndVisit visit: LKVisit) {
        // Print out the street number and street name of the place where this
        // visit started
        
        
        //self.visits.append(visit)
        
        let locationItem = LocationItem(visit: visit)
        
        let localNotification = UILocalNotification()
        localNotification.alertBody = "Visit ended at \(locationItem.title)"
        localNotification.timeZone = NSTimeZone.localTimeZone()
        localNotification.fireDate = NSDate()
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        
        let myAlert = UIAlertView()
        myAlert.title = "Visit  ended "
        myAlert.message = "location: \(locationItem.title)"
        myAlert.addButtonWithTitle("Ok")
        myAlert.delegate = self
        myAlert.show()
        
        print("Ended visit at \(visit.place.subThoroughfare), \(visit.place.thoroughfare)")
    }
    
    
}

