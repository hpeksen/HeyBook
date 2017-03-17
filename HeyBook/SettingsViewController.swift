//
//  SettingsViewController.swift
//  HeyBook
//
//  Created by Admin on 08/03/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit
import SideMenu

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
