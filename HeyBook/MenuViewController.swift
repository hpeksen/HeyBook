//
//  MenuViewController.swift
//  HeyBook
//
//  Created by Admin on 01/03/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit
import SideMenu
import AVFoundation

class MenuViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var imgIcon: UIImageView!
    var menuNameArr: Array = [String]()
    var iconImage: Array = [UIImage]()
    var isLogin:Bool=false
    var menu = ""
    var photo = ""
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        imgIcon.layer.cornerRadius = imgIcon.frame.size.width / 2;
        if let data = UserDefaults.standard.object(forKey: "user_photo") as? NSData {
            imgIcon.image = UIImage(data: data as Data)
        }
        else {
            imgIcon.image = UIImage(named: "logo")
        }
        
        loginOrNot()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuNameArr = ["HeyBook! Vitrin","Kategoriler","HeyBook'ta Ara","Kitaplarım","Favorilerim","Sepet","Ayarlar","Giriş Yap"]
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
        
     //   SideMenuManager.menuPushStyle = .popWhenPossible
    
        
        if ( cell.lblMenuButton.text  == "HeyBook! Vitrin")
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "MainViewController")
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        if ( cell.lblMenuButton.text  == "Kitaplarım")
        {
            if( UserDefaults.standard.value(forKey: "user_mail") != nil || UserDefaults.standard.value(forKey: "user_title") != nil || UserDefaults.standard.value(forKey: "user_id") != nil){
                
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "KitaplarimViewController")
            self.navigationController?.pushViewController(controller, animated: true)
            }
            else {
                let tapAlert = UIAlertController(title: "Mesaj", message: "Giriş yapınız", preferredStyle: UIAlertControllerStyle.alert)
                tapAlert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.destructive, handler: {(action: UIAlertAction!) in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "loginView")
                    self.navigationController?.pushViewController(controller, animated: true)
                }))
                tapAlert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
                self.present(tapAlert, animated: true, completion: nil)
                
            
            }
        }
        
        if ( cell.lblMenuButton.text  == "Favorilerim")
        {
            if( UserDefaults.standard.value(forKey: "user_mail") != nil || UserDefaults.standard.value(forKey: "user_title") != nil || UserDefaults.standard.value(forKey: "user_id") != nil){
                
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "FavorilerViewController")
            self.navigationController?.pushViewController(controller, animated: true)
            }
            else{
                let tapAlert = UIAlertController(title: "Mesaj", message: "Giriş yapınız", preferredStyle: UIAlertControllerStyle.alert)
                tapAlert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.destructive, handler: {(action: UIAlertAction!) in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "loginView")
                    self.navigationController?.pushViewController(controller, animated: true)
                }))
                tapAlert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
                self.present(tapAlert, animated: true, completion: nil)
            
            
            }
            
            }
        
        if ( cell.lblMenuButton.text  == "Kategoriler")
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "CatagoriesViewController")
            self.navigationController?.pushViewController(controller, animated: true)
        }
        if ( cell.lblMenuButton.text  == "HeyBook'ta Ara")
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "SearchViewController")
            self.navigationController?.pushViewController(controller, animated: true)
        }
        if ( cell.lblMenuButton.text  == "Sepet")
        {
            if( UserDefaults.standard.value(forKey: "user_mail") != nil || UserDefaults.standard.value(forKey: "user_title") != nil || UserDefaults.standard.value(forKey: "user_id") != nil){

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "SepetViewController")
            self.navigationController?.pushViewController(controller, animated: true)
            }
            else {
                let tapAlert = UIAlertController(title: "Mesaj", message: "Giriş yapınız", preferredStyle: UIAlertControllerStyle.alert)
                tapAlert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.destructive, handler: {(action: UIAlertAction!) in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "loginView")
                    self.navigationController?.pushViewController(controller, animated: true)
                }))
                tapAlert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
                self.present(tapAlert, animated: true, completion: nil)
                
            
            }
            }
        if ( cell.lblMenuButton.text  == "Ayarlar")
        {
            
            if( UserDefaults.standard.value(forKey: "user_mail") != nil || UserDefaults.standard.value(forKey: "user_title") != nil || UserDefaults.standard.value(forKey: "user_id") != nil){
                
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "SettingsViewController")
                self.navigationController?.pushViewController(controller, animated: true)
            }
            else {
                let tapAlert = UIAlertController(title: "Mesaj", message: "Giriş yapınız", preferredStyle: UIAlertControllerStyle.alert)
                tapAlert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.destructive, handler: {(action: UIAlertAction!) in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "loginView")
                    self.navigationController?.pushViewController(controller, animated: true)
                }))
                tapAlert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
                self.present(tapAlert, animated: true, completion: nil)
                
                
            }
        }
        if ( cell.lblMenuButton.text  == "Giriş Yap")
            
        {
            menu = "menu"
         
            if( UserDefaults.standard.value(forKey: "user_mail") != nil || UserDefaults.standard.value(forKey: "user_title") != nil || UserDefaults.standard.value(forKey: "user_id") != nil){
                
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
            UserDefaults.standard.setValue(nil, forKey: "user_id")
            UserDefaults.standard.setValue(nil, forKey: "user_photo")
            
            if isAudioPlayerPlaying {
                audioPlayerPlaying.pause()
                isAudioPlayerPlaying = false
                UserDefaults.standard.setValue("\(audioPlayerPlaying.currentTime)", forKey: "playing_book_duration")
            }
            else if isPlayerPlaying {
                playerPlaying.pause()
                isPlayerPlaying = false
                UserDefaults.standard.setValue("\(CMTimeGetSeconds((playerPlaying.currentItem?.currentTime())!))", forKey: "playing_book_duration")
            }
            
            self.imgIcon.image = UIImage(named: "logo.png")
            let tapAlert = UIAlertController(title: "Mesaj", message: "Çıkış yaptınız", preferredStyle: UIAlertControllerStyle.alert)
            tapAlert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.destructive, handler: {(action: UIAlertAction!) in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "MainViewController")
                self.navigationController?.pushViewController(controller, animated: true)
            }))
            self.present(tapAlert, animated: true, completion: nil)
       
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
        if( UserDefaults.standard.value(forKey: "user_mail") != nil || UserDefaults.standard.value(forKey: "user_title") != nil || UserDefaults.standard.value(forKey: "user_id") != nil){
            isLogin=true
            menuNameArr[7]="Çıkış Yap"
        }
        else {
            isLogin=false
            menuNameArr[7]="Giriş Yap"
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
