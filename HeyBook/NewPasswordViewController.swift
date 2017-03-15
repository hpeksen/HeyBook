//
//  NewPasswordViewController.swift
//  HeyBook
//
//  Created by Admin on 13/03/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit

class NewPasswordViewController: UIViewController {

    @IBOutlet weak var myTextField: UITextField!
    var newPasswordResponse = ""
    var message = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func newPasswordBtn(_ sender: Any) {
        
        if let mURL = URL(string: "http://heybook.online/api.php?request=forgot&mail=\(myTextField.text!)") { //http://heybook.online/api.php?request=books
            if let data = try? Data(contentsOf: mURL) {
                let json = JSON(data: data)
                print(json)
                newPasswordResponse = json["response"].string!
                message = json["message"].description
                print(message)
                print(newPasswordResponse)
                
                
            }
        }
        
        if (newPasswordResponse == "error" && message == "Error: Email address can not be blank."){
        
            let longPressAlert = UIAlertController(title: "Hata", message: "Lütfen e-mail adresinizi giriniz!", preferredStyle: UIAlertControllerStyle.alert)
            longPressAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
            self.present(longPressAlert, animated: true, completion: nil)
            
        
        
        }
       else if (newPasswordResponse == "error" && message == "Error: Email address is invalid."){
            
            let longPressAlert = UIAlertController(title: "Hata", message: "Lütfen uygun bir mail adresi giriniz(Örnek: heybook@online.com) ", preferredStyle: UIAlertControllerStyle.alert)
            longPressAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
            self.present(longPressAlert, animated: true, completion: nil)
            
            
            
        }
        else if (newPasswordResponse == "error" && message == "Error: Email address can not be found."){
            
            let longPressAlert = UIAlertController(title: "Hata", message: "Böyle bir e-mail adresi yoktur. Lütfen e-mail adresinizi tekrar giriniz! ", preferredStyle: UIAlertControllerStyle.alert)
            longPressAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
            self.present(longPressAlert, animated: true, completion: nil)
            
            
            
        }
        else if(newPasswordResponse == "success"){
        
        
            let longPressAlert = UIAlertController(title: "Mesaj", message: "Yeni şifreniz mail adresinize gönderildi.", preferredStyle: UIAlertControllerStyle.alert)
            longPressAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
            self.present(longPressAlert, animated: true, completion: nil)
            
        
        
        }
        
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // Clicking the view (the container for UI components) removes the Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    
    // Delegate to remove the keyboard (When the return key is pressed the keyboard will disappear)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
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