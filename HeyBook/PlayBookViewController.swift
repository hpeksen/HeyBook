//
//  PlayBookViewController.swift
//  HeyBook
//
//  Created by Admin on 03/04/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit
import AVFoundation
import SideMenu
import RNCryptor
import Speech
var playerPlaying = AVPlayer()
var audioPlayerPlaying = AVAudioPlayer()
class PlayBookViewController: UIViewController, SFSpeechRecognizerDelegate {

    @IBOutlet weak var bookPhoto: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var playButtonImage: UIButton!
    @IBOutlet weak var bookAuthorLabel2: UILabel!
    @IBOutlet weak var bookAuthorLabel: UILabel!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var sureLabel: UILabel!
    @IBOutlet weak var publisherNameLabel: UILabel!
    @IBOutlet weak var narratorNameLabel: UILabel!
    
    var bookName = ""
    var authorName = ""
    var bookLink = ""
    var bookImage = ""
    var narratorName = ""
    var publisherName = ""
    var duration = ""
    
    var player = AVPlayer()
    var playerLayer:AVPlayerLayer?
    
    var isDownloaded:Bool = false
    private var bookPassword = "Secret password"
    private var ciphertext:Data? = nil
    var audioPlayer = AVAudioPlayer()
    
    var mp3FileNames:[String] = []
    var mp3Files:[URL] = []
    
    
    //voice
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "tr-TUR"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        if let dataa = UserDefaults.standard.data(forKey: "book_record_play"),
            let record = NSKeyedUnarchiver.unarchiveObject(with: dataa) as? Record {
            
            bookName = (record.book_title)
            authorName = (record.author_title)
            bookLink = (record.audio)
            bookImage = (record.thumb)
            narratorName = record.narrator_title
            publisherName = record.publisher_title
            duration = (record.duration)
        } else {
            print("olmadi lan....")
            
        }
        
        bookAuthorLabel.text = authorName
        bookAuthorLabel2.text = authorName
        bookNameLabel.text = bookName
        narratorNameLabel.text = narratorName
        publisherNameLabel.text = publisherName
        let (h,m,s) = secondsToHoursMinutesSeconds(seconds: Int(duration)!)
        var durationMessage = ""
        if h != 0 {
            durationMessage += "\(h) saat"
        }
        if m != 0 {
            durationMessage += "\(m) dakika"
        }
        sureLabel.text = durationMessage
        
        self.bookPhoto.layer.cornerRadius = self.bookPhoto.frame.size.width / 2;
        self.bookPhoto.clipsToBounds = true;
        
        //Aschronized image loading !!!!
        URLSession.shared.dataTask(with: NSURL(string: bookImage)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                
                self.bookPhoto.image = UIImage(data: data!)
                
            })
            
        }).resume()
        
        let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
        menuLeftNavigationController.leftSide = true
        SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
        
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        SideMenuManager.menuPresentMode = .menuSlideIn
        
        //Is Downloaded?
        // Get the document directory url
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            print(directoryContents)
            
            // if you want to filter the directory contents you can do like this:
            mp3Files = directoryContents.filter{ $0.pathExtension == "file" }
            print("mp3 file urls:", mp3Files)
            mp3FileNames = self.mp3Files.map{ $0.deletingPathExtension().lastPathComponent }
            print("mp3 file list:", mp3FileNames)
            
            for i in 0..<mp3FileNames.count {
                let fileNameArr = mp3FileNames[i].characters.split{$0 == "_"}.map(String.init)
                if fileNameArr[1] == self.bookName {
                    isDownloaded = true
                }
            }
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        if isDownloaded {
            do {
                var originalData:Data
                ciphertext = nil
                for i in 0..<mp3FileNames.count {
                    let fileNameArr = mp3FileNames[i].characters.split{$0 == "_"}.map(String.init)
                    if fileNameArr[1] == bookName {
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
                slider.maximumValue = Float(audioPlayer.duration)
            } catch {
                print(error)
            }
        }
        else {
            let url = URL(string: bookLink)
            let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
            player = AVPlayer(playerItem: playerItem)
            slider.maximumValue = Float(CMTimeGetSeconds((player.currentItem?.asset.duration)!))
        }
        slider.value = 0.0
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        timeLabel.text = "00:00"
        
        
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
        
        

        
        //Bar Buttonları
        
        let btn2 = UIButton(type: .custom)
        btn2.setImage(UIImage(named: "mikrofon_beyaz"), for: .normal)
        btn2.frame = CGRect(x: 0, y: 0, width: 20, height: 30)
        btn2.addTarget(self, action: #selector(PlayBookViewController.btnVoice), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: btn2)
        
        
        let btnSearch = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(PlayBookViewController.btnSearch))
        btnSearch.tintColor = UIColor.white
        
        
        self.navigationItem.setRightBarButtonItems([item2,btnSearch], animated: true)
        
        let btn3 = UIButton(type: .custom)
        btn3.setImage(UIImage(named: "hamburger"), for: .normal)
        btn3.frame = CGRect(x: 0, y: 0, width: 35, height: 25)
        btn3.addTarget(self, action: #selector(PlayBookViewController.btnMenu), for: .touchUpInside)
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
                        let longPressAlert = UIAlertController(title: "Mesaj", message: "Uygulamaya daha önce giriş yaptınız", preferredStyle: UIAlertControllerStyle.alert)
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
        
        //textView.text = "Say something, I'm listening!"
        
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            //    microphoneButton.isEnabled = true
        } else {
            //    microphoneButton.isEnabled = false
        }
    }
    
    
    

    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func playButton(_ sender: UIButton) {
        if isDownloaded {
            if audioPlayer.isPlaying {
                audioPlayer.pause()
                playButtonImage.setImage(UIImage(named: "play-1.png"), for: UIControlState.normal)
            }
           else {
//                if audioPlayerPlaying != audioPlayer {
//                    audioPlayerPlaying.stop()
//                }
                audioPlayer.play()
                audioPlayerPlaying = audioPlayer
                playButtonImage.setImage(UIImage(named: "pause-1.png"), for: UIControlState.normal)
                UserDefaults.standard.setValue(bookName, forKey: "playing_book")
            }
        }
        else {
            if((player.rate != 0) && (player.error == nil)) {
                player.pause()
                playButtonImage.setImage(UIImage(named: "play-1.png"), for: UIControlState.normal)
            }
            else {
//                if playerPlaying != player {
//                    playerPlaying.pause()
//                }
                player.play()
                playerPlaying = player
                playButtonImage.setImage(UIImage(named: "pause-1.png"), for: UIControlState.normal)
                UserDefaults.standard.setValue(bookName, forKey: "playing_book")
                print("çalıyo")
                print(bookLink)
            }
        }
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        if isDownloaded {
            audioPlayer.currentTime = TimeInterval(sender.value)
        }
        else {
            player.seek(to: CMTimeMakeWithSeconds(Float64(sender.value), 10000))
        }
    }
    
    func updateTime(_ timer: Timer) {
        var time:Int
        if isDownloaded {
            time = Int(audioPlayer.currentTime)
            slider.value = Float(audioPlayer.currentTime)
        }
        else {
            time = Int(CMTimeGetSeconds((player.currentItem?.currentTime())!))
            slider.value = Float(CMTimeGetSeconds((player.currentItem?.currentTime())!))
        }
        
        let (h,m,s) = secondsToHoursMinutesSeconds(seconds: time)
        timeLabel.text = NSString(format: "%02d:%02d", m,s) as String
    }
    
    @IBAction func forwardButtonClicked(_ sender: AnyObject) {
        if isDownloaded {
            let forwardTimeInSeconds = (Float(audioPlayer.currentTime) + 10)
            audioPlayer.currentTime = TimeInterval(forwardTimeInSeconds)
        }
        else {
            let forwardTimeInSeconds = (Float(CMTimeGetSeconds((player.currentItem?.currentTime())!)) + 10)
            player.seek(to: CMTimeMakeWithSeconds(Float64(forwardTimeInSeconds), 10000))
        }
    }
    
    @IBAction func backwardButtonClicked(_ sender: AnyObject) {
        if isDownloaded {
            let forwardTimeInSeconds = (Float(audioPlayer.currentTime) - 10)
            audioPlayer.currentTime = TimeInterval(forwardTimeInSeconds)
        }
        else {
            let forwardTimeInSeconds = (Float(CMTimeGetSeconds((player.currentItem?.currentTime())!)) - 10)
            player.seek(to: CMTimeMakeWithSeconds(Float64(forwardTimeInSeconds), 10000))
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    @IBAction func unwindToPlay(_ sender: UIStoryboardSegue) {
        
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        let hours = Int(seconds) / 3600
        let minutes = Int(seconds) / 60 % 60
        let seconds = Int(seconds) % 60
        return (hours, minutes, seconds)
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

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
