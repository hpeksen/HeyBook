//
//  NewPasswordViewController.swift
//  HeyBook
//
//  Created by Admin on 13/03/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit
import Alamofire
import SearchTextField
import SideMenu
import Speech

class NewPasswordViewController: UIViewController,UITextFieldDelegate, SFSpeechRecognizerDelegate {

    @IBOutlet weak var myTextField: SearchTextField!
    var newPasswordResponse = ""
    var message = ""
    
    
    //voice
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "tr-TUR"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    var btn2 = UIButton(type: .custom)
    var alert = UIAlertView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTextField.delegate = self
        
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        

        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
              // Do any additional setup after loading the view.
        // autocomplete: https://github.com/apasccon/SearchTextField
        myTextField.inlineMode = true
        let array:[String] = UserDefaults.standard.stringArray(forKey: "user_mail_autocomplete_array") == nil ? [] : UserDefaults.standard.stringArray(forKey: "user_mail_autocomplete_array")!
        myTextField.filterStrings(array)
        
        
        
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
        
        //Bar Buttonları
        
        btn2.setImage(UIImage(named: "mikrofon_beyaz"), for: .normal)
        btn2.frame = CGRect(x: 0, y: 0, width: 20, height: 30)
        btn2.addTarget(self, action: #selector(NewPasswordViewController.btnVoice), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: btn2)
        
        
        let btnSearch = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(NewPasswordViewController.btnSearch))
        btnSearch.tintColor = UIColor.white
        
        
        self.navigationItem.setRightBarButtonItems([item2,btnSearch], animated: true)
        
        let btn3 = UIButton(type: .custom)
        btn3.setImage(UIImage(named: "hamburger"), for: .normal)
        btn3.frame = CGRect(x: 0, y: 0, width: 35, height: 25)
        btn3.addTarget(self, action: #selector(NewPasswordViewController.btnMenu), for: .touchUpInside)
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
                    self.alert.dismiss(withClickedButtonIndex: self.alert.cancelButtonIndex, animated: true)
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "MainViewController")
                    self.navigationController?.pushViewController(controller, animated: true)
                    
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
                        self.present(tapAlert, animated: true, completion: {
                            recognitionRequest.endAudio()
                            
                        })
                        
                        
                    }
                }
                else if(result?.bestTranscription.formattedString == "Kategoriler"){
                    self.audioEngine.stop()
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "CatagoriesViewController")
                    self.navigationController?.pushViewController(controller, animated: true)
                    self.alert.dismiss(withClickedButtonIndex: self.alert.cancelButtonIndex, animated: true)
                }
                else if(result?.bestTranscription.formattedString.lowercased() == "arama"){
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
                        self.present(tapAlert, animated: true, completion: {
                            recognitionRequest.endAudio()
                            
                        })
                        
                        
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
                        self.present(tapAlert, animated: true, completion: {
                            recognitionRequest.endAudio()
                            
                        })
                        
                        
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
                        self.present(tapAlert, animated: true, completion: {
                            recognitionRequest.endAudio()
                        })
                        
                        
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
    
    

    
    
    


    //keyboard için
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.view.endEditing(true)
//        return false
//    }
    
   
    func keyboardWillShow(notification: NSNotification) {
        var translation:CGFloat = 0
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if myTextField.isEditing{
                translation = CGFloat(-keyboardSize.height)
            }else if myTextField.isEditing{
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
    
//keyboard için
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func newPasswordBtn(_ sender: Any) {
        let urlString = "http://heybook.online/api.php"
        let parameters = ["request": "forgot",
                          "mail": "\(myTextField.text!)"]
        
        
        var alert = UIAlertView(title: "Mesaj", message: "İşleminiz yapılırken lütfen bekleyiniz...", delegate: nil, cancelButtonTitle: nil);
        
        var loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x:50, y:10, width:37, height:37)) as UIActivityIndicatorView
        loadingIndicator.center = self.view.center;
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.setValue(loadingIndicator, forKey: "accessoryView")
        
        loadingIndicator.startAnimating()
        
        alert.show();
        
        

        
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                
                alert.dismiss(withClickedButtonIndex: alert.cancelButtonIndex, animated: true)
                let json = JSON(data: response.data!)
                print(json)
                self.newPasswordResponse = json["response"].string!
                self.message = json["message"].description
                print(self.message)
                print(self.newPasswordResponse)
                
                let longPressAlert = UIAlertController(title: "", message: "\(json["message"].description)", preferredStyle: UIAlertControllerStyle.alert)
                longPressAlert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.destructive, handler: nil))
                self.present(longPressAlert, animated: true, completion: nil)
                
                
                
                
                break
            case .failure(let error):
                alert.dismiss(withClickedButtonIndex: alert.cancelButtonIndex, animated: true)
                let tapAlert = UIAlertController(title: "", message: "Lütfen internet bağlantınızı kontrol ediniz.", preferredStyle: UIAlertControllerStyle.alert)
                tapAlert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.destructive, handler: nil))
                self.present(tapAlert, animated: true, completion: nil)
                print(error)
            }
        }
        
       
   
        
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
  
    
//    // Delegate to remove the keyboard (When the return key is pressed the keyboard will disappear)
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        
//        return true
//    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
