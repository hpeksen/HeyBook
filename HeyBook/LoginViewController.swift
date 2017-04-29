//
//  LoginViewController.swift
//  HeyBook
//
//  Created by Admin on 10/01/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit
import SideMenu
import SearchTextField
import Alamofire
import Speech
import Foundation

class LoginViewController: UIViewController,UITextFieldDelegate, SFSpeechRecognizerDelegate {
    
    
    
    var response = ""
    var mail = ""
    var userTitle = ""
    var user_id = ""
    var user_photo = ""
    
    var parentView = ""
    
    @IBOutlet weak var myStackView: UIStackView!
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var eMailTxt: SearchTextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    
    
    //voice
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "tr-TUR"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        

        
        //keyboard için
        eMailTxt.delegate = self
        passwordTxt.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        /////
        
        
        
        
        print("parent")
        print(parentView)
        
        
        if UserDefaults.standard.value(forKey: "user_mail") != nil || UserDefaults.standard.value(forKey: "user_title") != nil {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "listenView") as! ListenViewController
            
            
            self.present(nextViewController, animated:true, completion:nil)
        }
        
        
        let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
        menuLeftNavigationController.leftSide = true
        SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
        
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        SideMenuManager.menuPresentMode = .menuSlideIn
        
        
        // autocomplete: https://github.com/apasccon/SearchTextField
        eMailTxt.inlineMode = true
        let array:[String] = UserDefaults.standard.stringArray(forKey: "user_mail_autocomplete_array") == nil ? [] : UserDefaults.standard.stringArray(forKey: "user_mail_autocomplete_array")!
        eMailTxt.filterStrings(array)
        // Do any additional setup after loading the view.
        
        
        
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
        btn2.addTarget(self, action: #selector(LoginViewController.btnVoice), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: btn2)
        
        
        let btnSearch = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(LoginViewController.btnSearch))
        btnSearch.tintColor = UIColor.white
        
        
        self.navigationItem.setRightBarButtonItems([item2,btnSearch], animated: true)
        
        let btn3 = UIButton(type: .custom)
        btn3.setImage(UIImage(named: "hamburger"), for: .normal)
        btn3.frame = CGRect(x: 0, y: 0, width: 35, height: 25)
        btn3.addTarget(self, action: #selector(LoginViewController.btnMenu), for: .touchUpInside)
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
        
        //textView.text = "Say something, I'm listening!"
        
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            //    microphoneButton.isEnabled = true
        } else {
            //    microphoneButton.isEnabled = false
        }
    }
    
    

    
    

    
    
    
    //keyboard için
    
    //bu method'u kaldırınca autocomplete çalışmıyor
    /*func textFieldShouldReturn(_ textField: UITextField) -> Bool {
     self.view.endEditing(true)
     return false
     }*/
    
    func keyboardWillShow(notification: NSNotification) {
        var translation:CGFloat = 0
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if passwordTxt.isEditing{
                translation = CGFloat(-keyboardSize.height)
            }else if passwordTxt.isEditing{
                translation = CGFloat(-keyboardSize.height / 3.8)
            }
        }
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if eMailTxt.isEditing{
                translation = CGFloat(-keyboardSize.height)
            }else if eMailTxt.isEditing{
                translation = CGFloat(-keyboardSize.height / 3.8)
            }
        }
        UIView.animate(withDuration: 0.2) {
            self.view.transform = CGAffineTransform(translationX: 0, y: translation)
        }
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.2) {
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    // Clicking the view (the container for UI components) removes the Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    ////////keyboard
    
    
    
    @IBAction func menuButtonClick(_ sender: UIBarButtonItem) {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        
        self.eMailTxt.resignFirstResponder()
        self.passwordTxt.resignFirstResponder()
        
        let urlString = "http://heybook.online/api.php"
        let parameters = ["request": "login",
                          "mail": "\(eMailTxt.text!)",
            "password": "\((passwordTxt.text!))"]
        
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                let json = JSON(data: response.data!)
                print("USER BİLGİLERİ")
                print(json)
                let  responses = json["response"].string!
                let total = json["data"].count
                self.mail = json["data"]["mail"].description
                self.userTitle = json["data"]["user_title"].description
                self.user_id = json["data"]["user_id"].description
                self.user_photo = json["data"]["photo"].description
               
                if (json["response"].description == "error"){
                    let tapAlert = UIAlertController(title: "", message: "\(json["message"].description)", preferredStyle: UIAlertControllerStyle.alert)
                    tapAlert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.destructive, handler: nil))
                    self.present(tapAlert, animated: true, completion: nil)
                }
                else {
                    // autocomplete string array
                    var array:[String] = UserDefaults.standard.stringArray(forKey: "user_mail_autocomplete_array") == nil ? [] : UserDefaults.standard.stringArray(forKey: "user_mail_autocomplete_array")!
                    array.append(self.mail)
                    UserDefaults.standard.set(array, forKey: "user_mail_autocomplete_array")
                    
                    UserDefaults.standard.setValue(self.mail, forKey: "user_mail")
                    UserDefaults.standard.setValue(self.userTitle, forKey: "user_title")
                    UserDefaults.standard.setValue(self.user_id, forKey: "user_id")
                    UserDefaults.standard.setValue(self.user_photo, forKey: "user_photo")
                    
                    //get downloaded books
                    // Get the document directory url
                    var mp3FileNames:[String] = []
                    var mp3Files:[URL] = []
                    var downloadedBooks:[Record] = []
                    let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    
                    do {
                        // Get the directory contents urls (including subfolders urls)
                        let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
                        print(directoryContents)
                        
                        // if you want to filter the directory contents you can do like this:
                        mp3Files = directoryContents.filter{ $0.pathExtension == "file" }
                        print("mp3 file urls:",mp3Files)
                        mp3FileNames = mp3Files.map{ $0.deletingPathExtension().lastPathComponent }
                        print("mp3 file list:", mp3FileNames)
                        
                        for i in 0..<mp3FileNames.count {
                            var fileNameArr = mp3FileNames[i].components(separatedBy: "_")
                            if fileNameArr[0] == self.user_id {
                                
                                print("BOOKID \(fileNameArr[0]) \(fileNameArr[1])")
                                
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
                                
                                let urlString = "http://heybook.online/api.php"
                                let parameters = ["request": "book",
                                                  "book_id": "\(fileNameArr[1])"]
                                
                                Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil).responseJSON {
                                    response in
                                    switch response.result {
                                    case .success:
                                        
                                        
                                        let json = JSON(data: response.data!)
                                        
                                        let total = json["data"].count
                                        print(total)
                                            book_id = json["data"]["book_id"].string!
                                            category_id = json["data"]["category_id"].string!
                                            publisher_id = json["data"]["publisher_id"].string!
                                            author_id = json["data"]["author_id"].string!
                                            narrator_id = json["data"]["narrator_id"].string!
                                            book_title = json["data"]["book_title"].string!
                                            desc = json["data"]["description"].string!
                                            price = json["data"]["price"].string!
                                            photo = json["data"]["photo"].string!
                                            thumb = json["data"]["thumb"].string!
                                            audio = json["data"]["audio"].string!
                                            duration = json["data"]["duration"].string!
                                            size = json["data"]["size"].string!
                                            demo = json["data"]["demo"].string!
                                            star = json["data"]["star"].string!
                                            category_title = json["data"]["category_title"].string!
                                            author_title = json["data"]["author_title"].string!
                                            publisher_title = json["data"]["publisher_title"].string!
                                            narrator_title = json["data"]["narrator_title"].string!
                                            
                                            let record = Record(book_id: book_id, category_id: category_id, publisher_id: publisher_id, author_id: author_id, narrator_id: narrator_id, book_title: book_title, desc: desc, price: price,  photo: photo, thumb: thumb, audio: audio, duration: duration, size: size,  demo: demo, star: star, category_title: category_title, author_title: author_title, publisher_title: publisher_title, narrator_title: narrator_title)
                                            
                                            downloadedBooks.append(record)
                                        
                                        print("downloaded! \(downloadedBooks[0].book_title)")
                                        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: downloadedBooks)
                                        UserDefaults.standard.set(encodedData, forKey: "book_record_downloaded")
                                        UserDefaults.standard.synchronize()
                                        
                                        print("RESPONSEBOOK \(response)")
                                        
                                        break
                                    case .failure(let error):
                                        print("ERRORRR!!!! \(error)")
                                        break
                                    }
                                }
                            }
                        }
                        
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                    
                    print("hebelehübele")
                    print(self.parentView)
                    
                    if(self.parentView == ""){
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "MainViewController")
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                    else if (self.parentView == "listen"){
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "listenView")
                        self.navigationController?.pushViewController(controller, animated: true)
                        
                    }
                    
                }
                
                break
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    func getBooksFromDatabase(mp3FileNames: [String]) -> [Record] {
        var downloadedBooks:[Record] = []
        
        
        return downloadedBooks
    }
    
    @IBAction func unwindToLogin(_ sender: UIStoryboardSegue) {
        
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
