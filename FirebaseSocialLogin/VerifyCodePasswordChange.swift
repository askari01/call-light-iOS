//
//  VerifyCodePasswordChange.swift
//  FirebaseSocialLogin
//
//  Created by Syed Askari on 13/03/2017.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftyUserDefaults

class VerifyCodePasswordChange: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var verifyCodeTextField: UITextField!
    
    @IBAction func VerifyCodeAction(_ sender: Any) {
        if (self.verifyCodeTextField.text?.characters.count == 7) {
            var json: JSON = []
            let parameters: Parameters = [
                "email": UserDefaults.standard.string(forKey: "Email"),
                "verification_code": self.verifyCodeTextField.text
            ]
            Alamofire.request("http://thenerdcamp.com/calllight/public/api/v1/user/verify", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil ).responseJSON{ response in
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
                        Defaults.set(json["message"]["api_token"].string, forKey: "apiToken")
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
        verifyCodeTextField.delegate = self
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
