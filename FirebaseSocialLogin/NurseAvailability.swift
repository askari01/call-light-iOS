//
//  NurseAvailability.swift
//  FirebaseSocialLogin
//
//  Created by Syed Askari on 29/03/2017.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KVLoading
import SwiftyUserDefaults
import CoreLocation
import SwiftyStarRatingView

class NurseAvailability: UIViewController, UIGestureRecognizerDelegate, UITabBarDelegate, CLLocationManagerDelegate, UITextViewDelegate {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var blur: UIImageView!
    @IBOutlet weak var startShiftBtn: UIButton!
    @IBOutlet weak var startLunchBreakAction: UIButton!
    
    let available = DefaultsKey<Int>("availability")
    var locationManager = CLLocationManager()
    var distanceInMeters = CLLocationDistance()
    var alert1: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startShiftBtn.layer.cornerRadius = 8
        startLunchBreakAction.layer.cornerRadius = 8
        
        // adding tap gesture
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //Looks for single or multiple taps.
        let tap1: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap1)
        
        label.text = "Tap to set Status"
        image.image = UIImage(named: "nurseDecline.png")
        
        if UserDefaults.standard.bool(forKey: "profileVerified") == false {
            let alert = UIAlertController(title: "Profile Status", message: "Your Account Verificatoin Request is pending approval", preferredStyle: UIAlertControllerStyle.alert)
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
        }
        
        //testing UITabBar
//        print ("items in tabBar are: ",tabBar.items?.count)
//        var tabIndex = tabBar.items?.index(of: tabBar.selectedItem!)
//        print (tabIndex)
        //end test
        
        // Do any additional setup after loading the view.
        if Defaults[self.available] == nil {
            KVLoading.show()
            availability()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(availability))
        tap.numberOfTapsRequired = 1
        label.addGestureRecognizer(tap)
        image.addGestureRecognizer(tap)
        
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
         
        if UserDefaults.standard.double(forKey: "HospitalLat") == 0.0 {
            self.startLunchBreakAction.isHidden = true
            self.startShiftBtn.isHidden = true
        }
        
        if startShiftBtn.isEnabled {
            if CLLocationManager.locationServicesEnabled() {
              locationManager.startUpdatingLocation()
            } else {
                locationManager.requestWhenInUseAuthorization()
            }
        }
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.alert1.view.frame.origin.y -= keyboardSize.height - 100
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.alert1.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var coordinate: CLLocationCoordinate2D = getLocation()
//        print ("latitude: ",coordinate.latitude)
//        print ("longitude: ",coordinate.longitude)
//        
//        print ("hospital latitude: ", UserDefaults.standard.double(forKey: "HospitalLat"))
//        print ("hospital longitude: ", UserDefaults.standard.double(forKey: "HospitalLong"))
        
        //My location
        var myLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        //Hospital location
        var myBuddysLocation = CLLocation(latitude: UserDefaults.standard.double(forKey: "HospitalLat"), longitude: UserDefaults.standard.double(forKey: "HospitalLong"))
        
        //Measuring my distance to my buddy's (in meters)
        var distance = myLocation.distance(from: myBuddysLocation)
        
        //Display the result in m
        print(String(format: "The distance to my buddy is %.01fmeters", distance))
        
        if distance < 50 {
            
            DispatchQueue.main.async {
//                self.startShiftBtn.isHidden = false
//                self.startLunchBreakAction.isHidden = false
                
                self.startShiftBtn.isEnabled = true
                self.startLunchBreakAction.isEnabled = true
                self.locationManager.stopUpdatingLocation()
            }
            self.label.text = "You are now in vicinity"
            self.image.isHidden = true
//            self.startShiftBtn.isHidden = false
//            self.startLunchBreakAction.isHidden = false
            self.startShiftBtn.isEnabled = true
            self.startLunchBreakAction.isEnabled = true
            
            // create the alert
            let alert = UIAlertController(title: "SHIFT", message: "You are Near or In Hospital Do you want to start shift ?", preferredStyle: UIAlertControllerStyle.alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Start Shift", style: UIAlertActionStyle.default, handler: {action in
                self.StartShift()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func rating2() {
        
        // create the alert
        alert1 = UIAlertController(title: "\n\nCall Light", message: "Rating\n\n\n\n\n\n\n\n", preferredStyle: UIAlertControllerStyle.alert)
        
        // getting alertview
        
        let x = (alert1.view.frame.width - 80) / 2
        
        // adding image
        var imageView = UIImageView(frame: CGRect(x: x, y:10, width:36, height:54))
        imageView.image = UIImage(named: "logo1")
        
        alert1.view.addSubview(imageView)
        
        // Ratings
        let starRatingView = SwiftyStarRatingView()
        
        starRatingView.frame = CGRect(x: (x-70), y: imageView.frame.maxY + 40, width: 180, height:40)
        
        starRatingView.maximumValue = 5 		//default is 5
        starRatingView.minimumValue = 0 		//default is 0
        starRatingView.value = 3       		//default is 0
        
        starRatingView.tintColor = UIColor.yellow
        
        starRatingView.addTarget(self, action: #selector(ratingChanged), for: .valueChanged)
        
        alert1.view.addSubview(starRatingView)
        
        // Comments
        // Add textfield 1
        let textfield1 = UITextView(frame: CGRect(x: (x-90), y: starRatingView.frame.maxY + 10, width: 210, height: 85))
        textfield1.delegate = self
        textfield1.layer.borderColor = UIColor.lightGray.cgColor
        textfield1.layer.borderWidth = 1
        textfield1.layer.cornerRadius = 1
        textfield1.placeholderText = "Comment..."
        textfield1.text = "Comment..."
        textfield1.textColor = UIColor.lightGray
        textfield1.textAlignment = NSTextAlignment.left
        alert1.view.addSubview(textfield1)

        
        // add the actions (buttons)
        alert1.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: {action in
            print ("Rated")
            KVLoading.show()
            var json: JSON = []
            let parameters: Parameters = [
                "rater": UserDefaults.standard.string(forKey: "UserType"),
                "rater_id" : 1,
                "ratee":UserDefaults.standard.string(forKey: "UserType"),
                "ratee_id": 1,
                "rating": starRatingView.value,
                "comment": textfield1.text
            ]
            
            let headers: HTTPHeaders = [
                "api_token": UserDefaults.standard.string(forKey: "apiToken")!
            ]
            
            let url = "http://thenerdcamp.com/calllight/public/api/v1/profile/ratings?api_token=" + UserDefaults.standard.string(forKey: "apiToken")!
            let completeUrl = URL(string:url)!
            
            Alamofire.request(completeUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers ).responseJSON{ response in
                print(response.request as Any)  // original URL request
                print(response.response as Any) // URL response
                print(response.result.value as Any)   // result of response serialization
                switch response.result {
                case .success:
                                    print(response)
                    if let value = response.result.value {
                        json = JSON(value)
                                            print(json)
                                            print(json[0])
                        KVLoading.hide()
                    }
                    
                    break
                case .failure(let error):
                    print(error)
                    KVLoading.hide()
                }
                
            }
            
        }))
        
        alert1.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        // height
//        let height:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
//        alert.view.addConstraint(height)
        
        // show the alert
        self.present(alert1, animated: true, completion: nil)
    }
    
    // text area
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Comment..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    func ratingChanged() {
        print ("rating changed")
    }
    
    func StartShift() {
//        print ("Start Shift")
        KVLoading.show()
        var json: JSON = []
        var url: String = ""
        if self.startShiftBtn.titleLabel?.text == "Start Shift" {
             url = "http://thenerdcamp.com/calllight/public/api/v1/nurse/shift/started?api_token=" + UserDefaults.standard.string(forKey: "apiToken")!
        } else {
             url = "http://thenerdcamp.com/calllight/public/api/v1/nurse/shift/ended?api_token=" + UserDefaults.standard.string(forKey: "apiToken")!
        }
        
        let completeUrl = URL(string:url)!
        
        let headers: HTTPHeaders = [
            "api_token": UserDefaults.standard.string(forKey: "apiToken")!
        ]
        
        
        // current date
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let result = formatter.string(from: date)
        
//        print (result)
        
        let parameters: Parameters = [
            "shift_started": result,
            "request_id": 1
        ]
        
        Alamofire.request(completeUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers ).responseJSON{ response in
//            print(response.request as Any)  // original URL request
//            print(response.response as Any) // URL response
//            print(response.result.value as Any)   // result of response serialization
            switch response.result {
            case .success:
//                print(response)
                if let value = response.result.value {
                    json = JSON(value)
//                    print(json)
                    if self.startShiftBtn.titleLabel?.text == "Start Shift" {
                        self.startShiftBtn.titleLabel?.text = "End Shift"
                        self.startShiftBtn.tintColor = UIColor.red
                        self.startShiftBtn.setTitle("End Shift", for: .normal)
                        self.label.text = "Your Shift has started"
                        self.image.isHidden = true
                    } else {
                        self.startShiftBtn.isEnabled = false
                        self.startShiftBtn.isHidden = true
                        self.startLunchBreakAction.isHidden = true
                        self.label.text = "Tap to set availability"
                        self.image.isHidden = false
                        self.rating2()
                        Defaults.set(0.0, forKey: "HospitalLat")
                    }
                }
                KVLoading.hide()
                break
            case .failure(let error):
                print(error)
                KVLoading.hide()
            }
            
        }
        
    }
    
    func LunchStart() {
//        print ("Lunch Start")
        KVLoading.show()
        var json: JSON = []
        let url = "http://thenerdcamp.com/calllight/public/api/v1/nurse/shift/lunchBreak?api_token=" + UserDefaults.standard.string(forKey: "apiToken")!
        let completeUrl = URL(string:url)!
        
        let headers: HTTPHeaders = [
            "api_token": UserDefaults.standard.string(forKey: "apiToken")!
        ]
        
        // current date
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let result = formatter.string(from: date)
        
//        print (result)
        
        let parameters: Parameters = [
            "lunch_break": result,
            "request_id": 1
        ]
        
        Alamofire.request(completeUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers ).responseJSON{ response in
//            print(response.request as Any)  // original URL request
//            print(response.response as Any) // URL response
//            print(response.result.value as Any)   // result of response serialization
            switch response.result {
            case .success:
//                print(response)
                if let value = response.result.value {
                    json = JSON(value)
//                    print(json)
                    self.startLunchBreakAction.isEnabled = false
                    self.startLunchBreakAction.isHidden = true
                    self.label.text = "You have availed the break."
                    self.image.isHidden = true
                }
                KVLoading.hide()
                break
            case .failure(let error):
                print(error)
                KVLoading.hide()
            }
            
        }
        
    }
    
    func getLocation() -> CLLocationCoordinate2D {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        let location: CLLocation? = locationManager.location
//        altitude = Int(location?.altitude)
        let coordinate: CLLocationCoordinate2D? = location?.coordinate
        return coordinate!
    }
    
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        print("Hellooooo")
//        print(tabBar.items?.index(of: item))
//        print (item.badgeValue)
        var tabIndex = tabBar.items?.index(of: tabBar.selectedItem!)
//        print (tabIndex)
    }
    

    func availabilityCheck() {
        var json: JSON = []
        let url = "http://thenerdcamp.com/calllight/public/api/v1/profile/nurses?api_token=" + UserDefaults.standard.string(forKey: "apiToken")!
        let completeUrl = URL(string:url)!
        
        let headers: HTTPHeaders = [
            "api_token": UserDefaults.standard.string(forKey: "apiToken")!
        ]
        
        Alamofire.request(completeUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers ).responseJSON{ response in
//            print(response.request as Any)  // original URL request
//            print(response.response as Any) // URL response
//            print(response.result.value as Any)   // result of response serialization
            switch response.result {
            case .success:
//                print(response)
                if let value = response.result.value {
                    json = JSON(value)
//                    print(json)
//                    print(json["data"]["available"])
                    if (json["data"]["available"] == 1) {
                        Defaults[self.available] = 1
                        self.availabilitySet()
                        
                    } else {
                        Defaults[self.available] = 0
                        self.availabilitySet()
                    }
                }
                
                break
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    func availabilitySet() {
        if (Defaults[available] == 1 ) {
            label.text = "Available"
            image.image = UIImage(named: "nurseAccept.png")
        } else if (Defaults[available] == 0) {
            label.text = "Not Available"
            image.image = UIImage(named: "nurseDecline.png")
        } else {
            label.text = "Your Account is Pending Approval"
            image.image = UIImage(named: "nurseDecline.png")
            self.blur.isHidden = false
        }
        KVLoading.hide()
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func availability() {
//        print("hello")
        
        KVLoading.show()
        
        var json: JSON = []
        
        var setAvail = 0
//        print (Defaults[self.available])
        if Defaults[self.available] == 0 {
            setAvail = 1
        } else {
            setAvail = 0
        }
        
        let parameters: Parameters = [
            "available": setAvail
        ]
        
        let headers: HTTPHeaders = [
            "api_token": "aySlC26ZTHtlnS0lhUpdghxkd9gKJBLXLYFUO2Jidmiisoka9iFIicwRIZFx"
        ]
        
        let url = "http://thenerdcamp.com/calllight/public/api/v1/nurse/available?api_token=" + UserDefaults.standard.string(forKey: "apiToken")!
        let completeUrl = URL(string:url)!
        
        Alamofire.request(completeUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers ).responseJSON{ response in
//            print(response.request as Any)  // original URL request
//            print(response.response as Any) // URL response
//            print(response.result.value as Any)   // result of response serialization
            switch response.result {
            case .success:
//                print(response)
                if let value = response.result.value {
                    json = JSON(value)
//                    print(json)
//                    print(json["data"]["available"])
                    if (json["data"]["available"] == 1) {
                        Defaults[self.available] = 1
//                        print (Defaults[self.available])
                        self.availabilitySet()
                    } else {
                        Defaults[self.available] = 0
//                        print (Defaults[self.available])
                        self.availabilitySet()
                    }
                }
                
                break
            case .failure(let error):
                print(error)
            }
            
        }
        
        
        
    }
    
    @IBAction func startShiftActoin(_ sender: Any) {
        self.StartShift()
    }
    
    @IBAction func lunchBreakActoin(_ sender: Any) {
        self.LunchStart()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
