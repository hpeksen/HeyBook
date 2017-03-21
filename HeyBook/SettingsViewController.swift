//
//  SettingsViewController.swift
//  HeyBook
//
//  Created by Admin on 08/03/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit
import SideMenu

class SettingsViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var btnMenu: UIBarButtonItem!
    @IBOutlet weak var LoginOl: UIButton!
    @IBOutlet weak var userTitleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

 
    @IBOutlet weak var newPassTxt: UITextField!
    @IBOutlet weak var newPassTxt2: UITextField!
    @IBOutlet weak var oldPassTxt: UITextField!
    @IBOutlet weak var viewLoggedIn: UIView!
    
    @IBOutlet weak var viewChangePass: UIView!
    var mail = ""
    var userTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //keyboard için
        newPassTxt.delegate = self
        newPassTxt2.delegate = self
        oldPassTxt.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        

        
        
        //////keyboard
        
         viewChangePass.isHidden = true
        
        
        let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
        menuLeftNavigationController.leftSide = true
        SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
        
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        SideMenuManager.menuPresentMode = .menuSlideIn

        print("ayarlar ekranındayım")
        
        print(mail)
        print(userTitle)
        // Do any additional setup after loading the view.
        
        if(UserDefaults.standard.value(forKey: "user_mail") == nil || UserDefaults.standard.value(forKey: "user_title") == nil){
        
            viewLoggedIn.isHidden = true
            LoginOl.isHidden = false
           
        }
        else {
            
            viewLoggedIn.isHidden = false
            LoginOl.isHidden = true
        
            userTitleLabel.text =  UserDefaults.standard.value(forKey: "user_title") as? String
            emailLabel.text = UserDefaults.standard.value(forKey: "user_mail") as? String
        
        }
    
    }

    
    //keyboard için
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func keyboardWillShow(notification: NSNotification) {
        var translation:CGFloat = 0
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if newPassTxt.isEditing{
                translation = CGFloat(-keyboardSize.height)
            }else if newPassTxt.isEditing{
                translation = CGFloat(-keyboardSize.height / 3.8)
            }
        }
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if newPassTxt2.isEditing{
                translation = CGFloat(-keyboardSize.height)
            }else if newPassTxt2.isEditing{
                translation = CGFloat(-keyboardSize.height / 3.8)
            }
        }
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if oldPassTxt.isEditing{
                translation = CGFloat(-keyboardSize.height)
            }else if oldPassTxt.isEditing{
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
    
    ////////keyboard  oldPassTxt
    

    
    
    
    
    
    
    
    
    
    @IBAction func changeParola(_ sender: Any) {
        self.oldPassTxt.resignFirstResponder()
        self.newPassTxt.resignFirstResponder()
        self.newPassTxt2.resignFirstResponder()
        print(UserDefaults.standard.value(forKey: "user_title")!)
        print(oldPassTxt.text!)
        print(newPassTxt.text!)
        print(newPassTxt2.text!)
        
        if let mURL = URL(string: "http://heybook.online/api.php?request=change-password&mail=\(UserDefaults.standard.value(forKey: "user_mail")!)&password=\(oldPassTxt.text!)&new-password=\(newPassTxt.text!)&new-password-again=\(newPassTxt2.text!)") {
            
            if let data = try? Data(contentsOf: mURL) {
                let json = JSON(data: data)
                print(json)
                let registerResponse = json["response"].string!
                print(registerResponse)
                
                
                let tapAlert = UIAlertController(title: registerResponse, message: json["message"].string!, preferredStyle: UIAlertControllerStyle.alert)
                tapAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
                self.present(tapAlert, animated: true, completion: nil)
                
            }
            
            
            
        }
        
    }
    
    @IBAction func goLoginPage(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "loginView")
        self.navigationController?.pushViewController(controller, animated: true)
    
    
    }
    
    
    @IBAction func changePassword(_ sender: Any) {
        
        viewChangePass.isHidden = false
    }
    @IBAction func menuButtonClick(_ sender: UIBarButtonItem) {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
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
