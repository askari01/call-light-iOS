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

class HospitalProfile: UIViewController {
    
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var acceptbtn: UIButton!
    @IBOutlet weak var declineBtn: UIButton!
    @IBOutlet weak var hospitalImage: UIImageView!
    
    var latitude: Double!
    var longitude: Double!
    var name: String!
    var shiftStartTime: String!
    var shiftEndTime: String!
    var shiftDate: String!
//    var avatarUrl: String!
    
    @IBOutlet weak var hospitalLbl: UILabel!
    
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
        var json: JSON = []
        let parameters: Parameters = [
            "request_id": 110,
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
    
    
    @IBAction func acceptAction(_ sender: Any) {
        KVLoading.show()
        var json: JSON = []
        let parameters: Parameters = [
            "request_id": 110,
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
//        print("response @% @% @% @%",shiftDate, shiftEndTime, shiftEndTime, latitude, longitude)
        
        if String(describing: Defaults.value(forKey: "UserType")) == "Nurse" {
            logoutBtn.isHidden = true
            logoutBtn.isEnabled = false
        } else {
            acceptbtn.isEnabled = false
            acceptbtn.isHidden = true
            declineBtn.isHidden = true
            declineBtn.isEnabled = false
        }
        
        self.hospitalImage.layer.cornerRadius = self.hospitalImage.frame.size.width/2
        self.hospitalImage.clipsToBounds = true
        
        if name != "" {
            hospitalLbl.text = name
        }
        
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
