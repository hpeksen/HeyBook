//
//  SettingsViewController.swift
//  HeyBook
//
//  Created by Admin on 08/03/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var btnMenu: UIBarButtonItem!
    @IBOutlet weak var LoginOl: UIButton!
    @IBOutlet weak var userTitleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    @IBOutlet weak var viewLoggedIn: UIView!
    
    var mail = ""
    var userTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnMenu.target = revealViewController()
        btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        print("ayarlar ekranındayım")
        
        print(mail)
        print(userTitle)
        // Do any additional setup after loading the view.
        
        if(mail == "" || userTitle == ""){
        
            viewLoggedIn.isHidden = true
            LoginOl.isHidden = false
           
        }
        else {
            
            viewLoggedIn.isHidden = false
            LoginOl.isHidden = true
        
            userTitleLabel.text = userTitle
            emailLabel.text = mail
        
        }
    
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
