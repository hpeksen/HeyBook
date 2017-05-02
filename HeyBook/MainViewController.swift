//
//  ViewController.swift
//  HeyBook
//
//  Created by Admin on 04/01/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire
import SystemConfiguration
import Speech
class MainViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, iCarouselDelegate,iCarouselDataSource, SFSpeechRecognizerDelegate  {
    var records: [Record] = []
    
    var imageAnim : [String] = []
    
    //image animation(carousel)
    @IBOutlet weak var carouselView: iCarousel!
    var numbers = [Int]()
    
    @IBOutlet weak var animationBookName: UILabel!
    @IBOutlet weak var animationAuthorName: UILabel!
    @IBOutlet weak var myCollectionView: UICollectionView!
    var book_id = ""
    var category_id = ""
    var publisher_id = ""
    var author_id = ""
    var narrator_id = ""
    var book_title = ""
    var desc = ""
    var price = ""
    var photo = ""
    var thumb = ""
    var audio = ""
    var duration = ""
    var size = ""
    var demo = ""
    var star = ""
    var category_title = ""
    var author_title = ""
    var publisher_title = ""
    var narrator_title = ""
    
    let mSearchController = UISearchController(searchResultsController: nil)
    var isSearch=false
    var originalNavigationView: UIView?
    var searchedRecords: [Record] = []
    
    //voice
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "tr-TUR"))!
     var btn2 = UIButton(type: .custom)
    var alert = UIAlertView()
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
     
//            print("internett")
//            print(isConnectedToNetwork())
//            let alertController = UIAlertController (title: "Hata", message: "Lütfen internet bağlantınız kontrol ediniz!!!", preferredStyle: .alert)
//            
//            let settingsWifi = UIAlertAction(title: "Wifi Aç", style: .default) { (_) -> Void in
//                guard let settingsUrl = URL(string: "App-Prefs:root=Settings") else {
//                    return
//                }
//                
//                if UIApplication.shared.canOpenURL(settingsUrl) {
//                    //   UIApplication.shared.openURL(URL(string: "prefs:root=General")!)
//                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
//                        print("Settings opened: \(success)") // Prints true
//                    })
//                }
//            }
//            alertController.addAction(settingsWifi)
//            
//            let settingsCellular = UIAlertAction(title: "Mobil Verisi Aç", style: .default) { (_) -> Void in
//                guard let settingsUrl = URL(string: "App-Prefs:root=General") else {
//                    return
//                }
//                
//                if UIApplication.shared.canOpenURL(settingsUrl) {
//                    //   UIApplication.shared.openURL(URL(string: "prefs:root=General")!)
//                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
//                        print("Settings opened: \(success)") // Prints true
//                    })
//                }
//            }
//            alertController.addAction(settingsCellular)
//            
//            present(alertController, animated: true, completion: nil)
            
            
    
        
        
            
            
            if records.isEmpty {
                let urlString = "http://heybook.online/api.php"
                
//                alert = UIAlertView(title: "Mesaj", message: "İşleminiz yapılırken lütfen bekleyiniz...", delegate: nil, cancelButtonTitle: nil);
//                
//                var loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x:50, y:10, width:37, height:37)) as UIActivityIndicatorView
//                loadingIndicator.center = self.view.center;
//                loadingIndicator.hidesWhenStopped = true
//                loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
//                loadingIndicator.startAnimating();
//                
//                alert.setValue(loadingIndicator, forKey: "accessoryView")
//                
//                loadingIndicator.startAnimating()
//                
//                alert.show();
                
                Alamofire.request(urlString, method: .post, parameters: ["request": "books"],encoding: URLEncoding.httpBody, headers: nil).responseJSON {
                    response in
                    switch response.result {
                    case .success:
                        
                        let json = JSON(data: response.data!)
                        print(json["data"][0]["book_title"].string!)
                        
                        
                        let total = json["data"].count
                        print(total)
                        //
                        for index in 0..<total {
                            self.book_id = json["data"][index]["book_id"].string!
                            self.category_id = json["data"][index]["category_id"].string!
                            self.publisher_id = json["data"][index]["publisher_id"].string!
                            self.author_id = json["data"][index]["author_id"].string!
                            self.narrator_id = json["data"][index]["narrator_id"].string!
                            self.book_title = json["data"][index]["book_title"].string!
                            self.desc = json["data"][index]["description"].string!
                            self.price = json["data"][index]["price"].string!
                            self.photo = json["data"][index]["photo"].string!
                            self.thumb = json["data"][index]["thumb"].string!
                            self.audio = json["data"][index]["audio"].string!
                            self.duration = json["data"][index]["duration"].string!
                            self.size = json["data"][index]["size"].string!
                            self.demo = json["data"][index]["demo"].string!
                            self.star = json["data"][index]["star"].string!
                            self.category_title = json["data"][index]["category_title"].string!
                            self.author_title = json["data"][index]["author_title"].string!
                            self.publisher_title = json["data"][index]["publisher_title"].string!
                            self.narrator_title = json["data"][index]["narrator_title"].string!
                            
                            let record: Record = Record(book_id: self.book_id, category_id: self.category_id, publisher_id: self.publisher_id, author_id: self.author_id, narrator_id: self.narrator_id, book_title: self.book_title, desc: self.desc, price: self.price,  photo: self.photo, thumb: self.thumb, audio: self.audio, duration: self.duration, size: self.size,  demo: self.demo, star: self.star, category_title: self.category_title, author_title: self.author_title, publisher_title: self.publisher_title, narrator_title: self.narrator_title)
                            
                            
                            self.records.append(record)
                            
                            print("record: \(record.book_title)")
                            
                        }
                        self.myCollectionView.reloadData()
                        self.carouselView.reloadData()
                        // self.alert.dismiss(withClickedButtonIndex: self.alert.cancelButtonIndex, animated: true)
                        
                        
                        
                        break
                    case .failure(let error):
                        self.alert.dismiss(withClickedButtonIndex: self.alert.cancelButtonIndex, animated: true)
                        print("internett")
                    //    print(isConnectedToNetwork())
                        let alertController = UIAlertController (title: "Hata", message: "Lütfen internet bağlantınız kontrol ediniz. Ya da indirdiğiniz kitapları dinlemek için Kitaplarım sayfasına gidiniz.", preferredStyle: .alert)
                        
                        let settingsWifi = UIAlertAction(title: "Wifi Aç", style: .default) { (_) -> Void in
                            guard let settingsUrl = URL(string: "App-Prefs:root=Wifi") else {
                                return
                            }
                            
                            if UIApplication.shared.canOpenURL(settingsUrl) {
                                //   UIApplication.shared.openURL(URL(string: "prefs:root=General")!)
                                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                    print("Settings opened: \(success)") // Prints true
                                })
                            }
                        }
                        alertController.addAction(settingsWifi)
                        
                        let settingsCellular = UIAlertAction(title: "Mobil Verisi Aç", style: .default) { (_) -> Void in
                            guard let settingsUrl = URL(string: "App-Prefs:root=Settings") else {
                                return
                            }
                            
                            if UIApplication.shared.canOpenURL(settingsUrl) {
                                //   UIApplication.shared.openURL(URL(string: "prefs:root=General")!)
                                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                    print("Settings opened: \(success)") // Prints true
                                })
                            }
                        }
                        alertController.addAction(settingsCellular)
                        
                        let okAction = UIAlertAction(title: "Kitaplarım'a Git", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let controller = storyboard.instantiateViewController(withIdentifier: "KitaplarimViewController")
                            self.navigationController?.pushViewController(controller, animated: true)
                        }
                       
                        
                        // Add the actions
                        alertController.addAction(okAction)
                        
                        
                        
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                
             
            
            //voice
            
            speechRecognizer.delegate = self
            
            SFSpeechRecognizer.requestAuthorization { (authStatus) in
                
                var isButtonEnabled = false
                
                switch authStatus {
                case .authorized:
                    isButtonEnabled = true
                    
                case .denied:
                    isButtonEnabled = false
                    print("User denied access to speech recognition")
                    
                case .restricted:
                    isButtonEnabled = false
                    print("Speech recognition restricted on this device")
                    
                case .notDetermined:
                    isButtonEnabled = false
                    print("Speech recognition not yet authorized")
                }
                
                OperationQueue.main.addOperation() {
                    // self.microphoneButton.isEnabled = isButtonEnabled
                }
            }
            
            //voice
            

            
            
            
            
            
            
            
            
            /*self.view.backgroundColor = UIColor(patternImage: UIImage(named: "register_bg.png")!)*/
            //image animation
            carouselView.type = .rotary
            
            let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
            menuLeftNavigationController.leftSide = true
            SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
            
            SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
            SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
            
            SideMenuManager.menuPresentMode = .menuSlideIn
            
            
            
            //
            //        //Background Image
            //        let bgImage = UIImageView();
            //        bgImage.image = UIImage(named: "register_bg.png");
            //        bgImage.contentMode = .scaleToFill
            //
            //
            //        self.myCollectionView?.backgroundView = bgImage
            //
            self.myCollectionView.backgroundColor = UIColor.clear
            
            
            //cell spacing in collection view
            let screenSize = UIScreen.main.bounds
            let screenWidth = screenSize.width
            //let screenHeight = screenSize.height
            
            var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout = myCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            layout.itemSize = CGSize(width: screenWidth, height: 80)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            myCollectionView!.collectionViewLayout = layout
            
            
            
            
        }
        
        
        //Bar Buttonları
        
       
        btn2.setImage(UIImage(named: "mikrofon"), for: .normal)
        btn2.frame = CGRect(x: 0, y: 0, width: 20, height: 30)
        btn2.addTarget(self, action: #selector(MainViewController.btnVoice), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: btn2)
        
        
        let btnSearch = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(MainViewController.btnSearch))
        btnSearch.tintColor = UIColor.black
        
        
        self.navigationItem.setRightBarButtonItems([item2,btnSearch], animated: true)
        
        let btn3 = UIButton(type: .custom)
        btn3.setImage(UIImage(named: "hamburger"), for: .normal)
        btn3.frame = CGRect(x: 0, y: 0, width: 35, height: 25)
        btn3.addTarget(self, action: #selector(MainViewController.btnMenu), for: .touchUpInside)
        btn3.tintColor = UIColor.black
        let item3 = UIBarButtonItem(customView: btn3)
        self.navigationItem.setLeftBarButton(item3, animated: true)
        
        
    }
    
    
    
    func btnSearch(){
        print("search button")
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let controller = storyboard.instantiateViewController(withIdentifier: "SearchViewController")
        //        self.navigationController?.pushViewController(controller, animated: true)
        //
        
        if(isSearch){
            self.navigationItem.titleView = originalNavigationView
        } else {
            originalNavigationView = self.navigationItem.titleView
            
            mSearchController.searchResultsUpdater = self
            self.navigationItem.titleView = mSearchController.searchBar
            mSearchController.searchBar.delegate = self
            
            definesPresentationContext = true
            
            mSearchController.dimsBackgroundDuringPresentation = false
            mSearchController.hidesNavigationBarDuringPresentation = false
            
            mSearchController.searchBar.placeholder = "Search books"
            mSearchController.searchBar.tintColor = UIColor.white
            mSearchController.searchBar.barTintColor = UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        }
        isSearch = !isSearch
    }
    func btnMenu(){
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
        
    }
    
    
    //voice
    
    
    
    
    
    
    func btnVoice(_ sender: Any) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            //  microphoneButton.isEnabled = false
            
            
            
            //  microphoneButton.setTitle("Start Recording", for: .normal)
        } else {
            
            
                         alert = UIAlertView(title: "Mesaj", message: "Dinleniyor...", delegate: nil, cancelButtonTitle: nil);
            
                        var loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x:50, y:10, width:37, height:37)) as UIActivityIndicatorView
                        loadingIndicator.center = self.view.center;
                        loadingIndicator.hidesWhenStopped = true
                        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                        loadingIndicator.startAnimating();
            
                        alert.setValue(loadingIndicator, forKey: "accessoryView")
            
                        loadingIndicator.startAnimating()
                        
                        alert.show();
            
            startRecording()
            // microphoneButton.setTitle("Stop Recording", for: .normal)
            
            
        }
        
    }
    
    func startRecording() {
        
        if recognitionTask != nil {  //1
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()  //2
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()  //3
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }  //4
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        } //5
        
        recognitionRequest.shouldReportPartialResults = true  //6
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in  //7
            
            var isFinal = false  //8
            
            if result != nil {
                
               print(result?.bestTranscription.formattedString.lowercased())  //9
                
                if(result?.bestTranscription.formattedString == "Vitrin"){
                   self.audioEngine.stop()
                    recognitionRequest.endAudio()
                    self.alert.dismiss(withClickedButtonIndex: self.alert.cancelButtonIndex, animated: true)
                    
                }
               else if(result?.bestTranscription.formattedString == "Kitaplarım"){
                     self.audioEngine.stop()
                    
                    self.alert.dismiss(withClickedButtonIndex: self.alert.cancelButtonIndex, animated: true)
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
               else if(result?.bestTranscription.formattedString == "Kategoriler"){
                    self.audioEngine.stop()
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "CatagoriesViewController")
                    self.navigationController?.pushViewController(controller, animated: true)
                    self.alert.dismiss(withClickedButtonIndex: self.alert.cancelButtonIndex, animated: true)
                }
                else if(result?.bestTranscription.formattedString.lowercased() == "arama yap"){
                    self.audioEngine.stop()
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "SearchViewController")
                    self.navigationController?.pushViewController(controller, animated: true)
                    self.alert.dismiss(withClickedButtonIndex: self.alert.cancelButtonIndex, animated: true)
                }
               else if(result?.bestTranscription.formattedString == "Favorilerim"){
                    self.audioEngine.stop()
                    
                    self.alert.dismiss(withClickedButtonIndex: self.alert.cancelButtonIndex, animated: true)
                    if( UserDefaults.standard.value(forKey: "user_mail") != nil || UserDefaults.standard.value(forKey: "user_title") != nil || UserDefaults.standard.value(forKey: "user_id") != nil){
                        
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "FavorilerViewController")
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
               else if(result?.bestTranscription.formattedString == "Ayarlar"){
                    self.audioEngine.stop()
                    
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
                    self.alert.dismiss(withClickedButtonIndex: self.alert.cancelButtonIndex, animated: true)
                }
               else if(result?.bestTranscription.formattedString == "Sepet"){
                    self.audioEngine.stop()
                    
                    self.alert.dismiss(withClickedButtonIndex: self.alert.cancelButtonIndex, animated: true)
                    
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
             
                
               else if(result?.bestTranscription.formattedString == "Giriş"){
                    
                    self.alert.dismiss(withClickedButtonIndex: self.alert.cancelButtonIndex, animated: true)
                    if( UserDefaults.standard.value(forKey: "user_mail") == nil || UserDefaults.standard.value(forKey: "user_title") == nil){
                        self.audioEngine.stop()
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "loginView")
                        self.navigationController?.pushViewController(controller, animated: true)
                        self.alert.dismiss(withClickedButtonIndex: self.alert.cancelButtonIndex, animated: true)
                    }
                    else {
                        
                        self.audioEngine.stop()
                        let longPressAlert = UIAlertController(title: "Mesaj", message: "Uygulamaya daha önce giriş yaptınız", preferredStyle: UIAlertControllerStyle.alert)
                        longPressAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
                        self.present(longPressAlert, animated: true, completion: nil)
                        
                        
                        
                    }
                    
                }
               else if(result?.bestTranscription.formattedString == "Çıkış"){
                       self.alert.dismiss(withClickedButtonIndex: self.alert.cancelButtonIndex, animated: true)
                    if( UserDefaults.standard.value(forKey: "user_mail") != nil || UserDefaults.standard.value(forKey: "user_title") != nil){
                        self.audioEngine.stop()
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
                        
                        //self.imgIcon.image = UIImage(named: "logo.png")
                        let tapAlert = UIAlertController(title: "Mesaj", message: "Çıkış yaptınız", preferredStyle: UIAlertControllerStyle.alert)
                        tapAlert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.destructive, handler: {(action: UIAlertAction!) in
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let controller = storyboard.instantiateViewController(withIdentifier: "MainViewController")
                            self.navigationController?.pushViewController(controller, animated: true)
                        }))
                        self.present(tapAlert, animated: true, completion: nil)
                        
                        
                    }
                    else {
                        self.audioEngine.stop()
                        
                        recognitionRequest.endAudio()
                        
                        let longPressAlert = UIAlertController(title: "Mesaj", message: "Zaten çıkış yapmışsınız", preferredStyle: UIAlertControllerStyle.alert)
                        longPressAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
                        self.present(longPressAlert, animated: true, completion: nil)
                        
                        
                        
                    }
                }
                else {
                
                    self.audioEngine.stop()
                    recognitionRequest.endAudio()
                    self.alert.dismiss(withClickedButtonIndex: self.alert.cancelButtonIndex, animated: true)
                    
                    let longPressAlert = UIAlertController(title: "Mesaj", message: "Aramanıza uygun birşey bulamadık", preferredStyle: UIAlertControllerStyle.alert)
                    longPressAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
                    self.present(longPressAlert, animated: true, completion: nil)
                
                
                
                
                }
                
                
                
                
                
                
                isFinal = (result?.isFinal)!
                
                
            }
            
            if error != nil || isFinal {  //10
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                //    self.microphoneButton.isEnabled = true
                // self.listen(ses: (result?.bestTranscription.formattedString)!)
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)  //11
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()  //12
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        //textView.text = "Say something, I'm listening!"
        
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            //    microphoneButton.isEnabled = true
        } else {
            //    microphoneButton.isEnabled = false
        }
    }
    
    
    
    

    
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        
        
        //        if let mURL = URL(string: "http://heybook.online/api.php?request=books") { //http://heybook.online/api.php?request=books
        //            if let data = try? Data(contentsOf: mURL) {
        //                let json = JSON(data: data)
        //                //print(json)
        //
        //                let total = json["data"].count
        //                //print(total)
        //
        //                for index in 0..<total {
        //                    book_id = json["data"][index]["book_id"].string!
        //                    category_id = json["data"][index]["category_id"].string!
        //                    publisher_id = json["data"][index]["publisher_id"].string!
        //                    author_id = json["data"][index]["author_id"].string!
        //                    narrator_id = json["data"][index]["narrator_id"].string!
        //                    book_title = json["data"][index]["book_title"].string!
        //                    desc = json["data"][index]["description"].string!
        //                    price = json["data"][index]["price"].string!
        //                    photo = json["data"][index]["photo"].string!
        //                    thumb = json["data"][index]["thumb"].string!
        //                    audio = json["data"][index]["audio"].string!
        //                    duration = json["data"][index]["duration"].string!
        //                    size = json["data"][index]["size"].string!
        //                    demo = json["data"][index]["demo"].string!
        //                    star = json["data"][index]["star"].string!
        //                    category_title = json["data"][index]["category_title"].string!
        //                    author_title = json["data"][index]["author_title"].string!
        //                    publisher_title = json["data"][index]["publisher_title"].string!
        //                    //print(book_title)
        //                    //print(author_title)
        //                    //print(duration)
        //                    //print(photo)
        //                    let record: Record = Record(book_id: book_id, category_id: category_id, publisher_id: publisher_id, author_id: author_id, narrator_id: narrator_id, book_title: book_title, desc: desc, price: price,  photo: photo, thumb: thumb, audio: audio, duration: duration, size: size,  demo: demo, star: star, category_title: category_title, author_title: author_title, publisher_title: publisher_title)
        //
        //
        //
        //                    records.append(record)
        //
        //
        //
        //                }
        //
        //            }
        //
        //        }
        
        
    }
    
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return records.count
    }
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: 100 , height: 120))
        
        
        
        
        
        
        
        
        // Aschronized image loading !!!!
        URLSession.shared.dataTask(with: NSURL(string: records[index].photo)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                
                
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 90, height: 120))
                button.setTitle("\(self.records[index].book_title)", for: .normal)
                button.setImage(UIImage(data: data!), for: .normal)
                //                            button.imageView?.image = UIImage(data: data!)
                tempView.addSubview(button)
                
                button.addTarget(self, action: #selector(self.click), for: .touchUpInside)
                
                //cell.bookImage.image = UIImage(data: data!)
                
            })
            
        }).resume()
        
        
        return tempView
    }
    
    func click(sender: UIButton!) {
        print("click")
        print((sender.titleLabel?.text)!)
        
        // record = records[indexPath.row]
        
        
        for i in 0..<records.count {
            if((sender.titleLabel?.text)! == records[i].book_title){
                let record: Record
                record = records[i]
                
                let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: record)
                UserDefaults.standard.set(encodedData, forKey: "book_record")
                UserDefaults.standard.synchronize()
            }
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "listenView")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == iCarouselOption.spacing{
            return 1
        }
        return value
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        if !records.isEmpty{
            
            animationBookName.text = records[carousel.currentItemIndex].book_title
            animationAuthorName.text = records[carousel.currentItemIndex].author_title
            
        }
    }
    
    
    @IBAction func unwindToVitrin(_ sender: UIStoryboardSegue) {
        
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    // Clicking the view (the container for UI components) removes the Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickSearchButton(_ sender: UIBarButtonItem) {
        
    }
    
    
    //satın al butonu
    
    
    
    
    
    
    
    
    
    func searchedRecordsForSearchText(_ searchText: String) {
        searchedRecords = records.filter ({ (record: Record) -> Bool in
            return record.book_title.lowercased().contains(searchText.lowercased())
        })
        
        myCollectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = getIndexPathForSelectedCell() {
            if let mVC1 = segue.destination as? ListenViewController {
                let record: Record
                
                if mSearchController.isActive && mSearchController.searchBar.text != "" {
                    record = searchedRecords[indexPath.row]
                } else {
                    record = records[indexPath.row]
                }
                
                //            UserDefaults.standard.setValue(record.book_title, forKey: "book_title")
                //            UserDefaults.standard.setValue(record.desc, forKey: "desc")
                //            UserDefaults.standard.setValue(record.demo, forKey: "demo")
                //            UserDefaults.standard.setValue(record.author_title, forKey: "author_name")
                //            UserDefaults.standard.setValue(record.thumb, forKey: "thumb")
                
                
                let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: record)
                UserDefaults.standard.set(encodedData, forKey: "book_record")
                UserDefaults.standard.synchronize()
                
                //                mVC1.desc = record.desc
                //                mVC1.authorName = record.author_title
                //                mVC1.bookLink = record.demo
                //                mVC1.bookImage = record.thumb
                //                mVC1.bookName = record.book_title
            }
            
            
        }
        
    }
    
    func getIndexPathForSelectedCell() -> IndexPath? {
        var indexPath: IndexPath?
        
        if myCollectionView.indexPathsForSelectedItems!.count > 0 {
            indexPath = myCollectionView.indexPathsForSelectedItems![0] as IndexPath
        }
        
        return indexPath
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if mSearchController.isActive && mSearchController.searchBar.text != "" {
            return searchedRecords.count
        }
        
        return records.count
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        //return mDataSource.groups.count
        return 3
    }
    
    // For each cell setting the data
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CustomCollectionViewCell
        
        //let records: [Record] = mDataSource.recordsInSection(indexPath.section)
        let record: Record
        
        if mSearchController.isActive && mSearchController.searchBar.text != "" {
            record = searchedRecords[indexPath.row]
        } else {
            record = records[indexPath.row]
        }
        
        //Aschronized image loading !!!!
        URLSession.shared.dataTask(with: NSURL(string: record.photo)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                
                cell.authorName.text = record.author_title
                cell.bookName.text = record.book_title
                
                let (h,m,s) = self.secondsToHoursMinutesSeconds(seconds: (Int(record.duration)! * 60))
                cell.duration.text = "\(h):\(m) dk"
                
                
                cell.bookImage.image = UIImage(data: data!)
                
            })
            
        }).resume()
        
        if(indexPath.section == 0) {
            cell.leftView.backgroundColor = UIColor(hex: "50D2C2") //UIColor(red: 0x50, green: 0xD2, blue: 0xC2, alpha: 1)
        } else if(indexPath.section == 1) {
            cell.leftView.backgroundColor = UIColor(hex: "FCAB53")
        } else if(indexPath.section == 2) {
            cell.leftView.backgroundColor = UIColor(hex: "039BE5")
        }
        
        
        
        return cell
    }
    
    
    // For each header setting the data
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! HeaderCollectionReusableView
        
        if(indexPath.section == 0 )
        {
            headerView.header.text = "SON EKLENENLER"
        }
        
        if(indexPath.section == 1 )
        {
            headerView.header.text = "BU HAFTA EN ÇOK DİNLENENLER"
        }
        
        if(indexPath.section == 2 )
        {
            headerView.header.text = "ÇOK SATAN"
        }
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: records[indexPath.row])
        UserDefaults.standard.set(encodedData, forKey: "book_record")
        UserDefaults.standard.synchronize()
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        let hours = Int(seconds) / 3600
        let minutes = Int(seconds) / 60 % 60
        let seconds = Int(seconds) % 60
        return (hours, minutes, seconds)
    }
    
    //check the internet connection
    func isConnectedToNetwork()->Bool{
        
        var Status:Bool = false
        let url = URL(string: "https://google.com/")
        var response: URLResponse?
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "HEAD"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest)
        
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 200 {
                Status = true
            }
        }
        
        
        task.resume()
        return !Status
    }
}

extension MainViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    
    // Tells the delegate that the scope button selection changed
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        searchedRecordsForSearchText(searchBar.text!)
    }
}

extension MainViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        searchedRecordsForSearchText(searchController.searchBar.text!)
    }
}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}

