//
//  MenuViewController.swift
//  HeyBook
//
//  Created by Admin on 01/03/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit
import SideMenu

class MenuViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var imgIcon: UIImageView!
    var menuNameArr: Array = [String]()
    var iconImage: Array = [UIImage]()
    var isLogin:Bool=false
    var menu = ""
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        loginOrNot()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuNameArr = ["HeyBook! Vitrin","Kitaplarım","Katagoriler","Favorilerim","Sepet","Satınalma Geçmişi","Giriş Yap","Ayarlar"]
        
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
       
        cell.lblMenuButton.text = menuNameArr[indexPath.row]
        if(menuNameArr[indexPath.row] == "Satınalma Geçmişi"){
        cell.menuImage.image=UIImage(named: "Satinalma Gecmisi")
        }
        else if(menuNameArr[indexPath.row] == "Giriş Yap"){
            cell.menuImage.image=UIImage(named: "Giris Yap")
        }
        else if(menuNameArr[indexPath.row] == "Çıkış Yap"){
            cell.menuImage.image=UIImage(named: "Cikis Yap")
        }
        else {
        cell.menuImage.image=UIImage(named: menuNameArr[indexPath.row])
        }
            return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
        let cell = tableView.cellForRow(at: indexPath!)! as! MenuTableViewCell
        
        SideMenuManager.menuPushStyle = .popWhenPossible
    
        
        if ( cell.lblMenuButton.text  == "HeyBook! Vitrin")
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "MainViewController")
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        if ( cell.lblMenuButton.text  == "Katagoriler")
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "CatagoriesViewController")
            self.navigationController?.pushViewController(controller, animated: true)
        }
        if ( cell.lblMenuButton.text  == "Sepet")
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "SepetViewController")
            self.navigationController?.pushViewController(controller, animated: true)
        }
        if ( cell.lblMenuButton.text  == "Ayarlar")
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "SettingsViewController")
            self.navigationController?.pushViewController(controller, animated: true)
        }
        if ( cell.lblMenuButton.text  == "Giriş Yap")
            
        {
            menu = "menu"
         
            if( UserDefaults.standard.value(forKey: "user_mail") != nil || UserDefaults.standard.value(forKey: "user_title") != nil){
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "MainViewController")
                self.navigationController?.pushViewController(controller, animated: true)
            }
            else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "loginView")
                self.navigationController?.pushViewController(controller, animated: true)
            }
           
        }
        if ( cell.lblMenuButton.text  == "Çıkış Yap")
        {
            UserDefaults.standard.setValue(nil, forKey: "user_mail")
            UserDefaults.standard.setValue(nil, forKey: "user_title")
            
            print("pirint")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "MainViewController")
            self.navigationController?.pushViewController(controller, animated: true)
       
        }
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let mVC1 = segue.destination as? LoginViewController {
            
            
            mVC1.parentView = menu
            
        }
        
    }
    
    
    func loginOrNot(){
        if( UserDefaults.standard.value(forKey: "user_mail") != nil || UserDefaults.standard.value(forKey: "user_title") != nil){
            isLogin=true
            menuNameArr[6]="Çıkış Yap"
        }
        else {
            isLogin=false
            menuNameArr[6]="Giriş Yap"
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
