//
//  SIgnUpEmail.swift
//  FirebaseSocialLogin
//
//  Created by Syed Askari on 10/03/2017.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftyUserDefaults
import KVLoading

class SignUpEmail: UIViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var authPersonalName: UITextField!
    @IBOutlet weak var manualAddress: UITextField!
    
    let picker = UIImagePickerController()
    var json: JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 8
        signUp.layer.cornerRadius = 8
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(pickImageOptions))
        tap.numberOfTapsRequired = 1
        tap.delegate = self
        profileImage.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
        picker.delegate = self
        
//        print ("PROFILE USER TYPE: ", Defaults.value(forKey: "UserType"))
        if UserDefaults.standard.string(forKey: "UserType") == "Hospital" {
            self.authPersonalName.isHidden = false
            self.name.placeholder = "Hospital"
        } else {
            self.authPersonalName.isHidden = true
            self.name.placeholder = "Name"
        }
    }
    
    func pickImageOptions() {
        // create the alert
        let alert = UIAlertController(title: "Profile Image", message: "Set your profile Image", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Select from Gallery", style: UIAlertActionStyle.default, handler: {action in
            self.pickImage()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.default, handler: { action in
            self.takeImage()
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func pickImage() {
//        print("hello pick Image")
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    func takeImage() {
//        print("hello take Image")
        picker.allowsEditing = true
        picker.sourceType = .camera
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SignUp(_ sender: Any) {
        KVLoading.show()
        if manualAddress.text == nil {
            return
        }
        if name.text == nil {
            return
        }
        if email.text == nil {
            return
        }
        if password.text == nil {
            return
        }
        if password.text != confirmPassword.text {
            return
        }
        if phoneNumber.text == nil {
            return
        }
//        print("hello sexy")
        var deviceToken: String?
//        #if (arch(i386) || arch(x86_64)) && os(iOS)
//            print("It's an iOS Simulator")
//        if UserDefaults.standard.string(forKey: "deviceToken") == nil {
//            deviceToken = "-1"
//            }
//        #else
//                deviceToken = UserDefaults.standard.string(forKey: "deviceToken")!
//        #endif
        UserDefaults.standard.set("\(manualAddress.text!)", forKey: "address")
        
        if UserDefaults.standard.string(forKey: "deviceToken")! == nil {
            deviceToken = "-1"
        } else {
            deviceToken = UserDefaults.standard.string(forKey: "deviceToken")!
        }
    
        let parameters: Parameters!
        if UserDefaults.standard.string(forKey: "UserType") == "Hospital" {
            parameters = [
            "hospital_name": authPersonalName.text,
            "name": name.text,
            "email": email.text,
            "phone": phoneNumber.text,
            "password": password.text,
            "type": String(describing: UserDefaults.standard.string(forKey: "UserType")!),
            "device_token": deviceToken
            ]
        } else {
            parameters = [
                "name": name.text,
                "email": email.text,
                "phone": phoneNumber.text,
                "password": password.text,
                "type": String(describing: UserDefaults.standard.string(forKey: "UserType")!),
                "hospital_name": authPersonalName.text,
                "device_token": deviceToken
            ]
        }
        print(parameters)
        
        Alamofire.request("http://thenerdcamp.com/calllight/public/api/v1/user/register", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil ).responseJSON{ response in
//            print(response.request as Any)  // original URL request
//            print(response.response as Any) // URL response
//            print(response.result.value as Any)   // result of response serialization
            KVLoading.hide()
            
            switch response.result {
            case .success:
//                print(response)
                if let value = response.result.value {
                    self.json = JSON(value)
//                    print(self.json)
//                    print( self.json["success"])
                    if self.json["success"] != false {
                        var tok = String(describing: self.json["data"]["api_token"])
//                        print(tok)
//                        self.token.set(tok, forKey: "apiToken")
                        Defaults.set(tok, forKey: "apiToken")
                        
//                        print ("User TYPE:", Defaults.value(forKey: "UserType"))
                        
                    if UserDefaults.standard.string(forKey: "UserType") == "Nurse" {
                        self.performSegue(withIdentifier: "SignUpNurseSegue", sender: self)
                    } else {
                        self.performSegue(withIdentifier: "SignUpHospitalSegue", sender: self)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [AnyHashable: Any]) {
        let chosenImage: UIImage? = info[UIImagePickerControllerEditedImage] as! UIImage?
        profileImage.image = chosenImage
        
        
        var parameters = [String: String]()
        parameters = [
            "profile_image": "imagefile"
        ]

        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        let url = "http://thenerdcamp.com/calllight/public/api/v1/profile/update-picture?api_token=" + UserDefaults.standard.string(forKey: "apiToken")!
        let completeUrl = URL(string:url)!
        
        let imageData = UIImageJPEGRepresentation(chosenImage!, 1)
//        print ("image data:: \(imageData)")
//        print ("chosenImage:: \(chosenImage)")
        
//        Alamofire.upload(imageData!, to: completeUrl).response { response in
//            print (response)
//        }
        
        Alamofire.upload(
            multipartFormData: { 
                multipartFormData in
                multipartFormData.append(imageData!,
                                         withName: "profile_image",
                                         fileName: "image.jpg",
                                         mimeType: "image/jpeg")
//                for (key, value) in parameters {
//                    multipartFormData.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
//                }
        },
            to: completeUrl,
            headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON{ response in
//                        print(response)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
        )
        
        picker.dismiss(animated: true, completion: { _ in })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: { _ in })
    }

}
