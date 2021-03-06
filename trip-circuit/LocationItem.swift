//
//  LocationItem.swift
//  LocationKitApp
//
//  Created by Michael Sanford on 11/21/15.
//  Copyright © 2015 SocialRadar. All rights reserved.
//

import LocationKit
import CoreLocation

class LocationItem: NSObject, NSCoding {
    static let csvText = "visit|place,arrival_day,arrival_time,departure_day,departure_time,latitude,longitude,flagged,venue_name,street_address,city,state,postal_code"
    
    private static let dayFormatter = NSDateFormatter()
    private static let timeFormatter = NSDateFormatter()
    
    var visit: LKVisit?
    var flagged: Bool = false
    
    let placemark: LKPlacemark?
    let placemarkDate: NSDate?
    let placemarkCoordinate: CLLocationCoordinate2D?
    
    override class func initialize() {
        dayFormatter.dateStyle = .ShortStyle
        dayFormatter.timeStyle = .NoStyle
        timeFormatter.dateStyle = .NoStyle
        timeFormatter.timeStyle = .ShortStyle
    }
    
    init(place: LKPlacemark, date: NSDate, coordinate: CLLocationCoordinate2D) {
        placemark = place
        placemarkDate = date
        placemarkCoordinate = coordinate
        visit = nil
    }
    
    init(visit: LKVisit) {
        self.visit = visit
        placemark = nil
        placemarkDate = nil
        placemarkCoordinate = nil
    }
    
    var title: String {
        if let visit = visit {
            return visit.place.name ?? "\(visit.place.subThoroughfare) \(visit.place.thoroughfare)"
            
        } else if let placemark = placemark {
            return placemark.venue?.name ?? "\(placemark.subThoroughfare) \(placemark.thoroughfare)"
            
        } else {
            assert(false, "LocationItem in invalid state. this should never happen")
            return ""
        }
    }
    
    var place: LKPlacemark {
        return placemark ?? visit!.place
    }
    
    var date: NSDate {
        return placemarkDate ?? visit!.arrivalDate
    }
    
    var coordinate: CLLocationCoordinate2D {
        return placemarkCoordinate ?? visit!.coordinate
    }
    
    @objc func encodeWithCoder(aCoder: NSCoder) {
        if let visit = visit {
            aCoder.encodeObject(visit, forKey: "visit")
        }
        aCoder.encodeBool(flagged, forKey: "flagged")
        
        if let placemark = placemark {
            aCoder.encodeObject(placemark, forKey: "placemark")
        }
        
        if let placemarkDate = placemarkDate {
            aCoder.encodeObject(placemarkDate, forKey: "placemarkDate")
        }
        
        if let placemarkCoordinate = placemarkCoordinate {
            aCoder.encodeDouble(placemarkCoordinate.latitude, forKey: "placemarkLatitude")
            aCoder.encodeDouble(placemarkCoordinate.longitude, forKey: "placemarkLongitude")
        }
    }
    
    @objc required init?(coder aDecoder: NSCoder) {
        visit = aDecoder.decodeObjectForKey("visit") as? LKVisit
        flagged = aDecoder.decodeBoolForKey("flagged")
        placemark = aDecoder.decodeObjectForKey("placemark") as? LKPlacemark
        placemarkDate = aDecoder.decodeObjectForKey("placemarkDate") as? NSDate
        let latitude = aDecoder.decodeDoubleForKey("placemarkLatitude")
        let longitude = aDecoder.decodeDoubleForKey("placemarkLongitude")
        if (latitude != 0.0) && (longitude != 0.0) {
            placemarkCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            placemarkCoordinate = nil
        }
    }
    
    var csvText: String {
        // visit|place,dd/mm/yyyy,16:34:50,dd/mm/yyyy,16:34:50,latitude,longitude,flagged,
        let title: String
        let departureText: String
        if let visit = visit {
            title = "visit"
            departureText = "\(LocationItem.dayFormatter.stringFromDate(visit.departureDate)),\(LocationItem.timeFormatter.stringFromDate(visit.departureDate))"
        } else {
            title = "place"
            departureText = ","
        }
        
        let venueName: String
        if let name = place.venue?.name {
            venueName = name
        } else {
            venueName = ""
        }
        
        let streetName: String
        if let name = place.thoroughfare {
            if let streetNumber = place.subThoroughfare {
                streetName = "\(streetNumber) \(name)"
            } else {
                streetName = name
            }
        } else {
            streetName = ""
        }
        
        let city: String
        let state: String
        let postalCode: String
        
        if let name = place.locality {
            city = name
        } else {
            city = ""
        }
        
        if let name = place.administrativeArea {
            state = name
        } else {
            state = ""
        }
        
        if let name = place.postalCode {
            postalCode = name
        } else {
            postalCode = ""
        }
        
        let csvText = "\(title),\(LocationItem.dayFormatter.stringFromDate(date)),\(LocationItem.timeFormatter.stringFromDate(date)),\(departureText),\(coordinate.latitude),\(coordinate.longitude),\(flagged ? "1" : ""), \(venueName),\(streetName),\(city),\(state),\(postalCode)"
        return csvText
        
    }
}
