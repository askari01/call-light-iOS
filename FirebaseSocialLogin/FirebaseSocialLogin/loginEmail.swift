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

class loginEmail: UIViewController {
    @IBOutlet weak var signIn: UIButton!
    var token = UserDefaults.standard
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
        let parameters: Parameters = [
            "email": "abc@abc.com",
            "password": "abc123"
        ]
        
        print(parameters)
        
        Alamofire.request("http://staging.techeasesol.com/calllight/public/api/v1/user/login", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil ).responseJSON{ response in
            print(response.request as Any)  // original URL request
            print(response.response as Any) // URL response
            print(response.result.value as Any)   // result of response serialization
            switch response.result {
            case .success:
                print(response)
                if let value = response.result.value {
                    self.json = JSON(value)
                    print(self.json)
                }
                self.token.set("", forKey: "apiToken")
                break
            case .failure(let error):
                print(error)
            }

        }
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
