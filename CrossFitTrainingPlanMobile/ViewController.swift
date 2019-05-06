//
//  ViewController.swift
//  CrossFitTrainingPlanMobile
//
//  Created by Max Davis on 5/5/19.
//  Copyright © 2019 Max Davis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var weekdays = [1:"Sunday",2:"Monday",3:"Tuesday",4:"Wednesday",5:"Thursday",6:"Friday",7:"Saturday"]
    var months = [1:"January",2:"February",3:"March",4:"April",5:"May",6:"June",7:"July",8:"August",9:"September",10:"October",11:"November",12:"December"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = months[calendar.component(.month, from: date)] as! String
        let day = calendar.component(.day, from: date)
        let weekday = weekdays[calendar.component(.weekday, from: date)] as! String
        
        dayLabel.text = weekday+" "+month+" "+String(day)+" "+String(year)
        
    }
    @IBOutlet weak var dayLabel: UILabel!
    
    

}

