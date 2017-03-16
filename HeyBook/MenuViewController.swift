//
//  MenuViewController.swift
//  HeyBook
//
//  Created by Admin on 01/03/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var imgIcon: UIImageView!
    var menuNameArr: Array = [String]()
    var iconImage: Array = [UIImage]()
    var isLogin:Bool=false
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        loginOrNot()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuNameArr = ["HeyBook! Vitrin","Kitaplarım","Favorilerim","Sepet","Satınalma Geçmişi","Giriş Yap","Ayarlar"]
        
        // Do any additional setup after loading the view.  LoginFromMenuViewController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return menuNameArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
       
        cell.lblMenuButton.text! = menuNameArr[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let revealViewController: SWRevealViewController = self.revealViewController()
        let cell:MenuTableViewCell = tableView.cellForRow(at: indexPath) as! MenuTableViewCell
        
        if (cell.lblMenuButton.text! == "HeyBook! Vitrin")
        {
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desController = mainStoryboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            let newFrontViewController = UINavigationController.init(rootViewController: desController)
            
            revealViewController.pushFrontViewController(newFrontViewController, animated: true)
        }
        if (cell.lblMenuButton.text! == "Ayarlar")
        {
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desController = mainStoryboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
            let newFrontViewController = UINavigationController.init(rootViewController: desController)
            
            revealViewController.pushFrontViewController(newFrontViewController, animated: true)
        }
        if (cell.lblMenuButton.text! == "Giriş Yap")
        {
            if( UserDefaults.standard.value(forKey: "user_mail") != nil || UserDefaults.standard.value(forKey: "user_title") != nil){
                let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let desController = mainStoryboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                let newFrontViewController = UINavigationController.init(rootViewController: desController)
             revealViewController.pushFrontViewController(newFrontViewController, animated: true)
            }
            else {
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desController = mainStoryboard.instantiateViewController(withIdentifier: "loginView") as! LoginViewController
            let newFrontViewController = UINavigationController.init(rootViewController: desController)
            
            revealViewController.pushFrontViewController(newFrontViewController, animated: true)
            }
            }
        if (cell.lblMenuButton.text! == "Çıkış Yap")
        {
            UserDefaults.standard.setValue(nil, forKey: "user_mail")
            UserDefaults.standard.setValue(nil, forKey: "user_title")
            
            print("pirint")
            
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desController = mainStoryboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            let newFrontViewController = UINavigationController.init(rootViewController: desController)
            
            revealViewController.pushFrontViewController(newFrontViewController, animated: true)
            
        }

    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func loginOrNot(){
        if( UserDefaults.standard.value(forKey: "user_mail") != nil || UserDefaults.standard.value(forKey: "user_title") != nil){
            isLogin=true
            menuNameArr[5]="Çıkış Yap"
        }
        else {
            isLogin=false
            menuNameArr[5]="Giriş Yap"
        }
        myTableView.reloadData()
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
