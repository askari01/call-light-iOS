//
//  ForgotPassword.swift
//  FirebaseSocialLogin
//
//  Created by Syed Askari on 13/03/2017.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftyUserDefaults

class ForgotPassword: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    var json: JSON = []
    
    
    @IBAction func ResetPasswordAction(_ sender: Any) {
        Defaults.set(self.emailTextField.text, forKey: "Email")
        
        let parameters: Parameters = [
            "email": self.emailTextField.text
        ]
        
        if self.emailTextField.text != "" {
            Alamofire.request("http://thenerdcamp.com/calllight/public/api/v1/user/forgot-password", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil ).responseJSON{ response in
                print(response.request as Any)  // original URL request
                print(response.response as Any) // URL response
                print(response.result.value as Any)   // result of response serialization
                switch response.result {
                case .success:
                    print(response)
                    if let value = response.result.value {
                        self.json = JSON(value)
                        print(self.json)
                        print(self.json[0])
                    }
                    
                    break
                case .failure(let error):
                    print(error)
                }
                
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
