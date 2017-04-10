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
    @IBOutlet weak var userTitleLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!

 
    @IBOutlet weak var PassTxt: UITextField!
    @IBOutlet weak var newPassTxt: UITextField!
    @IBOutlet weak var viewLoggedIn: UIView!
    @IBOutlet weak var viewNotLoggedIn: UIView!
    @IBOutlet weak var newPassTxt2: UITextField!
    @IBOutlet weak var disableSwitch: UISwitch!
    @IBOutlet weak var subscribeSwitch: UISwitch!
    
    var mail = ""
    var userTitle = ""
    
    override func viewWillAppear(_ animated: Bool) {
        viewLoggedIn.isHidden = false
        viewNotLoggedIn.isHidden = false
        
        if(UserDefaults.standard.value(forKey: "user_mail") == nil && UserDefaults.standard.value(forKey: "user_title") == nil){
            
            viewLoggedIn.isHidden = true
            viewNotLoggedIn.isHidden = false
        }
        else {
            
            viewLoggedIn.isHidden = false
            viewNotLoggedIn.isHidden = true
            
            userTitleLabel.text =  UserDefaults.standard.value(forKey: "user_title") as? String
            emailLabel.text = UserDefaults.standard.value(forKey: "user_mail") as? String
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //keyboard için
        newPassTxt.delegate = self
        newPassTxt2.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        

        
        
        //////keyboard
        
        
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
    

    
    
    
    
    @IBAction func buttonUpdate(_ sender: UIButton) {
        self.newPassTxt.resignFirstResponder()
        self.newPassTxt2.resignFirstResponder()
        print(UserDefaults.standard.value(forKey: "user_title")!)
        print(newPassTxt.text!)
        print(newPassTxt2.text!)
        
        let originalString = userTitleLabel.text!
        let escapedString = originalString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        if let mURL = URL(string: "http://heybook.online/api.php?request=settings&user_id=\(UserDefaults.standard.value(forKey: "user_id")!)&user_title=\(escapedString!)&mail=\(emailLabel.text!)&password=\(PassTxt.text!)&new-password=\(newPassTxt.text!)&new-password-again=\(newPassTxt2.text!)&subscribe=\(subscribeSwitch.isOn)&disabled=\(disableSwitch.isOn)") {
            print(mURL)
            if let data = try? Data(contentsOf: mURL) {
                let json = JSON(data: data)
                print(json)
                let registerResponse = json["response"].string!
                print(registerResponse)
                
                
                let tapAlert = UIAlertController(title: registerResponse, message: json["message"].string!, preferredStyle: UIAlertControllerStyle.alert)
                tapAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
                self.present(tapAlert, animated: true, completion: nil)
                
                PassTxt.text = ""
                newPassTxt.text = ""
                newPassTxt2.text = ""
                
                UserDefaults.standard.setValue(emailLabel.text!, forKey: "user_mail")
                UserDefaults.standard.setValue(userTitleLabel.text!, forKey: "user_title")
            }
        }
    }
    
    
    @IBAction func goLoginPage(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "loginView")
        self.navigationController?.pushViewController(controller, animated: true)
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
