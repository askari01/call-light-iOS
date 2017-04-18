//
//  ViewController.swift
//  FirebaseSocialLogin
//
//  Created by Brian Voong on 10/21/16.
//  Copyright © 2016 Lets Build That App. All rights reserved.
//

import Alamofire
import UIKit
import Fabric
import FBSDKLoginKit
import Firebase
import GoogleSignIn
import TwitterKit
import SwiftyUserDefaults
import SwiftyJSON
import KVLoading

class ViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate, GIDSignInDelegate {

    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var googlePlusButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var userType: UISegmentedControl!
    
    var email = "", id = "", name = "", provider = "", userTypeDefault = "Nurse"
//    var userTypeDefault = UserDefaults.standard
    
    override func viewDidAppear(_ animated: Bool) {
        GIDSignIn.sharedInstance().uiDelegate = self
        
        
        print (UserDefaults.standard.string(forKey: "profileComplete"))
        
        if UserDefaults.standard.string(forKey: "apiToken") != nil {
            if UserDefaults.standard.string(forKey: "UserType") == "Nurse" {
                if UserDefaults.standard.string(forKey: "profileComplete") == "1" {
                    self.performSegue(withIdentifier: "SignInNurseSegue", sender: self)
                } else {
                    self.performSegue(withIdentifier: "NurseSegue", sender: self)
                }
            } else if UserDefaults.standard.string(forKey: "UserType") == "Hospital" {
                print (UserDefaults.standard.string(forKey: "profileComplete"))
                if UserDefaults.standard.string(forKey: "profileComplete") == "1" {
                    self.performSegue(withIdentifier: "HopitalCompSegue", sender: self)
                } else {
                    self.performSegue(withIdentifier: "HospIncomSegue", sender: self)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Fabric.with([Twitter.self])
        GIDSignIn.sharedInstance().delegate = self
        
//        Alamofire.request("https://restcountries.eu/rest/v2/all").responseJSON { response in
//            print(response.request)  // original URL request
//            print(response.response) // HTTP URL response
//            print(response.data)     // server data
//            print(response.result)   // result of response serialization
//            
//            if let JSON = response.result.value {
//                print("JSON: \(JSON)")
//            }
//        }
        
        
//        if (FBSDKAccessToken.current() != nil){
//            print ("i am in if")
//        } else {
//            print("i am in else")
//            let facebookButton = FBSDKLoginButton()
//            view.addSubview(facebookButton)
//            //frame's are obselete, please use constraints instead because its 2016 after all
//            facebookButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
//            facebookButton.readPermissions = ["public_profile", "email", "user_friends"]
//            facebookButton.delegate = self
//        }
        
        // Google Button
        
//        let googleButton = GIDSignInButton()
//        googleButton.frame = CGRect(x: 16, y: 50 + 66, width: view.frame.width - 32, height: 50)
//        view.addSubview(googleButton)
//        GIDSignIn.sharedInstance().uiDelegate = self
        
        // twitter Button
//        let logInButton = TWTRLogInButton { (session, error) in
//            if let unwrappedSession = session {
//                let alert = UIAlertController(title: "Logged In",
//                                              message: "User \(unwrappedSession.userName) has logged in",
//                    preferredStyle: UIAlertControllerStyle.alert
//                )
//                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//            } else {
//                NSLog("Login error: %@", error!.localizedDescription);
//            }
//        }
//        
//        // TODO: Change where the log in button is positioned in your view
//            logInButton.center = self.view.center
//            self.view.addSubview(logInButton)
       
        
    }
    
    @IBAction func UserTypeSet(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.userTypeDefault = "Nurse"
            Defaults["UserType"] = self.userTypeDefault
            self.facebookButton.isHidden = false
            self.googlePlusButton.isHidden = false
            self.twitterButton.isHidden = false
        } else {
            self.userTypeDefault = "Hospital"
            Defaults["UserType"] = self.userTypeDefault
            self.facebookButton.isHidden = true
            self.googlePlusButton.isHidden = true
            self.twitterButton.isHidden = true
        }
    }
    
    @IBAction func facebookBtuttonAction(_ sender: Any) {
//        KVLoading.show()
    
        FBSDKLoginManager().logIn(withReadPermissions: ["email"], from: self) { (result, err) in
            if err != nil {
                print("Custom FB Login failed:", err as Any)
                return
            }  else  {
                KVLoading.show()
                self.showEmailAddress()
            }
            if (result?.isCancelled)! {
                KVLoading.hide()
            }
            if ((result?.declinedPermissions) != nil) {
                KVLoading.hide()
            }
            if ((result?.grantedPermissions) != nil) {
                KVLoading.show()
            }
        }
        KVLoading.show()
    }
    
    @IBAction func twitterButtonAction(_ sender: Any) {
        Twitter.sharedInstance().logIn {
            (session, error) -> Void in
            if (session != nil) {
                print("signed in as \(session?.userName)")
                print("signed in as \(session?.userID)")
                print("signed in as \(session?.authToken)")
                print()
            } else {
                print("error: \(error?.localizedDescription)")
            }
        }
    }
    
    @IBAction func googlePlusButtonAction(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
//        KVLoading.show()
    }
    
    func signIn(signIn: GIDSignIn!,
                presentViewController viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func signIn(signIn: GIDSignIn!,
                dismissViewController viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
        KVLoading.show()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // ...
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print(123)
        if let err = error {
            print("error in google plus sign up",err)
        } else {
            
            //            print ("successfuly log in ", user)
            print ("User ID ", user.userID)
            //            print ("Profile ",user.profile)
            //            print ("Authentication ", user.authentication)
            //            print ("Hosted Domain ", user.hostedDomain)
            print ("profile Name ",user.profile.name)
            //            print ("Given Name",user.profile.givenName)
            print ("email ",user.profile.email)
            
            self.email = user.profile.email
            self.id = user.userID
            self.name = user.profile.name
            self.provider = "Google"
            self.saveSocialResponse()
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        showEmailAddress ()
    }
    
    func showEmailAddress() {
        KVLoading.show()
        print("hello i am")
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
            
            if err != nil {
                print("Failed to start graph request:", err ?? "")
                return
            }
            print(result ?? "")
            var json: JSON = []
            if let theJSONData: Data = try? JSONSerialization.data(
                withJSONObject: result,
                options: [JSONSerialization.WritingOptions.prettyPrinted]) {
                print (JSON(theJSONData))
                json = JSON(theJSONData)
                print (json["id"])
                self.email = json["email"].string!
                self.id = json["id"].string!
                self.name = json["name"].string!
                self.provider = "Facebook"
                self.saveSocialResponse()
            }
        }
    }
    
    func saveSocialResponse() {
        // saving data
        var json: JSON = []
        var parameters: Parameters = [:]
        
        var deviceToken: String
        if UserDefaults.standard.string(forKey: "deviceToken") == "0" {
            deviceToken = "-1"
        } else {
            deviceToken = UserDefaults.standard.string(forKey: "deviceToken")!
        }
        
            parameters = [
                "provider_id" : self.id,
                "provider" : self.provider,
                "name" : self.name,
                "email" : self.email,
                "device_token": deviceToken
            ]
      
        
    
        
        let url = "http://staging.techeasesol.com/calllight/public/api/v1/user/social-login"
        let completeUrl = URL(string:url)!
        
        Alamofire.request(completeUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil ).responseJSON{ response in
            print(response.request as Any)  // original URL request
            print(response.response as Any) // URL response
            print(response.result.value as Any)   // result of response serialization
            switch response.result {
            case .success:
                print(response)
                if let value = response.result.value {
                    json = JSON(value)
                    print(json)
                }
                Defaults["UserType"] = self.userTypeDefault
                Defaults["Token"] = json["data"]["api_token"].string
                UserDefaults.standard.set(json["data"]["api_token"].string, forKey: "apiToken")
                UserDefaults.standard.set(json["data"]["id"].string, forKey: "userID")
                print(self.userTypeDefault)
                print(json["data"]["api_token"].string)
                UserDefaults.standard.set(String(self.userTypeDefault), forKey: "UserType")
                
                if json["data"]["profile_completed"].bool == true {
                   UserDefaults.standard.set(true, forKey: "profileComplete")
                    Defaults.set(true, forKey: "profileComplete")
                } else {
                    UserDefaults.standard.set(false, forKey: "profileComplete")
                    Defaults.set(false, forKey: "profileComplete")
                }
                
                if (UserDefaults.standard.string(forKey: "UserType") == "Nurse"){
                    print ("Nurse")
                    if json["data"]["is_accepted"] != nil {
                        self.performSegue(withIdentifier: "SignInNurseSegue", sender: self)
                    } else {
                        self.performSegue(withIdentifier: "NurseSegue", sender: self)
                    }
                } else if UserDefaults.standard.string(forKey: "UserType") == "Hospital" {
                    if json["data"]["is_accepted"] != nil {
                        self.performSegue(withIdentifier: "HopitalCompSegue", sender: self)
                    } else {
                        self.performSegue(withIdentifier: "HopitalIncompSegue", sender: self)
                    }
                }
                break
            case .failure(let error):
                print(error)
                KVLoading.hide()
                break
            }
            
        }
    }
    
    func Delegate() {
        KVLoading.hide()
        if (UserDefaults.standard.string(forKey: "UserType") == "Nurse"){
            print ("Nurse")
            performSegue(withIdentifier: "NurseSegue", sender: self)
        } else {
            print ("Hospital")
            performSegue(withIdentifier: "HospIncomSegue", sender: self)
        }
    }
}

