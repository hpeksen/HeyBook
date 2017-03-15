//
//  LoginViewController.swift
//  HeyBook
//
//  Created by Admin on 10/01/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    
    var response = ""
    var mail = ""
    var userTitle = ""
    
    var parentView = ""
    
    @IBOutlet weak var myStackView: UIStackView!
   
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var btnMenu: UIBarButtonItem!
   
    @IBOutlet weak var eMailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.value(forKey: "user_mail") != nil || UserDefaults.standard.value(forKey: "user_title") != nil {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "listenView") as! ListenViewController
            self.present(nextViewController, animated:true, completion:nil)
        }
        
      
        btnMenu.target = revealViewController()
        btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        
        
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//        
    // Do any additional setup after loading the view.
    }
    @IBAction func loginBtn(_ sender: Any) {
     
        self.eMailTxt.resignFirstResponder()
        self.passwordTxt.resignFirstResponder()
        
        
        if(eMailTxt.text == "" || passwordTxt.text == "" ) {
        
            let tapAlert = UIAlertController(title: "Tapped", message: "Lütfen bütün alanları doldurunuz!", preferredStyle: UIAlertControllerStyle.alert)
            tapAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
            self.present(tapAlert, animated: true, completion: nil)
        
        }
            
            
            
        else {
        
        
        
        if let mURL = URL(string: "http://heybook.online/api.php?request=login&mail=\(eMailTxt.text!)&password=\(passwordTxt.text!)") { //http://heybook.online/api.php?request=books
            if let data = try? Data(contentsOf: mURL) {
                let json = JSON(data: data)
                print(json)
                response = json["response"].string!
                let total = json["data"].count
                mail = json["data"]["mail"].description
                userTitle = json["data"]["user_title"].description
                print(total)
                print(response)
                print(mail)
                print(userTitle)
                
                

            }
        }
            
            if(response == "error"){
                let tapAlert = UIAlertController(title: "Tapped", message: "Girilen e-mail ya da şifre yanlış! Lütfen tekrar deneyiniz. 3 hakkınız var :) ", preferredStyle: UIAlertControllerStyle.alert)
                tapAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
                self.present(tapAlert, animated: true, completion: nil)
                
            
            
            }
            
            
            if(response == "success"){
                UserDefaults.standard.setValue(mail, forKey: "user_mail")
                UserDefaults.standard.setValue(userTitle, forKey: "user_title")
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "listenView") as! ListenViewController
                self.present(nextViewController, animated:true, completion:nil)
                
                
            
            }
        
            
        }
   
        
        // self.performSegue(withIdentifier: "goMain", sender: self)
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
    
    @IBAction func unwindToLogin(_ sender: UIStoryboardSegue) {
        
    }

    
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if(segue.identifier == "goToListenView"){
//        if let mVC1 = segue.destination as? ListenViewController {
//                
//                mVC1.mail = mail
//                mVC1.userTitle = userTitle
//            }
//            }
//        
//    }
    
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
