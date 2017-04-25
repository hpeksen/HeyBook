//
//  SearchViewController.swift
//  HeyBook
//
//  Created by Admin on 25/04/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit
import SideMenu

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
        menuLeftNavigationController.leftSide = true
        SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
        
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        SideMenuManager.menuPresentMode = .menuSlideIn

        // Do any additional setup after loading the view.
        //Bar Buttonları
        
        let btn2 = UIButton(type: .custom)
        btn2.setImage(UIImage(named: "mikrofon"), for: .normal)
        btn2.frame = CGRect(x: 0, y: 0, width: 20, height: 30)
        btn2.addTarget(self, action: #selector(SearchViewController.btnVoice), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: btn2)
        
        
        let btnSearch = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(SearchViewController.btnSearch))
        btnSearch.tintColor = UIColor.black
        
        
        self.navigationItem.setRightBarButtonItems([item2,btnSearch], animated: true)
        
        let btn3 = UIButton(type: .custom)
        btn3.setImage(UIImage(named: "hamburger"), for: .normal)
        btn3.frame = CGRect(x: 0, y: 0, width: 35, height: 25)
        btn3.addTarget(self, action: #selector(SearchViewController.btnMenu), for: .touchUpInside)
        btn3.tintColor = UIColor.black
        let item3 = UIBarButtonItem(customView: btn3)
        self.navigationItem.setLeftBarButton(item3, animated: true)
        
        
    }
    
    
    
    func btnSearch(){
        print("search button")
      
        
    }
    func btnMenu(){
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
        
    }
    
    func btnVoice(){
        print("voice")
        
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
