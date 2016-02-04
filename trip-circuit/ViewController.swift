//
//  ViewController.swift
//  trip-circuit
//
//  Created by Vijay Selvaraj on 2/4/16.
//  Copyright © 2016 Vijay Selvaraj. All rights reserved.
//

import UIKit
import LocationKit



class ViewController: UIViewController {
    let locationManager = (UIApplication.sharedApplication().delegate as! AppDelegate).locationManager
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

