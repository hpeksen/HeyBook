//
//  NewPasswordViewController.swift
//  HeyBook
//
//  Created by Admin on 13/03/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit
import Alamofire
import SearchTextField

class NewPasswordViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var myTextField: SearchTextField!
    var newPasswordResponse = ""
    var message = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        myTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
              // Do any additional setup after loading the view.
        // autocomplete: https://github.com/apasccon/SearchTextField
        myTextField.inlineMode = true
        let array:[String] = UserDefaults.standard.stringArray(forKey: "user_mail_autocomplete_array") == nil ? [] : UserDefaults.standard.stringArray(forKey: "user_mail_autocomplete_array")!
        myTextField.filterStrings(array)

    }

    //keyboard için
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.view.endEditing(true)
//        return false
//    }
    
    func keyboardWillShow(notification: NSNotification) {
        var translation:CGFloat = 0
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if myTextField.isEditing{
                translation = CGFloat(-keyboardSize.height)
            }else if myTextField.isEditing{
                translation = CGFloat(-keyboardSize.height / 3.8)
            }
        }
        UIView.animate(withDuration: 0.2) {
            self.view.transform = CGAffineTransform(translationX: 0, y: translation)
        }
        
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.2) {
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
        } 
    }
    // Clicking the view (the container for UI components) removes the Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
//keyboard için
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func newPasswordBtn(_ sender: Any) {
        let urlString = "http://heybook.online/api.php"
        let parameters = ["request": "forgot",
                          "mail": "\(myTextField.text!)"]
        
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                
                
                let json = JSON(data: response.data!)
                print(json)
                self.newPasswordResponse = json["response"].string!
                self.message = json["message"].description
                print(self.message)
                print(self.newPasswordResponse)
                
                let longPressAlert = UIAlertController(title: "\(json["response"].description)", message: "\(json["message"].description)", preferredStyle: UIAlertControllerStyle.alert)
                longPressAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
                self.present(longPressAlert, animated: true, completion: nil)
                
                
                
                
                break
            case .failure(let error):
                
                print(error)
            }
        }
        
       
   
        
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
  
    
//    // Delegate to remove the keyboard (When the return key is pressed the keyboard will disappear)
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        
//        return true
//    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
