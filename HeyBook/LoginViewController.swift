//
//  LoginViewController.swift
//  HeyBook
//
//  Created by Admin on 10/01/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    var password = ""
    var user_id = ""
    var user_title = ""
    var mail = ""
    var subscribe = ""
    var photo = ""
    
    var userEmail = ""
    var userPassword = ""
    
    var desc = ""
    var bookName = ""
    var authorName = ""
    var bookLink = ""
    var bookImage = ""
    
    @IBOutlet weak var myStackView: UIStackView!
   
    var users: [User] = []
    @IBOutlet weak var eMailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    // Do any additional setup after loading the view.
    }
    @IBAction func loginBtn(_ sender: Any) {
        userEmail = eMailTxt.text!
        userPassword = passwordTxt.text!
        self.eMailTxt.resignFirstResponder()
        self.passwordTxt.resignFirstResponder()
        
        if let mURL = URL(string: "http://heybook.online/api.php?request=users") { //http://heybook.online/api.php?request=books
            if let data = try? Data(contentsOf: mURL) {
                let json = JSON(data: data)
                print(json)
                
                let total = json["data"].count
                print(total)
                
                for index in 0..<total {
                    user_id = json["data"][index]["user_id"].string!
                    user_title = json["data"][index]["user_title"].string!
                    mail = json["data"][index]["mail"].string!
                    password = json["data"][index]["password"].string!
                    subscribe = json["data"][index]["subscribe"].string!
                    photo = json["data"][index]["photo"].string!
                    
                    print(password)
                    print(mail)
                    let user: User = User(user_id: user_id, user_title: user_title, mail: mail, password: password, subscribe: subscribe, photo: photo)
            
                    
                    users.append(user)
                }
                
            }
        }
        
        
        for i in 0..<users.count{
            if( users[i].mail == userEmail && users[i].password == userPassword){
                
                self.performSegue(withIdentifier: "goToListenView", sender: self)
                
                
            }
            else if(userEmail == "" || userPassword == "") {
                let tapAlert = UIAlertController(title: "Tapped", message: "Email/Password field(s) can NOT be empty", preferredStyle: UIAlertControllerStyle.alert)
                tapAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
                self.present(tapAlert, animated: true, completion: nil)
                print("not empty")
                
            }
             else if( users[i].mail != userEmail && users[i].password != userPassword){
                print("HAHAAHAHAHA")
                print(users[i].mail)
                print(userEmail)
                print(users[i].password)
                print(userPassword)
                
                
                let tapAlert = UIAlertController(title: "Tapped", message: "Your password and/or your e-mail is NOT correct", preferredStyle: UIAlertControllerStyle.alert)
                tapAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
                self.present(tapAlert, animated: true, completion: nil)
                
                print("print not correct")
                
            }
          
        }
        
        
        // self.performSegue(withIdentifier: "goMain", sender: self)
    }

  
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    
    
    @IBAction func unwindToLogin(_ sender: UIStoryboardSegue) {
        
    }

    
//    
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "listenView" {
//        if let mVC1 = segue.destination as? ListenViewController {
//                
//                mVC1.desc = desc
//                mVC1.authorName = authorName
//                mVC1.bookLink = bookLink
//                mVC1.bookImage = bookImage
//                mVC1.bookName = bookName
//            }
//        }
//    }
//    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    // Clicking the view (the container for UI components) removes the Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
       
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
