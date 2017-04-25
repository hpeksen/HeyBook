//
//  RegisterViewController.swift
//  HeyBook
//
//  Created by Admin on 06/02/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit
import Alamofire
import SideMenu

class RegisterViewController: UIViewController,UITextFieldDelegate {
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
            longPressAlert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.destructive, handler: nil))
            self.present(longPressAlert, animated: true, completion: nil)
            
            
        }
        else if (isValidEmail(testStr: mailField.text!) == false){
            let longPressAlert = UIAlertController(title: "Hata", message: "Lütfen uygun bir mail adresi giriniz(Örnek: heybook@online.com)", preferredStyle: UIAlertControllerStyle.alert)
            longPressAlert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.destructive, handler: nil))
            self.present(longPressAlert, animated: true, completion: nil)
            
        
        }
        else if (passwordField.text! != passwordConfirmField.text! ){
            let longPressAlert = UIAlertController(title: "Hata", message: "Lütfen parola alanlarına aynı parola giriniz", preferredStyle: UIAlertControllerStyle.alert)
            longPressAlert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.destructive, handler: nil))
            self.present(longPressAlert, animated: true, completion: nil)
            
            
        }
        else {
            
          //  URLEncoder.encode(q, "UTF-8")
            let originalString = nameField.text!
           // let escapedString = originalString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            
            let urlString = "http://heybook.online/api.php"
            let parameters = ["request": "register",
                              "user_title": "\(originalString)",
                                "mail": "\(mailField.text!)",
                                "password": "\(passwordField.text!)"]
            
            Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil).responseJSON {
                response in
                switch response.result {
                case .success:
                    
                    
                    let json = JSON(data: response.data!)
                    print(json)
                    self.registerResponse = json["response"].string!
                    let total = json["data"].count
                    print(total)
                    print(self.registerResponse)
                    
                    if(self.registerResponse == "success"){
                        let tapAlert = UIAlertController(title: "Mesaj", message: "\(json["message"].description)", preferredStyle: UIAlertControllerStyle.alert)
                        tapAlert.addAction(UIAlertAction(title: "Giriş Yap", style: UIAlertActionStyle.destructive, handler: {(action: UIAlertAction!) in
                           self.performSegue(withIdentifier: "goToLogin", sender: self)
                        }))
                        
                        tapAlert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
                        self.present(tapAlert, animated: true, completion: nil)
                        
                        // autocomplete string array
                        var array:[String] = UserDefaults.standard.stringArray(forKey: "user_mail_autocomplete_array") == nil ? [] : UserDefaults.standard.stringArray(forKey: "user_mail_autocomplete_array")!
                        array.append(self.mailField.text!)
                        UserDefaults.standard.set(array, forKey: "user_mail_autocomplete_array")
                        
                    }
                    
                    
                    break
                case .failure(let error):
                    
                    print(error)
                }
            }
            
            
        
            
            
            if(registerResponse == "error"){
            
                let longPressAlert = UIAlertController(title: "Hata", message: "Bu e-mail adresi kullanılıyor. Lütfen başka bir e-mail adresi giriniz!", preferredStyle: UIAlertControllerStyle.alert)
                longPressAlert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.destructive, handler: nil))
                self.present(longPressAlert, animated: true, completion: nil)
                
            
            
            }
            
           
            
            
        }
        

    }
  
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    @IBAction func menuButtonClick(_ sender: UIBarButtonItem) {
         present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        

        
        
        //klavye için
        nameField.delegate = self
        mailField.delegate = self
        passwordField.delegate = self
        passwordConfirmField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        

        
        
        
        let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
        menuLeftNavigationController.leftSide = true
        SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
        
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        SideMenuManager.menuPresentMode = .menuSlideIn

        ////klavye

        // Do any additional setup after loading the view.
   
        //Bar Buttonları
        
        let btn2 = UIButton(type: .custom)
        btn2.setImage(UIImage(named: "mikrofon_beyaz"), for: .normal)
        btn2.frame = CGRect(x: 0, y: 0, width: 20, height: 30)
        btn2.addTarget(self, action: #selector(RegisterViewController.btnVoice), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: btn2)
        
        
        let btnSearch = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(RegisterViewController.btnSearch))
        btnSearch.tintColor = UIColor.white
        
        
        self.navigationItem.setRightBarButtonItems([item2,btnSearch], animated: true)
        
        let btn3 = UIButton(type: .custom)
        btn3.setImage(UIImage(named: "hamburger"), for: .normal)
        btn3.frame = CGRect(x: 0, y: 0, width: 35, height: 25)
        btn3.addTarget(self, action: #selector(RegisterViewController.btnMenu), for: .touchUpInside)
        btn3.tintColor = UIColor.white
        let item3 = UIBarButtonItem(customView: btn3)
        self.navigationItem.setLeftBarButton(item3, animated: true)
        
        
    }
    
    
    
    func btnSearch(){
        print("search button")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SearchViewController")
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    func btnMenu(){
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
        
    }
    
    func btnVoice(){
        print("voice")
        
    }
    
    
    
    

        
        
        
        
    //keyboard için
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func keyboardWillShow(notification: NSNotification) {
        var translation:CGFloat = 0
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if nameField.isEditing{
                translation = CGFloat(-keyboardSize.height)
            }else if nameField.isEditing{
                translation = CGFloat(-keyboardSize.height / 3.8)
            }
        }
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if mailField.isEditing{
                translation = CGFloat(-keyboardSize.height)
            }else if mailField.isEditing{
                translation = CGFloat(-keyboardSize.height / 3.8)
            }
        }
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if passwordField.isEditing{
                translation = CGFloat(-keyboardSize.height)
            }else if passwordField.isEditing{
                translation = CGFloat(-keyboardSize.height / 3.8)
            }
        }
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if passwordConfirmField.isEditing{
                translation = CGFloat(-keyboardSize.height)
            }else if passwordConfirmField.isEditing{
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
