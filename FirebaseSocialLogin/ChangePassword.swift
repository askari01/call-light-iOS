//
//  ChangePassword.swift
//  FirebaseSocialLogin
//
//  Created by Syed Askari on 13/03/2017.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftyUserDefaults

class ChangePassword: UIViewController {

    @IBOutlet weak var enterPassTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
    
    
    @IBAction func changePassAction(_ sender: Any) {
        if (enterPassTextField.text == confirmPassTextField.text){
            var json: JSON = []
            let parameters: Parameters = [
                "password": enterPassTextField.text,
                "password_confirmation" : confirmPassTextField.text
            ]
            
            let headers: HTTPHeaders = [
                "api_token": UserDefaults.standard.string(forKey: "apiToken")!
            ]
            
            let url = "http://staging.techeasesol.com/calllight/public/api/v1/user/change-password?api_token=" + UserDefaults.standard.string(forKey: "apiToken")!
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
