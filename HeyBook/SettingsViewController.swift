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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnMenu.target = revealViewController()
        btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        // Do any additional setup after loading the view.
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
