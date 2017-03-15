//
//  LoginFromMenuViewController.swift
//  HeyBook
//
//  Created by Admin on 14/03/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit

class LoginFromMenuViewController: UIViewController {
    @IBOutlet weak var eMailTxt: UITextField!

    @IBOutlet weak var myStackView: UIStackView!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    
    var response = ""
    var mail = ""
    var userTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        btnMenu.target = revealViewController()
        btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
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
               
                myStackView.isHidden = true
                
                let tapAlert = UIAlertController(title: "Mesaj", message: "Giriş yaptınız ", preferredStyle: UIAlertControllerStyle.alert)
                tapAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
                self.present(tapAlert, animated: true, completion: nil)
                
                
                
                
            }
            
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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
