//
//  loginEmail.swift
//  FirebaseSocialLogin
//
//  Created by Syed Askari on 10/03/2017.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit
import Alamofire
import Foundation
import SwiftyJSON
import SwiftyUserDefaults
import KVLoading

class loginEmail: UIViewController {
    @IBOutlet weak var signIn: UIButton!
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var token = UserDefaults.standard
    var profileComplete = UserDefaults.standard
    var profileVerified = UserDefaults.standard
    var userType = UserDefaults.standard
    var userID = UserDefaults.standard
    var json: JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInAction(_ sender: Any) {
        KVLoading.show()
        print ("device token is",UserDefaults.standard.string(forKey: "deviceToken")!)
        var deviceToken: String
        if UserDefaults.standard.string(forKey: "deviceToken")! == "0" {
            deviceToken = "-1"
        } else {
            deviceToken = UserDefaults.standard.string(forKey: "deviceToken")!
//            deviceToken = "-1"
        }
        if email.text != "" && password.text != "" {
            let parameters: Parameters = [
                "email": email.text! ,
                "password": password.text! ,
                "device_token": deviceToken
            ]
            
            print(parameters)
            
            Alamofire.request("http://thenerdcamp.com/calllight/public/api/v1/user/login", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil ).responseJSON{ response in
                print(response.request as Any)  // original URL request
                print(response.response as Any) // URL response
                print(response.result.value as Any)   // result of response serialization
                KVLoading.hide()
                switch response.result {
                case .success:
                    print(response)
                    if let value = response.result.value {
                        self.json = JSON(value)
                        print(self.json)
                        print( self.json["success"])
                        if self.json["success"] != false {
                            var tok = String(describing: self.json["data"]["api_token"])
                            print(tok)
                            self.token.set(tok, forKey: "apiToken")
                            Defaults.set(tok, forKey: "apiToken")
                            var userID = String(describing: self.json["data"]["id"])
                            print(userID)
                            self.token.set(userID, forKey: "userID")
                            Defaults.set(userID, forKey: "userID")
                            
        //                    var def = Defaults[.api_token].string
                            print (Defaults.value(forKey: "apiToken"))
                            
                            self.userType.set(self.json["data"]["type"].string, forKey: "UserType")
                            Defaults.set(self.json["data"]["type"].string, forKey: "UserType")
                            
                            print (Defaults.value(forKey: "UserType"))
                            
                            if self.json["data"]["is_verified"].bool == true {
                                self.profileComplete.set(true, forKey: "profileVerified")
                                Defaults.set(true, forKey: "profileVerified")
                            } else {
                                self.profileComplete.set(false, forKey: "profileVerified")
                                Defaults.set(false, forKey: "profileVerified")
                            }
                            
                            if self.json["data"]["profile_completed"].bool == true {
                                self.profileComplete.set(true, forKey: "profileComplete")
                                Defaults.set(true, forKey: "profileComplete")
                                
                                print (self.json["data"]["type"].string)
                                if self.json["data"]["type"].string == "Nurse" {
                                    self.performSegue(withIdentifier: "NurseCompSegue", sender: self)
                                } else {
                                    self.performSegue(withIdentifier: "HopitalCompSegue", sender: self)
                                }
                                
                            } else {
                                self.profileComplete.set(false, forKey: "profileComplete")
                                Defaults.set(false, forKey: "profileComplete")
                                self.performSegue(withIdentifier: "NurseCompSegue", sender: self)
                            }
                            
                        } else {
                            // create the alert
                            let alert = UIAlertController(title: "Response", message: self.json["message"].string, preferredStyle: UIAlertControllerStyle.alert)
                            
                            
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                            
                            // show the alert
                            self.present(alert, animated: true, completion: nil)

                        }
                    }
                    
                    break
                case .failure(let error):
                    
                    print(error)
                }

            }
        }
    }

    // For keyboard
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
