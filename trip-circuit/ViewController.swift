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
    var visits: [LKPlacemark] = []
   /* var visitsDict:[String:[String:Int]] = [
                    "Safeway" : ["visits":1, "total_time":2],
                    "Safeway1" : ["visits":1, "total_time":2],
                    "Safeway2" : ["visits":1, "total_time":2],
                    "Safeway3" : ["visits":1, "total_time":2],
                    "Safeway4" : ["visits":1, "total_time":2],
                    "Safeway5" : ["visits":1, "total_time":2],
                    "Safeway6" : ["visits":1, "total_time":2],
                    "Safeway7" : ["visits":1, "total_time":2],
                    "Safeway8" : ["visits":1, "total_time":2],
                    "Safeway9" : ["visits":1, "total_time":2],
                    "Safeway10" : ["visits":1, "total_time":2],
                    "Safeway11" : ["visits":1, "total_time":2],
                    "Safeway12" : ["visits":1, "total_time":2],
                    "Safeway13" : ["visits":1, "total_time":2]
                ]
    */
    
    var visitsDict = [String:[String:Int]]()
   
    // {'venue':{'visits':1, 'total_duration':1}}
    
    let locationManager = LKLocationManager()
    
    
    @IBOutlet weak var totalTimeLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    func timeFormatted(totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func totalTime() -> String {
        var totalSeconds: Int = 0
        
        for vendor in Array(self.visitsDict.keys) {
            totalSeconds += self.visitsDict[vendor]!["total_time"]!
        }
        
        return timeFormatted(totalSeconds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.debug = true
        self.locationManager.apiToken = "a0901652d0845189"
        self.locationManager.advancedDelegate = self
        //        let visitFilter = LKVisitFilter(venueCategory: "Grocery")
        //        self.locationManager.startMonitoringVisitsWithFilter(visitFilter)
        self.locationManager.startMonitoringVisits()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array(self.visitsDict.keys).count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("customCell", forIndexPath: indexPath) as! TCTableCell
        
        let venue = Array(self.visitsDict.keys)[indexPath.row]
        let num_visits = String(self.visitsDict[venue]!["visits"]!)
        let total_time = self.timeFormatted(self.visitsDict[venue]!["total_time"]!)
        
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.configure(venue, numVisitsTxt: num_visits, totalTimeTxt: total_time)
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100;
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
               
                
                let placeExists = self.visitsDict[place.name!] != nil

                if !placeExists {
                    self.visitsDict[place.name!] = [String:Int]()
                    self.visitsDict[place.name!]!["visits"] = 0
                    self.visitsDict[place.name!]!["total_time"] = 0
                }
                self.visitsDict[place.name!]!["visits"] = self.visitsDict[place.name!]!["visits"]! + 1
                self.visitsDict[place.name!]!["total_time"] = self.visitsDict[place.name!]!["total_time"]! + 1
                
            } else if error != nil {
                print("Uh oh, got an error: \(error)")
            } else {
                print("Your current place couldn't be determined")
            }
        }
        
        
        self.totalTimeLbl.text = self.totalTime()

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

