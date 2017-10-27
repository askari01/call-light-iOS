//
//  NurseProfile.swift
//  FirebaseSocialLogin
//
//  Created by Syed Askari on 29/03/2017.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftyUserDefaults
import SwiftyStarRatingView
import KVLoading

class NurseProfile: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }



    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var shift: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var request: UIButton!
    @IBOutlet weak var close: UIButton!
    @IBOutlet weak var ratings: SwiftyStarRatingView!
    
    var id: Int!
    var hospitalID: Int!
    var choice: Int = 1
    var startDate: String!
//    var endDate: String!
    var startTime: String!
    var endTime: String!
    var endTym: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        print ("id: \(self.id!)")
        
        // time
        let date = Date()
        var time = DateFormatter()
        time.dateFormat = "hh:mm:ss"
        var selectedTime = time.string(from: date)
        self.startTime = selectedTime
        
        request.layer.cornerRadius = 8
        close.layer.cornerRadius = 8
        
        var json1: JSON = []
//        let url1 = "http://thenerdcamp.com/calllight/public/api/v1/profile/hospitals?api_token" + UserDefaults.standard.string(forKey: "apiToken")!
        let url1 = "http://thenerdcamp.com/calllight/public/api/v1/profile/hospitals?api_token=" + UserDefaults.standard.string(forKey: "apiToken")!
        let completeUrl1 = URL(string:url1)!
        
        let headers1: HTTPHeaders = [
            "api_token": UserDefaults.standard.string(forKey: "apiToken")!
        ]
        
        Alamofire.request(completeUrl1, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil ).responseJSON{ response in
            print(response.request as Any)  // original URL request
            print(response.response as Any) // URL response
            print(response.result.value as Any)   // result of response serialization
            switch response.result {
            case .success:
//                print(response)
                if let value = response.result.value {
                    json1 = JSON(value)
                    print(json1)
                    self.hospitalID = json1["data"]["id"].int
                    print (self.hospitalID)
                }
                
                break
            case .failure(let error):
                print(error)
            }
            
        }
        
        request.isHidden = true
        request.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        var json: JSON = []
        
        let url = "http://thenerdcamp.com/calllight/public/api/v1/profile/nurses/\(self.id!)?api_token=" + UserDefaults.standard.string(forKey: "apiToken")!
        let completeUrl = URL(string:url)!
//        print(url)
        let headers: HTTPHeaders = [
            "api_token": UserDefaults.standard.string(forKey: "apiToken")!
        ]
        
        Alamofire.request(completeUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers ).responseJSON{ response in
            print(response.request as Any)  // original URL request
            print(response.response as Any) // URL response
            print(response.result.value as Any)   // result of response serialization
            switch response.result {
            case .success:
                if let value = response.result.value {
                    json = JSON(value)
                    print(json)
                    
                    var json1: JSON = []

                    let url1 = "http://thenerdcamp.com/calllight/public/api/v1/profile/ratings?api_token=\(UserDefaults.standard.string(forKey: "apiToken")!)&id=1&type=nurse"
                    let completeUrl1 = URL(string:url1)!
                    print (completeUrl1)
                    let headers1: HTTPHeaders = [
                        "api_token": UserDefaults.standard.string(forKey: "apiToken")!
                    ]
                    
                    Alamofire.request(completeUrl1, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil ).responseJSON{ response in
                        print(response.request as Any)  // original URL request
                        print(response.response as Any) // URL response
                        print(response.result.value as Any)   // result of response serialization
                        switch response.result {
                        case .success:
                            print(response)
                            if let value = response.result.value {
                                json1 = JSON(value)
                                let rating = json1["data"]["rating"].double
                                print (rating)
                                self.ratings.isHidden = false
                                self.ratings.value = CGFloat(rating!)
                            }
                            
                            break
                        case .failure(let error):
                            print(error)
                        }
                        
                    }
                    
                    self.name.text = json["data"]["name"].string!
//                    if json["data"]["gender"].string! == "0" {
//                        self.name.text = json["data"]["name"].string! + " (M)"
//                    } else {
//                        self.name.text = json["data"]["name"].string! + " (F)"
//                    }
                    if json["data"]["shift"].string! == "0" {
                        self.shift.text = "7 am to 7 pm"
                    } else if json["data"]["shift"].string! == "1" {
                        self.shift.text = "7 pm to 7 am"
                    } else {
                        self.shift.text = "Any time"
                    }
                    if json["data"]["type"].string! == "0" {
                        self.type.text = "RN"
                    } else {
                        self.type.text = "LVN/LPN"
                    }
                    
                    if json["data"]["address"].string! != nil && json["data"]["city"].string! != nil &&
                        json["data"]["country"].string! != nil && json["data"]["zip_code"].string! != nil && json["data"]["address"].string! != "empty" && json["data"]["city"].string! != "empty" &&
                        json["data"]["country"].string! != "empty" && json["data"]["zip_code"].string! != "empty" {
                        self.address.text = "\(json["data"]["address"].string!) \(json["data"]["city"].string!)  \(json["data"]["country"].string!)  \(json["data"]["zip_code"].string!)"
                    }
                    
//                    print(json["data"]["avatar_url"].string!)
                    if UserDefaults.standard.bool(forKey: "profileComplete") == false {
                        self.request.isHidden = false
                        self.request.setTitle("Your Request is pending approval", for: .normal)
                        
                        let alert = UIAlertController(title: "Profile Status", message: "Your Request is pending approval", preferredStyle: UIAlertControllerStyle.alert)
                        // add the actions (buttons)
                        
                        alert.addAction(UIAlertAction(title: "Log Out", style: UIAlertActionStyle.default, handler: { action in
                            var a = Logout.logOut()
                            if a {
                                self.performSegue(withIdentifier: "logOut", sender: self)
                            } else {
                                print ("logout issue")
                            }
                        }))
                        
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                        
                    } else {
                        self.request.isHidden = false
                        self.request.isEnabled = true
                    }
                    if ((json["data"]["avatar_url"] as? String) != nil) {
                        if let url = NSURL(string: json["data"]["avatar_url"].string!) {
                            if let data = NSData(contentsOf: url as URL) {
                                self.profileImage.image = UIImage(data: data as Data)
                            }
                        }
                    }
                }
                break
            case .failure(let error):
                print(error)
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func requestAction(_ sender: Any) {
        showOptions()
    }
    
    func showOptions() {
        // current date
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        
        // create the alert
        let alert = UIAlertController(title: "Request Nurse", message: "please select from the appropriate options", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Default Timings", style: UIAlertActionStyle.default, handler: {action in
            if self.shift.text == "7 am to 7 pm" {
                self.startTime = "7:00:00"
                self.endTime = "19:00:00"
            } else {
                self.startTime = "19:00:00"
                self.endTime = "7:00:00"
            }
            self.startDate = result
            
            self.requestSave()
        }))
        
        alert.addAction(UIAlertAction(title: "Custom Timings", style: UIAlertActionStyle.default, handler: { action in
            self.customTimings()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        // adding custom alert view
//        var a = UINib(nibName: "TimePickerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TimerPickerView
        
        // comment this line to use white color
//        alert.view.addSubview(a)
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func requestSave() {
        if choice == 1 {
            KVLoading.show()
            var json: JSON = []
            
            var result: Int!
            
            let parameters: Parameters = [
                "hospital_id": self.hospitalID,
                "nurse_id" : id,
                "shift_date": startDate,
                "shift_start_time" : startTime,
                "shift_end_time": endTime
            ]
            
            print (parameters)
            
            let headers: HTTPHeaders = [
                "api_token": UserDefaults.standard.string(forKey: "apiToken")!
            ]
            
//            print (headers)
            
            let url = "http://thenerdcamp.com/calllight/public/api/v1/hospital/request?api_token=" + UserDefaults.standard.string(forKey: "apiToken")!
            let completeUrl = URL(string:url)!
            
            print (completeUrl)
            
            Alamofire.request(completeUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers ).responseJSON{ response in
//                print(response.request as Any)  // original URL request
//                print(response.response as Any) // URL response
//                print(response.result.value as Any)   // result of response serialization
//                print(response)
                switch response.result {
                case .success:
//                    print(response)
                    if let value = response.result.value {
                        json = JSON(value)
//                        print(json)
//                        print(json[0])
                        KVLoading.hide()
                        // create the alert
                        let alert = UIAlertController(title: "Request Nurse", message: "Request to Nurse Sent", preferredStyle: UIAlertControllerStyle.alert)
                        
                        // add the actions (buttons)
                        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: {action in
                            self.performSegue(withIdentifier: "NurseMenu", sender: self)
                        }))
                        
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    break
                case .failure(let error):
                    print(error)
                    KVLoading.hide()
                }
            }
        } else {
            endTimeSet()
        }
    }

    func customTimings() {
        // create the alert
        let alert = UIAlertController(title: "Request Nurse", message: "please set start time (default end time is 12 hours from the selected time) \n\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {action in
            self.requestSave()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {action in
            self.choice = 1
        }))
        
        // adding custom alert view
        // Start time picker
        let startTimePicker = UIDatePicker(frame:
            CGRect(x: 5, y: 76, width: 260, height: 162))
        startTimePicker.datePickerMode = UIDatePickerMode.time
        startTimePicker.minuteInterval = 30
        startTimePicker.addTarget(self, action: #selector(NurseProfile.startValueDidChange), for: .valueChanged)

        
        //label
        let label = UILabel(frame: CGRect(x: -5, y: 255, width: 200, height: 17))
//        label.center = CGPoint(x: 0, y: 285)
        label.textAlignment = .center
        label.text = "Standard 12 hours shift"
        
        //switch
        let uiswitch = UISwitch(frame:  CGRect(x: 205, y: 247, width: 0, height: 0))
        uiswitch.isOn = true
        uiswitch.setOn(true, animated: false);
        uiswitch.addTarget(self, action: #selector(NurseProfile.switchValueDidChange), for: .valueChanged)
        
        // comment this line to use white color
        startTimePicker.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        alert.view.addSubview(startTimePicker)
        alert.view.addSubview(label)
        alert.view.addSubview(uiswitch)
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func startValueDidChange(sender: UIDatePicker) {
        var date = DateFormatter()
        var time = DateFormatter()
        
        date.dateFormat = "yyyy-MM-dd"
        time.dateFormat = "hh:mm:ss"
        var selectedDate = date.string(from: sender.date)
        var selectedTime = time.string(from: sender.date)
        
        startDate = selectedDate
        startTime = selectedTime
        endTym = sender.date.addingTimeInterval(12*60)
        var entym = time.string(from: endTym)
        endTime = entym
//        print ("start Value changed", sender.date)
//        print ("start Value changed", selectedDate)
//        print ("start Value changed", selectedTime)
    }
    
    func endValueDidChange(sender: UIDatePicker) {
        print ("end value changed",sender.date)
        var date = DateFormatter()
        var time = DateFormatter()
        date.dateFormat = "yyyy-MM-dd"
        time.dateFormat = "hh:mm:ss"
        var selectedDate = date.string(from: sender.date)
        var selectedTime = time.string(from: sender.date)
        startDate = selectedDate
        endTime = selectedTime
//        print ("start Value changed", sender.date)
//        print ("start Value changed", selectedDate)
//        print ("start Value changed", selectedTime)
    }
    
    func switchValueDidChange( ) {
//        print("value changes")
        var time = DateFormatter()
        time.dateFormat = "hh:mm:ss"
        
        if choice == 1 {
            choice = 0
            if endTym != nil {
                var selectedTime = time.string(from: endTym)
                endTime = selectedTime
            }
        } else {
            choice = 1
        }
    }
    
    func endTimeSet() {
        // create the alert
        let alert = UIAlertController(title: "Request Nurse", message: "please set END time\n\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Request", style: UIAlertActionStyle.default, handler: {action in
            self.choice = 1
            self.requestSave()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {action in
            self.choice = 1
        }))
        
        // adding custom alert view
        // Start time picker
        let endTimePicker = UIDatePicker(frame:
            CGRect(x: 5, y: 73, width: 260, height: 162))
        endTimePicker.datePickerMode = UIDatePickerMode.time
        endTimePicker.minuteInterval = 30
        endTimePicker.addTarget(self, action: #selector(NurseProfile.endValueDidChange), for: .valueChanged)
        
        // comment this line to use white color
        endTimePicker.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        alert.view.addSubview(endTimePicker)

        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
