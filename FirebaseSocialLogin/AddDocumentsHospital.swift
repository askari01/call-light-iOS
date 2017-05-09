//
//  AddDocumentsHospital.swift
//  FirebaseSocialLogin
//
//  Created by Syed Askari on 22/03/2017.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftyUserDefaults
import KVLoading

class AddDocumentsHospital: UITableViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UINavigationControllerDelegate {

    var row = 0
    var json: JSON = []
    let picker = UIImagePickerController()
    var docName: String = ""
    var chosenImage = UIImage()
    
    @IBOutlet var documentsTableView: UITableView!
    @IBOutlet weak var done: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        KVLoading.show()
        self.getAllDocs()
        self.refreshControl?.addTarget(self, action: #selector(self.getAllDocs), for: UIControlEvents.valueChanged)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        picker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "profileComplete") == true {
            self.done.isEnabled = false
        } else {
            self.done.isEnabled = true
        }
        self.getAllDocs()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.row
    }

    @IBAction func addDocument(_ sender: Any) {
        self.DocName()
    }
    
    // GET uploaded files from server
    
    func getAllDocs() {
        
        KVLoading.show()
        
        let url = "http://thenerdcamp.com/calllight/public/api/v1/nurse/documents?api_token=" + UserDefaults.standard.string(forKey: "apiToken")!
        let completeUrl = URL(string:url)!
        
        let headers: HTTPHeaders = [
            "api_token": UserDefaults.standard.string(forKey: "apiToken")!
        ]
        if json != nil {
            Alamofire.request(completeUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers ).responseJSON{ response in
                print(response.request as Any)  // original URL request
                print(response.response as Any) // URL response
                print(response.result.value as Any)   // result of response serialization
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        self.json = JSON(value)
                        print(self.json)
                        self.row = self.json["data"].count
                        print(self.row)
                        //print(self.json[0]["facilityPictures"])
                        KVLoading.hide()
                        self.documentsTableView.reloadData()
                    }
                    break
                case .failure(let error):
                    print(error)
                }
                
            }
        } else {
            self.row = self.json["data"].count
        }
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentsCell", for: indexPath)
        
        // Configure the cell...
        print(self.json["data"][indexPath.row]["id"])
        cell.textLabel?.text = String(describing: self.json["data"][indexPath.row]["name"])

        return cell
    }
 
    // Edit mode
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        documentsTableView.setEditing(editing, animated: true)
    }
    
    // Delete the cell
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
//            todos.remove(at: indexPath.row)
//            self.json.dictionaryObject?.removeValue(forKey: indexPath.row)
           self.json["data"].arrayObject?.remove(at: indexPath.row)
            print(self.json)
            self.documentsTableView.reloadData()
//            documentsTableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // For Image
    
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
        print("hello pick Image")
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    func takeImage() {
        print("hello take Image")
        picker.allowsEditing = true
        picker.sourceType = .camera
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [AnyHashable: Any]) {
        
        self.chosenImage = (info[UIImagePickerControllerEditedImage] as! UIImage?)!
//        profileImage.image = chosenImage
        
        
        
        
        picker.dismiss(animated: true, completion: { _ in
//            self.DocName()
            KVLoading.show()
            self.uploadDocs()
        })
        
    }
    
    func uploadDocs() {
        KVLoading.show()
        if self.docName != "" {
            
            var parameters = [String: String]()
            
            parameters = [
                "name": self.docName
            ]
            
            let headers: HTTPHeaders = [
                "Accept": "application/json"
            ]
            
            let url = "http://thenerdcamp.com/calllight/public/api/v1/nurse/documents?api_token=" + UserDefaults.standard.string(forKey: "apiToken")!
            let completeUrl = URL(string:url)!
            
            let imageData = UIImageJPEGRepresentation(self.chosenImage, 1)
            print ("image data:: \(imageData)")
            print ("chosenImage:: \(self.chosenImage)")
            
            
            Alamofire.upload(
                multipartFormData: {
                    multipartFormData in
                    multipartFormData.append(imageData!,
                                             withName: "document",
                                             fileName: "image.jpg",
                                             mimeType: "image/jpeg")
                    for (key, value) in parameters {
                        multipartFormData.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                    }
            },
                to: completeUrl,
                headers: headers,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON{ response in
                            print(response)
                            self.getAllDocs()
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                    }
            }
            )
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: { _ in })
    }

    // Document name
    
    func DocName() {
        print("DOC NAME")
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Selected Doc", message: "Enter Name of the document", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Name of the Doc"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField?.text)")
            self.docName = textField?.text! as! String
            self.pickImageOptions()
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
}
