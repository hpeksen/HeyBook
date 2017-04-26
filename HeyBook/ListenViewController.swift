//
//  ListenViewController.swift
//  HeyBook
//
//  Created by Admin on 04/01/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit
import AVFoundation
import Speech
import SideMenu
import Cosmos
import Alamofire
import RNCryptor

class ListenViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    var timer:Timer!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    @IBOutlet weak var bookListenImage: UIImageView!
    var book_id = ""
    var desc = ""
    var bookName = ""
    var authorName = ""
    var bookLink = ""
    var bookImage = ""
    var price = ""
    var star = ""
    var demo = ""
    
    @IBOutlet weak var starsView: CosmosView!
    
    
    
    
    //voice
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var addToChartButton: UIButton!
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "tr-TUR"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    private var bookPassword = "Secret password"
    private var ciphertext:Data? = nil
    var audioPlayer = AVAudioPlayer()
    
    var mp3FileNames:[String] = []
    var mp3Files:[URL] = []
    
    
    
    
    
    @IBAction func unwindToListen(_ sender: UIStoryboardSegue) {
        
    }
    
   
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        descriptionLabel.setContentOffset(CGPoint.zero, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        if let dataa = UserDefaults.standard.data(forKey: "book_record"),
            let record = NSKeyedUnarchiver.unarchiveObject(with: dataa) as? Record {
            book_id = (record.book_id)
            desc = (record.desc)
            bookName = (record.book_title)
            authorName = (record.author_title)
            bookLink = (record.demo)
            bookImage = (record.thumb)
            price = (record.price)
            star = (record.star)
            demo = (record.demo)
        } else {
            print("olmadi lan....")
            
        }
        
        //yan menu
        
        let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
        menuLeftNavigationController.leftSide = true
        SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
        
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        SideMenuManager.menuPresentMode = .menuSlideIn
        
        
        
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
        
        
        
        
        descriptionLabel.text = desc
        bookNameLabel.text = bookName
        authorNameLabel.text = authorName
        priceLabel.text = price
        print("YÜKLEDİİİİİİ")
        let url = URL(string: bookImage)
        let data = try? Data(contentsOf: url!)
        
        print(bookImage)
        print("BOOOOKKİMAAAAJJJ")
        
        bookListenImage.image = UIImage(data: data!)
        
        
        
        //Favori yıldızları: https://github.com/marketplacer/Cosmos
        starsView.rating = Double(star)!
        
        //Favori switch kontrol
        if UserDefaults.standard.value(forKey: "user_id") != nil {
            var urlString = "http://heybook.online/api.php"
            var parameters = ["request": "user_favorites",
                              "user_id": "\(UserDefaults.standard.value(forKey: "user_id")!)"]
            
            Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil).responseJSON {
                response in
                switch response.result {
                case .success:
                    
                    
                    let json = JSON(data: response.data!)
                    print(json)
                    self.registerResponse = json["response"].string!
                    let total = json["data"].count
                    print(total)
                    
                    for index in 0..<total {
                        if (self.book_id == json["data"][index]["book_id"].string!){
                            self.switchToAdd.setOn(true, animated: true)
                        }
                    }
                    
                    print(self.registerResponse)
                    
                    
                    
                    
                    break
                case .failure(let error):
                    
                    print(error)
                }
            }
            
            urlString = "http://heybook.online/api.php"
            parameters = ["request": "user_books",
                          "user_id": "\(UserDefaults.standard.value(forKey: "user_id")!)"]
            
            Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil).responseJSON {
                response in
                switch response.result {
                case .success:
                    
                    
                    let json = JSON(data: response.data!)
                    print(json)
                    self.registerResponse = json["response"].string!
                    let total = json["data"].count
                    print(total)
                    
                    for index in 0..<total {
                        if (self.book_id == json["data"][index]["book_id"].string!){
                            self.addToChartButton.setTitle("İNDİR", for: .normal)
                        }
                    }
                    
                    // Get the document directory url
                    let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    
                    do {
                        // Get the directory contents urls (including subfolders urls)
                        let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
                        print(directoryContents)
                        
                        // if you want to filter the directory contents you can do like this:
                        self.mp3Files = directoryContents.filter{ $0.pathExtension == "file" }
                        print("mp3 file urls:",self.mp3Files)
                        self.mp3FileNames = self.mp3Files.map{ $0.deletingPathExtension().lastPathComponent }
                        print("mp3 file list:", self.mp3FileNames)
                        
                        for i in 0..<self.mp3FileNames.count {
                            if self.mp3FileNames[i] == self.bookName {
                                self.addToChartButton.setTitle("İNDİRİLDİ", for: .normal)
                            }
                        }
                        
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                    
                    print(self.registerResponse)
                    
                    
                    
                    
                    break
                case .failure(let error):
                    
                    print(error)
                }
            }
            
            starsView.isUserInteractionEnabled = true
            starsView.didFinishTouchingCosmos = {
                rating in
                print("stars")
                print(rating)
                
                let urlString = "http://heybook.online/api.php"
                let parameters = ["request": "user_stars-add",
                                  "user_id": "\(UserDefaults.standard.value(forKey: "user_id")!)",
                    "book_id": "\(self.book_id)",
                    "star": "\(rating)"]
                
                Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil).responseJSON {
                    response in
                    switch response.result {
                    case .success:
                        var registerResponse = ""
                        let json = JSON(data: response.data!)
                        print(json)
                        registerResponse = json["response"].string!
                        let total = json["data"].count
                        print(total)
                        print(registerResponse)
                        
                        break
                    case .failure(let error):
                        
                        print(error)
                    }
                }
            }
            
        } else {
            starsView.didFinishTouchingCosmos = {
                rating in
                self.starsView.rating = Double(self.star)!
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
        
        let url_demo = URL(string: demo)
        let playerItem:AVPlayerItem = AVPlayerItem(url: url_demo!)
        player = AVPlayer(playerItem: playerItem)
        
        // Do any additional setup after loading the view.
        //Bar Buttonları
        
        let btn2 = UIButton(type: .custom)
        btn2.setImage(UIImage(named: "mikrofon_beyaz"), for: .normal)
        btn2.frame = CGRect(x: 0, y: 0, width: 20, height: 30)
        btn2.addTarget(self, action: #selector(ListenViewController.btnVoice), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: btn2)
        
        
        let btnSearch = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(ListenViewController.btnSearch))
        btnSearch.tintColor = UIColor.white
        
        
        self.navigationItem.setRightBarButtonItems([item2,btnSearch], animated: true)
        
        let btn3 = UIButton(type: .custom)
        btn3.setImage(UIImage(named: "hamburger"), for: .normal)
        btn3.frame = CGRect(x: 0, y: 0, width: 35, height: 25)
        btn3.addTarget(self, action: #selector(ListenViewController.btnMenu), for: .touchUpInside)
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
    
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let mVC1 = segue.destination as? LoginViewController {
            
            
            mVC1.parentView = "listen"
            
        }
        
    }
    
    
    //sepete ekle butonu
    
    @IBAction func sepeteEkle(_ sender: Any) {
        if addToChartButton.titleLabel?.text == "SEPETE EKLE" {
            if( UserDefaults.standard.value(forKey: "user_mail") != nil || UserDefaults.standard.value(forKey: "user_title") != nil){
                
                
                //Kitabı sepete ekle
                let urlString = "http://heybook.online/api.php"
                let parameters = ["request": "user_cart-add",
                                  "user_id": "\(UserDefaults.standard.value(forKey: "user_id")!)",
                    "book_id": "\(book_id)"]
                
                Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil).responseJSON {
                    response in
                    switch response.result {
                    case .success:
                        let json = JSON(data: response.data!)
                        print("SEPETE EKLENDİ")
                        print(json)
                        self.registerResponse = json["response"].string!
                        let total = json["data"].count
                        print(total)
                        print(self.registerResponse)
                        
                        break
                    case .failure(let error):
                        
                        print(error)
                    }
                }
                
                let tapAlert = UIAlertController(title: "Sepete Ekle", message: "Kitap sepete eklendi", preferredStyle: UIAlertControllerStyle.alert)
                tapAlert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.destructive, handler: nil))
                self.present(tapAlert, animated: true, completion: nil)
                
                //satın alma ekranına gidecek
                
            }
            else {
                
                let tapAlert = UIAlertController(title: "Mesaj", message: "Giriş yapınız", preferredStyle: UIAlertControllerStyle.alert)
                tapAlert.addAction(UIAlertAction(title: "Giriş Yap", style: UIAlertActionStyle.destructive, handler: {(action: UIAlertAction!) in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "loginView")
                    self.navigationController?.pushViewController(controller, animated: true)
                }))
                tapAlert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
                self.present(tapAlert, animated: true, completion: nil)
                
                
                //            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                //            let controller = storyboard.instantiateViewController(withIdentifier: "loginView")
                //            self.navigationController?.pushViewController(controller, animated: true)
            }
        }
        else if(addToChartButton.titleLabel?.text == "İNDİR") {
            print("download kodları")
            
            let url = NSURL(string: bookLink)
            let data = NSData(contentsOf: url as! URL)
            bookPassword = "Secret password"
            ciphertext = RNCryptor.encrypt(data: data as! Data, withPassword: bookPassword)
            
            let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("\(bookName).file")
            
            print(fileURL)
            do {
                try ciphertext?.write(to: fileURL, options: .atomic)
                print(ciphertext)
                addToChartButton.setTitle("İNDİRİLDİ", for: .normal)
            } catch {
                print(error)
            }
        }
        else if(addToChartButton.titleLabel?.text == "İNDİRİLDİ") {
            do {
                var originalData:Data
                ciphertext = nil
                for i in 0..<mp3FileNames.count {
                    if mp3FileNames[i] == bookName {
                        ciphertext = NSData(contentsOf: mp3Files[i]) as! Data
                    }
                }
                originalData = try RNCryptor.decrypt(data: ciphertext!, withPassword: bookPassword)
//                
//                let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("decrypted.mp3")
//                try originalData.write(to: fileURL, options: .atomic)
                do {
                    audioPlayer = try AVAudioPlayer(data: originalData)
                    
                    // https://developer.apple.com/library/ios/documentation/Audio/Conceptual/AudioSessionProgrammingGuide/AudioSessionCategoriesandModes/AudioSessionCategoriesandModes.html
                    // Define how the application intends to use audio
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                    
                    // Activates or deactivates your app’s audio session.
                    try AVAudioSession.sharedInstance().setActive(true)
                }
                catch {
                    print("Error occurred")
                }
                
                //audioPlayer.numberOfLoops = -1  // infinite loop
                audioPlayer.prepareToPlay()
                
                audioPlayer.play()
            } catch {
                print(error)
            }
        }
        
    }
    
    
    
    
    
    
    
    
    //voice
    
    
    
    
    
    
     func btnVoice(_ sender: Any) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
          //  microphoneButton.isEnabled = false
            
            
            
          //  microphoneButton.setTitle("Start Recording", for: .normal)
        } else {
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
                
                print(result?.bestTranscription.formattedString)  //9
                
                if(result?.bestTranscription.formattedString == "Vitrin"){
                     self.audioEngine.stop()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "MainViewController")
                    self.navigationController?.pushViewController(controller, animated: true)
                    
                }
                if(result?.bestTranscription.formattedString == "Kitaplarım"){
                     self.audioEngine.stop()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "KitaplarimViewController")
                    self.navigationController?.pushViewController(controller, animated: true)
                    
                }
                if(result?.bestTranscription.formattedString == "Kategoriler"){
                     self.audioEngine.stop()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "CatagoriesViewController")
                    self.navigationController?.pushViewController(controller, animated: true)
                    
                }
                if(result?.bestTranscription.formattedString == "Favorilerim"){
                     self.audioEngine.stop()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "FavorilerViewController")
                    self.navigationController?.pushViewController(controller, animated: true)
                    
                }
                if(result?.bestTranscription.formattedString == "Ayarlar"){
                     self.audioEngine.stop()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "SettingsViewController")
                    self.navigationController?.pushViewController(controller, animated: true)
                    
                }
                if(result?.bestTranscription.formattedString == "Sepet"){
                     self.audioEngine.stop()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "SepetViewController")
                    self.navigationController?.pushViewController(controller, animated: true)
                    
                }
                if(result?.bestTranscription.formattedString == "Satınalma geçmişi"){
                     self.audioEngine.stop()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "SepetViewController")
                    self.navigationController?.pushViewController(controller, animated: true)
                    
                }
                
                if(result?.bestTranscription.formattedString == "Giriş yap"){
                    if( UserDefaults.standard.value(forKey: "user_mail") == nil || UserDefaults.standard.value(forKey: "user_title") == nil){
                         self.audioEngine.stop()
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "loginView")
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                    else {
                         self.audioEngine.stop()
                        
                        let longPressAlert = UIAlertController(title: "Mesaj", message: "Uygulamaya giriş yaptınız", preferredStyle: UIAlertControllerStyle.alert)
                        longPressAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
                        self.present(longPressAlert, animated: true, completion: nil)
                        
                        
                        
                    }
                   
                    
                }
                
                if(result?.bestTranscription.formattedString == "Çıkış yap"){
                    if( UserDefaults.standard.value(forKey: "user_mail") != nil || UserDefaults.standard.value(forKey: "user_title") != nil){
                        self.audioEngine.stop()
                        let longPressAlert = UIAlertController(title: "Mesaj", message: "Uygulamadan çıkış yaptınız", preferredStyle: UIAlertControllerStyle.alert)
                        longPressAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
                        self.present(longPressAlert, animated: true, completion: nil)
                        
                        
                    }
                    else {
                        self.audioEngine.stop()
                        
                        let longPressAlert = UIAlertController(title: "Mesaj", message: "Zaten çıkış yapmışsınız", preferredStyle: UIAlertControllerStyle.alert)
                        longPressAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
                        self.present(longPressAlert, animated: true, completion: nil)
                        
                        
                        
                    }
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
        
        textView.text = "Say something, I'm listening!"
        
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
        //    microphoneButton.isEnabled = true
        } else {
        //    microphoneButton.isEnabled = false
        }
    }
    
    
    
    
    func  listen(){
        print("listen functionu")
        
        
        
        
        let url = bookLink
        let playerItem = AVPlayerItem( url:NSURL( string:url ) as! URL )
        player = AVPlayer(playerItem:playerItem)
        player.rate = 1.0;
        player.play()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ListenViewController.checkTime), userInfo: nil, repeats: true)
        let t1 = Float(self.player.currentTime().value)
        let t2 = Float(self.player.currentTime().timescale)
        let currentSeconds = t1 / t2
        if(currentSeconds >= 10){
            player.pause()
        }
        
        print("çalıyo")
        print(bookLink)
        
        
        
    }
    
    //voice
    
    
    
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkTime() {
        if self.player.currentTime().seconds >= 5 {
            self.player.pause()
            self.player.replaceCurrentItem(with: nil)
            timer.invalidate()
        }
    }
    
    @IBOutlet weak var listesnBookImage: UIButton!
    var player = AVPlayer()
    var playerLayer:AVPlayerLayer?
    
    @IBAction func listenBook(_ sender: UIButton) {
        
        if((player.rate != 0) && (player.error == nil)) {
            player.pause()
            listesnBookImage.setImage(UIImage(named: "play.png"), for: UIControlState.normal)
        }
        else {
            
            player.play()
            
            listesnBookImage.setImage(UIImage(named: "pause.png"), for: UIControlState.normal)
            
            print("çalıyo")
            print(bookLink)
        }
        
        
    }
    
    
    @IBOutlet weak var switchToAdd: UISwitch!
    var registerResponse = ""
    @IBAction func addToFavori(_ sender: Any) {
        
        if(switchToAdd.isOn){
            if( UserDefaults.standard.value(forKey: "user_mail") == nil || UserDefaults.standard.value(forKey: "user_title") == nil){
                
                switchToAdd.setOn(false, animated: true)
                let tapAlert = UIAlertController(title: "Mesaj", message: "Giriş yapınız", preferredStyle: UIAlertControllerStyle.alert)
                tapAlert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.destructive, handler: {(action: UIAlertAction!) in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "loginView")
                    self.navigationController?.pushViewController(controller, animated: true)
                }))
                tapAlert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
                self.present(tapAlert, animated: true, completion: nil)
            }
            else if(UserDefaults.standard.value(forKey: "user_mail") != nil || UserDefaults.standard.value(forKey: "user_title") != nil){
                
                //Kitabı favorilerime ekle
                let urlString = "http://heybook.online/api.php"
                let parameters = ["request": "user_favorites-add",
                                  "user_id": "\(UserDefaults.standard.value(forKey: "user_id")!)",
                    "book_id": "\(book_id)"]
                
                Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil).responseJSON {
                    response in
                    switch response.result {
                    case .success:
                        let json = JSON(data: response.data!)
                        print("FAVORİLERİME EKLENDİ")
                        print(json)
                        self.registerResponse = json["response"].string!
                        let total = json["data"].count
                        print(total)
                        print(self.registerResponse)
                        
                        break
                    case .failure(let error):
                        
                        print(error)
                    }
                }
            }
            
        }
        if(!switchToAdd.isOn){
            
            if( UserDefaults.standard.value(forKey: "user_mail") == nil || UserDefaults.standard.value(forKey: "user_title") == nil){
                
                switchToAdd.setOn(false, animated: false)
                let tapAlert = UIAlertController(title: "Mesaj", message: "Giriş yapınız", preferredStyle: UIAlertControllerStyle.alert)
                tapAlert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.destructive, handler: {(action: UIAlertAction!) in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "loginView")
                    self.navigationController?.pushViewController(controller, animated: true)
                }))
                tapAlert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
                self.present(tapAlert, animated: true, completion: nil)
                
                
                
            }
            else if(UserDefaults.standard.value(forKey: "user_mail") != nil || UserDefaults.standard.value(forKey: "user_title") != nil){
                
                //Kitabı favorilerimden sil
                //Kitabı favorilerime ekle
                let urlString = "http://heybook.online/api.php"
                let parameters = ["request": "user_favorites-delete",
                                  "user_id": "\(UserDefaults.standard.value(forKey: "user_id")!)",
                    "book_id": "\(book_id)"]
                
                Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil).responseJSON {
                    response in
                    switch response.result {
                    case .success:
                        let json = JSON(data: response.data!)
                        print("FAVORİLERİMDEN ÇIKARILDI")
                        print(json)
                        self.registerResponse = json["response"].string!
                        let total = json["data"].count
                        print(total)
                        print(self.registerResponse)
                        
                        break
                    case .failure(let error):
                        
                        print(error)
                    }
                }
            }
            
            
            
            
            
            
        }
        
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
