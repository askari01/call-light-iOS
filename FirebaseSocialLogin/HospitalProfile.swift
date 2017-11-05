//
//  HospitalProfile.swift
//  FirebaseSocialLogin
//
//  Created by Syed Askari on 12/04/2017.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftyUserDefaults
import KVLoading
import MapKit

class HospitalProfile: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var acceptbtn: UIButton!
    @IBOutlet weak var declineBtn: UIButton!
    @IBOutlet weak var hospitalImage: UIImageView!
    @IBOutlet weak var changePassword: UIButton!
    
    var latitude: Double!
    var longitude: Double!
    var name: String!
    var shiftStartTime: String!
    var shiftEndTime: String!
    var shiftDate: String!
    var requestID: Int!
//    var avatarUrl: String!
    
    @IBOutlet weak var hospitalLbl: UILabel!
    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameC: UILabel!
    
    @IBAction func logOut(_ sender: Any) {
        var a = Logout.logOut()
        if a {
            performSegue(withIdentifier: "logOut", sender: self)
        } else {
            print ("logout issue")
        }
    }

    @IBAction func declineActoin(_ sender: Any) {
        KVLoading.show()
        
        Defaults.set(0.0, forKey: "HospitalLat")
        Defaults.set(0.0, forKey: "HospitalLong")
        
        var json: JSON = []
        let parameters: Parameters = [
            "request_id": requestID,
            "has_declined" : 1
        ]
        
        let headers: HTTPHeaders = [
            "api_token": UserDefaults.standard.string(forKey: "apiToken")!
        ]
        
        let url = "http://thenerdcamp.com/calllight/public/api/v1/nurse/request/decline?api_token=" + UserDefaults.standard.string(forKey: "apiToken")!
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
//                    print(json[0])
                    KVLoading.hide()
                    self.performSegue(withIdentifier: "userMenu", sender: self)
                }
                
                break
            case .failure(let error):
                print(error)
                KVLoading.hide()
                self.performSegue(withIdentifier: "userMenu", sender: self)
            }
            
        }
    }
    
    func addAnnotations() {
        
            let annotation = MKPointAnnotation()
            let annotaoinView = MKAnnotationView()
            var lat = latitude
            var lng = longitude
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lng!)
            mapView.addAnnotation(annotation)
    }
    
    @IBAction func acceptAction(_ sender: Any) {
        KVLoading.show()
        var json: JSON = []
        let parameters: Parameters = [
            "request_id": requestID,
            "has_accepted" : 1
        ]
        
        let headers: HTTPHeaders = [
            "api_token": UserDefaults.standard.string(forKey: "apiToken")!
        ]
        
        let url = "http://thenerdcamp.com/calllight/public/api/v1/nurse/request/accept?api_token=" + UserDefaults.standard.string(forKey: "apiToken")!
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
//                    print(json[0])
                    KVLoading.show()
                    self.performSegue(withIdentifier: "userMenu", sender: self)
                }
                
                break
            case .failure(let error):
                print(error)
                KVLoading.show()
                self.performSegue(withIdentifier: "userMenu", sender: self)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        logoutBtn.layer.cornerRadius = 8
        changePassword.layer.cornerRadius = 8
//        print("response @% @% @% @%",shiftDate, shiftEndTime, shiftEndTime, latitude, longitude)
        
        
        mapView.delegate = self
        
        
        if String(describing: Defaults.value(forKey: "UserType")) == "Nurse" {
            logoutBtn.isHidden = true
            logoutBtn.isEnabled = false
            changePassword.isHidden = true
            changePassword.isEnabled = false
            addAnnotations()
            if name != "" {
                hospitalLbl.text = name
            }
        } else {
            acceptbtn.isEnabled = false
            acceptbtn.isHidden = true
            declineBtn.isHidden = true
            declineBtn.isEnabled = false
            hospitalLbl.text = UserDefaults.standard.string(forKey: "userName")
            numberLbl.text = UserDefaults.standard.string(forKey: "userNumber")
            getData()
        }
        
        self.hospitalImage.layer.cornerRadius = self.hospitalImage.frame.size.width/2
        self.hospitalImage.clipsToBounds = true
        
        
        
//        let url = NSURL(string: avatarUrl)
    }
    
    func phone(phoneNum: String) {
        if let url = URL(string: "tel://\(phoneNum)") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url as URL)
            }
        }
    }
    
    func getData() {
        var json1: JSON = []
        let url = "http://thenerdcamp.com/calllight/public/api/v1/profile/hospitals?api_token=" + UserDefaults.standard.string(forKey: "apiToken")!
        let completeUrl = URL(string:url)!
        print (completeUrl)
        let headers: HTTPHeaders = [
            "api_token": UserDefaults.standard.string(forKey: "apiToken")!,
            "Accept": "application/json"
        ]
        
        Alamofire.request(completeUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers ).responseJSON{ response in
                        print(response.request as Any)  // original URL request
                        print(response.response as Any) // URL response
                        print(response.result.value as Any)   // result of response serialization
            switch response.result {
            case .success:
                                print(response)
                if let value = response.result.value {
                    json1 = JSON(value)
                                        print(json1)
                    //                    print(json["data"]["available"])
                    if (json1["data"]["latitude"] != nil) {
                        self.latitude = json1["data"]["latitude"].double
                        self.longitude = json1["data"]["longitude"].double
                        self.addAnnotations()
                        var address = String("\(json1["data"]["address"]), \(json1["data"]["city"]), \(json1["data"]["zip_code"]), \(json1["data"]["state"]), \(json1["data"]["country"])")
                        print (address)
                        if json1["data"]["country"].string != "empty" {
                            self.addressLbl.text = address
                        }
                        if json1["data"]["hospital_name"].string != nil {
                            self.nameC.text = json1["data"]["hospital_name"].string 
                        }
                    }
                }
                
                break
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    @IBAction func CallAction(_ sender: Any) {
        phone(phoneNum: "03348292768")
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        Alamofire.download("https://httpbin.org/image/png").responseData { response in
//            print (response.result.isSuccess)
//            print (response.response?.statusCode)
//            if let data = response.result.value {
//                let image = UIImage(data: data)
//                self.hospitalImage.image = image
//            }
//        }
        
        if self.shiftDate != nil {
            
            shiftDate = nil
            
            // create the alert
            let alert = UIAlertController(title: "Request", message: "You have a request" , preferredStyle: UIAlertControllerStyle.alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Accept", style: UIAlertActionStyle.default, handler: {action in
                self.acceptAction(self)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { action in
                self.declineActoin(self)
            }))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.shiftDate != nil {
            
            shiftDate = nil
            
            // create the alert
            let alert = UIAlertController(title: "Request", message: "You have a request" , preferredStyle: UIAlertControllerStyle.alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Accept", style: UIAlertActionStyle.default, handler: {action in
                self.acceptAction(self)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { action in
                self.declineActoin(self)
            }))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
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
