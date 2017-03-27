//
//  SepetViewController.swift
//  HeyBook
//
//  Created by Admin on 27/03/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit
import SideMenu

class SepetViewController: UIViewController {

    @IBOutlet weak var btnMenu: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
        menuLeftNavigationController.leftSide = true
        SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
        
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        SideMenuManager.menuPresentMode = .menuSlideIn
        // Do any additional setup after loading the view.
    }

    @IBAction func menuButtonClick(_ sender: Any) {
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
