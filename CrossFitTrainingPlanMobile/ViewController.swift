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
    let datePicker = UIDatePicker()
    @IBOutlet weak var metconSwitch: UISwitch!
    @IBOutlet weak var gymnasticsSwitch: UISwitch!
    @IBOutlet weak var olympicSwitch: UISwitch!
    @IBOutlet weak var powerSwitch: UISwitch!
    @IBOutlet weak var runningSwitch: UISwitch!
    
    var weekdays = [1:"Sunday",2:"Monday",3:"Tuesday",4:"Wednesday",5:"Thursday",6:"Friday",7:"Saturday"]
    var months = [1:"January",2:"February",3:"March",4:"April",5:"May",6:"June",7:"July",8:"August",9:"September",10:"October",11:"November",12:"December"]
    
    @IBAction func selectDate(_ sender: Any) {
        showDatePicker()
    }
    
    func showDatePicker() {
        //format date
        datePicker.datePickerMode = .date
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolBar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        dateTxtField.inputAccessoryView = toolBar
        dateTxtField.inputView = datePicker
    }
    
    @objc func donePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let dateStr = formatter.string(from: datePicker.date)
        dateTxtField.text = dateStr
        self.view.endEditing(true)
        getWodData(date: dateStr)
    }
    
    @objc func cancelDatePicker() {
        self.view.endEditing(true)
    }
    
    func getWodData(date: String) {
        let urlString = "http://crossfittrainingplanbackend.cfapps.io/wod?date="+date
        
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
                    // fill in workout parts
                    self.metconLabel.text = (json["metcon"] as! String)
                    self.gymnasticsLabel.text = (json["gymnastics"] as! String)
                    self.olympicLabel.text = (json["oly"] as! String)
                    self.powerLabel.text = (json["power"] as! String)
                    self.runningLabel.text = (json["running"] as! String)
                    
                    // fill in status switches
                    let switches : [String:UISwitch] = ["metconStatus":self.metconSwitch,"gymnasticsStatus":self.gymnasticsSwitch,"olyStatus":self.olympicSwitch,"powerStatus":self.powerSwitch,"runningStatus":self.runningSwitch]
                    
                    for status in switches.keys {
                        if (json[status] as! String) == "FALSE" {
                            switches[status]!.isOn = false;
                        }
                        else {
                            switches[status]!.isOn = true;
                        }
                    }
                }

            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
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
        
        dateTxtField.text = String(monthNum)+"/"+String(day)+"/"+String(year)
        
        getWodData(date: String(monthNum)+"/"+String(day)+"/"+String(year))
    }
    
    

}

