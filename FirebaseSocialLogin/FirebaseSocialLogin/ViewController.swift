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

class ViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {

    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var googlePlusButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
              Fabric.with([Twitter.self])
        
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
    
    @IBAction func facebookBtuttonAction(_ sender: Any) {
        FBSDKLoginManager().logIn(withReadPermissions: ["email"], from: self) { (result, err) in
            if err != nil {
                print("Custom FB Login failed:", err as Any)
                return
            }
            
            self.showEmailAddress()
        }
    }
    
    @IBAction func twitterButtonAction(_ sender: Any) {
        Twitter.sharedInstance().logIn {
            (session, error) -> Void in
            if (session != nil) {
                print("signed in as \(session?.userName)");
            } else {
                print("error: \(error?.localizedDescription)");
            }
        }
    }
    
    @IBAction func googlePlusButtonAction(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func signIn(signIn: GIDSignIn!,
                presentViewController viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func signIn(signIn: GIDSignIn!,
                dismissViewController viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
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
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
        showEmailAddress ()
    }
    
    func showEmailAddress() {
        print("hello i am")
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
            
            if err != nil {
                print("Failed to start graph request:", err ?? "")
                return
            }
            print(result ?? "")
        }
    }
}

