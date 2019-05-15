//
//  ViewController.swift
//  CrossFitTrainingPlanMobile
//
//  Created by Max Davis on 5/5/19.
//  Copyright © 2019 Max Davis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var metconLabel: UILabel!
    @IBOutlet weak var gymnasticsLabel: UILabel!
    @IBOutlet weak var olympicLabel: UILabel!
    @IBOutlet weak var powerLabel: UILabel!
    @IBOutlet weak var runningLabel: UILabel!
    @IBOutlet weak var dateTxtField: UITextField!
    
    var weekdays = [1:"Sunday",2:"Monday",3:"Tuesday",4:"Wednesday",5:"Thursday",6:"Friday",7:"Saturday"]
    var months = [1:"January",2:"February",3:"March",4:"April",5:"May",6:"June",7:"July",8:"August",9:"September",10:"October",11:"November",12:"December"]
    
    func getWodData() {
        let urlString = "http://crossfittrainingplanbackend.cfapps.io/wod"
        
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
//            print("data: ",data)
//            print("response:",response)
//            print("error:",error)
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            do {
                guard let json = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String:Any] else {
                        
                        print("error trying to convert data to JSON")
                        return
                }
                print(json)
                
                // update the workout labels
                DispatchQueue.main.async {
                    self.metconLabel.text = (json["metcon"] as! String)
                    self.gymnasticsLabel.text = (json["gymnastics"] as! String)
                    self.olympicLabel.text = (json["oly"] as! String)
                    self.powerLabel.text = (json["power"] as! String)
                    self.runningLabel.text = (json["running"] as! String)
                }

            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
        
//        let url = "www.google.com"
//        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
//        request.httpMethod = "GET"
//        let session = URLSession.shared
//        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
//            if(error != nil){
//
//            } else{
//                print(data)
////                let result = JSON(data: data!)
//
//            }
//        })
//        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let monthNum = calendar.component(.month, from: date)
        let month = months[monthNum] as! String
        let day = calendar.component(.day, from: date)
        let weekday = weekdays[calendar.component(.weekday, from: date)] as! String
        
        dayLabel.text = weekday+" "+month+" "+String(day)+" "+String(year)
        dateTxtField.text = String(monthNum)+"/"+String(day)+"/"+String(year)
        
        getWodData()
    }
    @IBOutlet weak var dayLabel: UILabel!
    
    

}

