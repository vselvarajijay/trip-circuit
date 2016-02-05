//
//  TCTableCell.swift
//  trip-circuit
//
//  Created by Vijay Selvaraj on 2/4/16.
//  Copyright © 2016 Vijay Selvaraj. All rights reserved.
//

import UIKit



class TCTableCell: UITableViewCell {

    @IBOutlet var numVisits: UILabel!
    
    @IBOutlet var totalTime: UILabel!
    
    @IBOutlet var venueName: UILabel!

    
    
    public func configure(venueNameTxt:String, numVisitsTxt: String, totalTimeTxt:String) {
        venueName.text = venueNameTxt
        numVisits.text = numVisitsTxt
        totalTime.text = totalTimeTxt
        
    }
    /*
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.numVisits = UILabel()
        self.totalTime = UILabel()
        self.venueName = UILabel()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    */
    
}