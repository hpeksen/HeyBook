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

class ListenViewController: UIViewController, SFSpeechRecognizerDelegate {

    var player = AVPlayer()
    var timer:Timer!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
 

    @IBOutlet weak var bookListenImage: UIImageView!
    var book_id = ""
    var desc = ""
    var bookName = ""
    var authorName = ""
    var bookLink = ""
    var bookImage = ""
    
    
  
    

    
    //voice
    @IBOutlet weak var textView: UITextView!
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))!
    @IBOutlet weak var microphoneButton: UIButton!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    
    
    
    
    @IBAction func unwindToListen(_ sender: UIStoryboardSegue) {
        
    }
    
    @IBAction func menuButton(_ sender: UIBarButtonItem) {
         present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
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
        microphoneButton.isEnabled = false
        
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
                self.microphoneButton.isEnabled = isButtonEnabled
            }
        }

        //voice
        
        
        
     
        descriptionLabel.text = desc
        bookNameLabel.text = bookName
        authorNameLabel.text = authorName
        print("YÜKLEDİİİİİİ")
        let url = URL(string: bookImage)
        let data = try? Data(contentsOf: url!)
        
        print(bookImage)
        print("BOOOOKKİMAAAAJJJ")

        bookListenImage.image = UIImage(data: data!)
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
            if let mVC1 = segue.destination as? LoginViewController {
                
                
                mVC1.parentView = "listen"
              
            }
            
        }
        
    
    //sepete ekle butonu

    @IBAction func sepeteEkle(_ sender: Any) {
        if( UserDefaults.standard.value(forKey: "user_mail") != nil || UserDefaults.standard.value(forKey: "user_title") != nil){
            
            let tapAlert = UIAlertController(title: "Sepete Ekle", message: "sepete eklendi mesajı gelecek", preferredStyle: UIAlertControllerStyle.alert)
            tapAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
            self.present(tapAlert, animated: true, completion: nil)
            
            //satın alma ekranına gidecek
            
        }
        else {
            print("girdiiii")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "loginView")
            self.navigationController?.pushViewController(controller, animated: true)
        }

    }
    
    
    
    
    
    
    
    
    //voice
    
    
    
    
    
    
    @IBAction func btnVoice(_ sender: Any) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            microphoneButton.isEnabled = false
           
            
            
            microphoneButton.setTitle("Start Recording", for: .normal)
        } else {
            startRecording()
            microphoneButton.setTitle("Stop Recording", for: .normal)
            
           
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
                
                self.textView.text = result?.bestTranscription.formattedString  //9
            
                if(self.textView.text == "Hey book"){
                
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "MainViewController")
                    self.navigationController?.pushViewController(controller, animated: true)
                
                }
                if(self.textView.text == "Catagory"){
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "CatagoriesViewController")
                    self.navigationController?.pushViewController(controller, animated: true)
                    
                }
                if(self.textView.text == "Settings"){
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "SettingsViewController")
                    self.navigationController?.pushViewController(controller, animated: true)
                    
                }
                if(self.textView.text == "Bucket"){
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "SepetViewController")
                    self.navigationController?.pushViewController(controller, animated: true)
                    
                }
                
                if(self.textView.text == "Login"){
                    if( UserDefaults.standard.value(forKey: "user_mail") == nil || UserDefaults.standard.value(forKey: "user_title") == nil){
                        
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "loginView")
                    self.navigationController?.pushViewController(controller, animated: true)
                    }
                    else {
                    
                        
                        let longPressAlert = UIAlertController(title: "Mesaj", message: "Uygulamaya  giriş yaptınız", preferredStyle: UIAlertControllerStyle.alert)
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
                
                self.microphoneButton.isEnabled = true
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
            microphoneButton.isEnabled = true
        } else {
            microphoneButton.isEnabled = false
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
    @IBAction func listenBook(_ sender: UIButton) {
        
        
        let url = bookLink
        let playerItem = AVPlayerItem( url:NSURL( string:url ) as! URL )
        player = AVPlayer(playerItem:playerItem)
        player.rate = 1.0;
        player.play()
        listesnBookImage.imageView?.image = UIImage(named: "pause.png")
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ListenViewController.checkTime), userInfo: nil, repeats: true)
        let t1 = Float(self.player.currentTime().value)
        let t2 = Float(self.player.currentTime().timescale)
        let currentSeconds = t1 / t2
        if(currentSeconds >= 10){
            player.pause()
            listesnBookImage.imageView?.image = UIImage(named: "play.png")
        }
        
        print("çalıyo")
        print(bookLink)

       
    }
    
    
    @IBOutlet weak var switchToAdd: UISwitch!
    var registerResponse = ""
    @IBAction func addToFavori(_ sender: Any) {
        
        if(switchToAdd.isOn){
            if( UserDefaults.standard.value(forKey: "user_mail") == nil || UserDefaults.standard.value(forKey: "user_title") == nil){
            
                let tapAlert = UIAlertController(title: "mesaj", message: "Giriş Yapmalısınız", preferredStyle: UIAlertControllerStyle.alert)
                tapAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
                self.present(tapAlert, animated: true, completion: nil)
                
            
            
            }
            else if(UserDefaults.standard.value(forKey: "user_mail") != nil || UserDefaults.standard.value(forKey: "user_title") != nil){

            //Kitabı favorilerime ekle
                if let mURL = URL(string: "http://heybook.online/api.php?request=user_favorites-add&user_id=30&book_id=\(book_id)") { //http://heybook.online/api.php?request=books
                    if let data = try? Data(contentsOf: mURL) {
                        let json = JSON(data: data)
                        print("FAVORİLERİME EKLENDİ")
                        print(json)
                        registerResponse = json["response"].string!
                        let total = json["data"].count
                        print(total)
                        print(registerResponse)
                        
                        
                    }
                }
            
            
            }
        
        }
        if(!switchToAdd.isOn){
        
            if( UserDefaults.standard.value(forKey: "user_mail") == nil || UserDefaults.standard.value(forKey: "user_title") == nil){
                
                let tapAlert = UIAlertController(title: "mesaj", message: "Giriş Yapmalısınız", preferredStyle: UIAlertControllerStyle.alert)
                tapAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
                self.present(tapAlert, animated: true, completion: nil)
                
                
                
            }
            else if(UserDefaults.standard.value(forKey: "user_mail") != nil || UserDefaults.standard.value(forKey: "user_title") != nil){
                
                //Kitabı favorilerimden sil
                //Kitabı favorilerime ekle
                if let mURL = URL(string: "http://heybook.online/api.php?request=user_favorites-delete&user_id=30&book_id=\(book_id)") { //http://heybook.online/api.php?request=books
                    if let data = try? Data(contentsOf: mURL) {
                        let json = JSON(data: data)
                        print("FAVORİLERİME EKLENDİ")
                        print(json)
                        registerResponse = json["response"].string!
                        let total = json["data"].count
                        print(total)
                        print(registerResponse)
                        
                        
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
