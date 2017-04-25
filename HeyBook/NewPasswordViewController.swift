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
import SideMenu

class NewPasswordViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var myTextField: SearchTextField!
    var newPasswordResponse = ""
    var message = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        myTextField.delegate = self
        
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        

        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
              // Do any additional setup after loading the view.
        // autocomplete: https://github.com/apasccon/SearchTextField
        myTextField.inlineMode = true
        let array:[String] = UserDefaults.standard.stringArray(forKey: "user_mail_autocomplete_array") == nil ? [] : UserDefaults.standard.stringArray(forKey: "user_mail_autocomplete_array")!
        myTextField.filterStrings(array)
        
        
        
        let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
        menuLeftNavigationController.leftSide = true
        SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
        
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        SideMenuManager.menuPresentMode = .menuSlideIn
        
        
        
        //Bar Buttonları
        
        let btn2 = UIButton(type: .custom)
        btn2.setImage(UIImage(named: "mikrofon_beyaz"), for: .normal)
        btn2.frame = CGRect(x: 0, y: 0, width: 20, height: 30)
        btn2.addTarget(self, action: #selector(NewPasswordViewController.btnVoice), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: btn2)
        
        
        let btnSearch = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(NewPasswordViewController.btnSearch))
        btnSearch.tintColor = UIColor.white
        
        
        self.navigationItem.setRightBarButtonItems([item2,btnSearch], animated: true)
        
        let btn3 = UIButton(type: .custom)
        btn3.setImage(UIImage(named: "hamburger"), for: .normal)
        btn3.frame = CGRect(x: 0, y: 0, width: 35, height: 25)
        btn3.addTarget(self, action: #selector(NewPasswordViewController.btnMenu), for: .touchUpInside)
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
                
                let longPressAlert = UIAlertController(title: "", message: "\(json["message"].description)", preferredStyle: UIAlertControllerStyle.alert)
                longPressAlert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.destructive, handler: nil))
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
