//
//  RegisterViewController.swift
//  HeyBook
//
//  Created by Admin on 06/02/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var mailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmField: UITextField!

    var registerResponse = ""
    @IBAction func register(_ sender: Any) {
        
        self.nameField.resignFirstResponder()
        self.mailField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
        self.passwordConfirmField.resignFirstResponder()
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        
       // print(nameField.text ?? "")
       // print(mailField.text ?? "")
       // print(passwordField.text ?? "")
        //print(isValidEmail(testStr: mailField.text!))
        
        if((nameField.text?.isEmpty)! || (mailField.text?.isEmpty)! || (passwordField.text?.isEmpty)! || (passwordConfirmField.text?.isEmpty)!) {
            let longPressAlert = UIAlertController(title: "Hata", message: "Lütfen bütün alanları doldurunuz", preferredStyle: UIAlertControllerStyle.alert)
            longPressAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
            self.present(longPressAlert, animated: true, completion: nil)
            
            
        }
        else if (isValidEmail(testStr: mailField.text!) == false){
            let longPressAlert = UIAlertController(title: "Hata", message: "Lütfen uygun bir mail adresi giriniz(Örnek: heybook@online.com)", preferredStyle: UIAlertControllerStyle.alert)
            longPressAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
            self.present(longPressAlert, animated: true, completion: nil)
            
        
        }
        else if (passwordField.text! != passwordConfirmField.text! ){
            let longPressAlert = UIAlertController(title: "Hata", message: "Lütfen parola alanlarına aynı parola giriniz", preferredStyle: UIAlertControllerStyle.alert)
            longPressAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
            self.present(longPressAlert, animated: true, completion: nil)
            
            
        }
        else {
            
            
            if let mURL = URL(string: "http://heybook.online/api.php?request=register&user_title=\(nameField.text!)&mail=\(mailField.text!)&password=\(passwordField.text!)") { //http://heybook.online/api.php?request=books
                if let data = try? Data(contentsOf: mURL) {
                    let json = JSON(data: data)
                    print(json)
                    registerResponse = json["response"].string!
                    let total = json["data"].count
                    print(total)
                    print(registerResponse)
                    
                    
                }
            }
            
            
            if(registerResponse == "error"){
            
                let longPressAlert = UIAlertController(title: "Hata", message: "Bu e-mail adresi kullanılıyor. Lütfen başka bir e-mail adresi giriniz!", preferredStyle: UIAlertControllerStyle.alert)
                longPressAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
                self.present(longPressAlert, animated: true, completion: nil)
                
            
            
            }
            
            if(registerResponse == "success"){
            
            self.performSegue(withIdentifier: "goToLogin", sender: self)
            
            }
            
//            let myUrl = NSURL(string: "http://heybook.online/api.php?request=register&user_title=\(nameField.text!)&mail=\(mailField.text!)&password=\(passwordField.text!)");
//            let request = NSMutableURLRequest(url:myUrl! as URL);
//            request.httpMethod = "GET"
//            // Compose a query string
//            let postString = "request=register&user_title=\(nameField.text!)&mail=\(mailField.text!)&password=\(passwordField.text!)";
//            request.httpBody = postString.data(using: String.Encoding.utf8);
//        
//            let task = URLSession.shared.dataTask(with: request as URLRequest) {
//                data, response, error in
//                
//                if error != nil
//                {
//                    print("error=\(error)")
//                    return
//                }
//                
//                // You can print out response object
//                print("response = \(response)")
//                
//                // Print out response body
//                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//                print("responseString = \(responseString)")
//                
//                //Let’s convert response sent from a server side script to a NSDictionary object:
//                
//                do{
//                    
//                    let myJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? NSDictionary
//                    
//                    if let parseJSON = myJSON {
//                        // Now we can access value of First Name by its key
//                        let firstNameValue = parseJSON["password"] as? String
//                        print("firstNameValue: \(firstNameValue)")
//                    }
//                    
//                    
//                }catch let error as NSError {
//                    print("JSON Error: \(error.localizedDescription)")
//                }
//                
//                
//                
//            }
//            
//            task.resume()
            
//            //bütün kullanıcıları yazdır
//            if let rURL = URL(string: "http://heybook.online/api.php?request=users") { //http://heybook.online/api.php?request=books
//                if let data = try? Data(contentsOf: rURL) {
//                    let json = JSON(data: data)
//                    print(json)
//                    print("ekledi..")
//                    
//                    
//                }
//            }
            
            
        }
        

    }
  
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//        
        
//        //bütün kullanıcıları yazdır
//         if let rURL = URL(string: "http://heybook.online/api.php?request=users") { //http://heybook.online/api.php?request=books
//        if let data = try? Data(contentsOf: rURL) {
//            let json = JSON(data: data)
//            print(json)
//            print("ekleyecek")
//        
//        
//        }
//        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
//    func keyboardWillShow(notification: NSNotification) {
//        
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0{
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
//        
//    }
//    
//    func keyboardWillHide(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y != 0{
//                self.view.frame.origin.y += keyboardSize.height
//            }
//        }
//    }
//    
//    
    
    // Clicking the view (the container for UI components) removes the Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    
    // Delegate to remove the keyboard (When the return key is pressed the keyboard will disappear)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
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
