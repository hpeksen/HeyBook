//
//  LoginViewController.swift
//  HeyBook
//
//  Created by Admin on 10/01/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit
import SideMenu
import SearchTextField
import Alamofire

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    
    
    var response = ""
    var mail = ""
    var userTitle = ""
    var user_id = ""
    
    var parentView = ""
    
    @IBOutlet weak var myStackView: UIStackView!
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var eMailTxt: SearchTextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //keyboard için
        eMailTxt.delegate = self
        passwordTxt.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        /////
        
        
        
        
        print("parent")
        print(parentView)
        
        
        if UserDefaults.standard.value(forKey: "user_mail") != nil || UserDefaults.standard.value(forKey: "user_title") != nil {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "listenView") as! ListenViewController
            
            
            self.present(nextViewController, animated:true, completion:nil)
        }
        
        
        let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
        menuLeftNavigationController.leftSide = true
        SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
        
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        SideMenuManager.menuPresentMode = .menuSlideIn
        
        
        // autocomplete: https://github.com/apasccon/SearchTextField
        eMailTxt.inlineMode = true
        let array:[String] = UserDefaults.standard.stringArray(forKey: "user_mail_autocomplete_array") == nil ? [] : UserDefaults.standard.stringArray(forKey: "user_mail_autocomplete_array")!
        eMailTxt.filterStrings(array)
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    //keyboard için
    
    //bu method'u kaldırınca autocomplete çalışmıyor
    /*func textFieldShouldReturn(_ textField: UITextField) -> Bool {
     self.view.endEditing(true)
     return false
     }*/
    
    func keyboardWillShow(notification: NSNotification) {
        var translation:CGFloat = 0
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if passwordTxt.isEditing{
                translation = CGFloat(-keyboardSize.height)
            }else if passwordTxt.isEditing{
                translation = CGFloat(-keyboardSize.height / 3.8)
            }
        }
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if eMailTxt.isEditing{
                translation = CGFloat(-keyboardSize.height)
            }else if eMailTxt.isEditing{
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
    
    ////////keyboard
    
    
    
    @IBAction func menuButtonClick(_ sender: UIBarButtonItem) {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        
        self.eMailTxt.resignFirstResponder()
        self.passwordTxt.resignFirstResponder()
        
        let urlString = "http://heybook.online/api.php"
        let parameters = ["request": "login",
                          "mail": "\(eMailTxt.text!)",
            "password": "\((passwordTxt.text!))"]
        
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                let json = JSON(data: response.data!)
                print("USER BİLGİLERİ")
                print(json)
                let  responses = json["response"].string!
                let total = json["data"].count
                self.mail = json["data"]["mail"].description
                self.userTitle = json["data"]["user_title"].description
                self.user_id = json["data"]["user_id"].description
               
                if (json["response"].description == "error"){
                    let tapAlert = UIAlertController(title: "", message: "\(json["message"].description)", preferredStyle: UIAlertControllerStyle.alert)
                    tapAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
                    self.present(tapAlert, animated: true, completion: nil)
                }
                else {
                    // autocomplete string array
                    var array:[String] = UserDefaults.standard.stringArray(forKey: "user_mail_autocomplete_array") == nil ? [] : UserDefaults.standard.stringArray(forKey: "user_mail_autocomplete_array")!
                    array.append(self.mail)
                    UserDefaults.standard.set(array, forKey: "user_mail_autocomplete_array")
                    
                    UserDefaults.standard.setValue(self.mail, forKey: "user_mail")
                    UserDefaults.standard.setValue(self.userTitle, forKey: "user_title")
                    UserDefaults.standard.setValue(self.user_id, forKey: "user_id")
                    print("hebelehübele")
                    print(self.parentView)
                    
                    if(self.parentView == ""){
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "MainViewController")
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                    else if (self.parentView == "listen"){
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "listenView")
                        self.navigationController?.pushViewController(controller, animated: true)
                        
                    }
                    
                }
                
                break
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    
    
    @IBAction func unwindToLogin(_ sender: UIStoryboardSegue) {
        
    }
    
    
    
    
    override var prefersStatusBarHidden: Bool {
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
