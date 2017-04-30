//
//  SettingsViewController.swift
//  HeyBook
//
//  Created by Admin on 08/03/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire
import Speech

class SettingsViewController: UIViewController,UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, SFSpeechRecognizerDelegate {
    
    @IBOutlet weak var userTitleLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    
    
    @IBOutlet weak var PassTxt: UITextField!
    @IBOutlet weak var newPassTxt: UITextField!
    @IBOutlet weak var viewLoggedIn: UIView!
    @IBOutlet weak var viewNotLoggedIn: UIView!
    @IBOutlet weak var newPassTxt2: UITextField!
    @IBOutlet weak var disableSwitch: UISwitch!
    @IBOutlet weak var subscribeSwitch: UISwitch!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    //voice
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "tr-TUR"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    
    var pickedImagePath: NSURL?
    var pickedImageData: NSData?
    
    var isImageFromLibrary:Bool = false
    
    var localPath: String?
    
    var mail = ""
    var userTitle = ""
    var photo = ""
    var profileImageTransform:CGAffineTransform?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userTitleLabel.text =  UserDefaults.standard.value(forKey: "user_title") as? String
        emailLabel.text = UserDefaults.standard.value(forKey: "user_mail") as? String
       // photo = (UserDefaults.standard.value(forKey: "user_photo") as? String)!
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2;
//        profileImage.contentMode = .scaleToFill
//        profileImage.clipsToBounds = true
        
        //Decode
        if let data = UserDefaults.standard.object(forKey: "user_photo") as? NSData {
            profileImage.image = UIImage(data: data as Data)
        }
        else {
            profileImage.image = UIImage(named: "logo")
        }
  
        
//        print("http://heybook.online/\(photo)")
//        print(UserDefaults.standard.value(forKey: "user_photo") as? String)
//        
//        //Aschronized image loading !!!!
//        if(photo == "img/users/no-photo.jpg"){
//            self.profileImage.image = UIImage(named: "logo")
//        }
//        else if !isImageFromLibrary {
//            print("elsejjuu")
//            URLSession.shared.dataTask(with: NSURL(string: "http://heybook.online/\(photo)")! as URL, completionHandler: { (data, response, error) -> Void in
//                if error != nil {
//                    print(error)
//                    return
//                }
//                DispatchQueue.main.async(execute: { () -> Void in
//                    self.profileImage.image = self.imageRotatedByDegrees(oldImage: UIImage(data: data!)!, deg: 90)
//                    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
//                    self.profileImage.contentMode = .scaleAspectFill
//                    self.profileImage.clipsToBounds = true
//                    //self.profileImage.transform = self.profileImageTransform!
//                })
//                
//            }).resume()
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isImageFromLibrary = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewLoggedIn.isHidden = false
        viewNotLoggedIn.isHidden = false
        
        if(UserDefaults.standard.value(forKey: "user_mail") == nil && UserDefaults.standard.value(forKey: "user_title") == nil){
            
            viewLoggedIn.isHidden = true
            viewNotLoggedIn.isHidden = false
        }
        else {
            
            viewLoggedIn.isHidden = false
            viewNotLoggedIn.isHidden = true
            
            
            
           
        }
        
        //keyboard için
        newPassTxt.delegate = self
        newPassTxt2.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        
        
        //////keyboard
        
        
        let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
        menuLeftNavigationController.leftSide = true
        SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
        
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        SideMenuManager.menuPresentMode = .menuSlideIn
        
        
        print("ayarlar ekranındayım")
        
        print(mail)
        print(userTitle)
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
        btn2.setImage(UIImage(named: "mikrofon"), for: .normal)
        btn2.frame = CGRect(x: 0, y: 0, width: 20, height: 30)
        btn2.addTarget(self, action: #selector(SettingsViewController.btnVoice), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: btn2)
        
        
        let btnSearch = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(SettingsViewController.btnSearch))
        btnSearch.tintColor = UIColor.black
        
        
        self.navigationItem.setRightBarButtonItems([item2,btnSearch], animated: true)
        
        let btn3 = UIButton(type: .custom)
        btn3.setImage(UIImage(named: "hamburger"), for: .normal)
        btn3.frame = CGRect(x: 0, y: 0, width: 35, height: 25)
        btn3.addTarget(self, action: #selector(SettingsViewController.btnMenu), for: .touchUpInside)
        btn3.tintColor = UIColor.black
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func keyboardWillShow(notification: NSNotification) {
        var translation:CGFloat = 0
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if newPassTxt.isEditing{
                translation = CGFloat(-keyboardSize.height)
            }else if newPassTxt.isEditing{
                translation = CGFloat(-keyboardSize.height / 3.8)
            }
        }
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if newPassTxt2.isEditing{
                translation = CGFloat(-keyboardSize.height)
            }else if newPassTxt2.isEditing{
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
    
    ////////keyboard  oldPassTxt
    
    
    
    
    
    
    @IBAction func buttonUpdate(_ sender: UIButton) {
        self.newPassTxt.resignFirstResponder()
        self.newPassTxt2.resignFirstResponder()
        print(UserDefaults.standard.value(forKey: "user_title")!)
        print(subscribeSwitch.isOn)
        print(disableSwitch.isOn)
        
//        let originalString = userTitleLabel.text!
//        // let escapedString = originalString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
//        
//        let subscribe:Int = subscribeSwitch.isOn == true ? 1 : 0
//        let disabled:Int = disableSwitch.isOn == true ? 1 : 0
//        
//        let urlString = "http://heybook.online/api.php"
//        let parameters = ["request": "settings",
//                          "user_id": "\(UserDefaults.standard.value(forKey: "user_id")!)",
//            "user_title": "\(originalString)",
//            "mail": "\(self.emailLabel.text!)",
//            "password": "\(self.PassTxt.text!)",
//            "new-password": "\(self.newPassTxt.text!)",
//            "new-password-again": "\(self.newPassTxt2.text!)",
//            "subscribe": "\(subscribe)",
//            "disabled": "\(disabled)"]
//        
//        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil)
//            .responseJSON {
//                response in
//                switch response.result {
//                case .success:
//                    let json = JSON(data: response.data!)
//                    print(json)
//                    let registerResponse = json["response"].string!
//                    print(registerResponse)
//                    
//                    
//                    let tapAlert = UIAlertController(title: registerResponse, message: json["message"].string!, preferredStyle: UIAlertControllerStyle.alert)
//                    tapAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
//                    self.present(tapAlert, animated: true, completion: nil)
//                    
//                    self.PassTxt.text = ""
//                    self.newPassTxt.text = ""
//                    self.newPassTxt2.text = ""
//                    
//                    UserDefaults.standard.setValue(self.emailLabel.text!, forKey: "user_mail")
//                    UserDefaults.standard.setValue(self.userTitleLabel.text!, forKey: "user_title")
//                    break
//                case .failure(let error):
//                    
//                    print("NABIYON: \(error)")
//                }
//        }
    
        myImageUploadRequest()
        
//        
//        //2
//        let imageData = UIImageJPEGRepresentation(profileImage.image!, 1)
//        if(imageData == nil ) { return }
//        let uploadScriptUrl = NSURL(string:"http://heybook.online/api_test.php")
//        var request = NSMutableURLRequest(url: uploadScriptUrl! as URL)
//        request.httpMethod = "POST"
//        request.setValue("Keep-Alive", forHTTPHeaderField: "Connection")
//        var configuration = URLSessionConfiguration.default
//        let session = URLSession(configuration: configuration, delegate: self as? URLSessionDelegate, delegateQueue: OperationQueue.main)
//        let task = session.uploadTask(with: request as URLRequest, from: imageData!)
//        task.resume()
//        //2
//        
        
        
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//            multipartFormData.append(UIImageJPEGRepresentation(self.profileImage.image!, 0.5)!, withName: "pic", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
//            for (key, value) in parameters {
//                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//            }
//            
//        }, to:"http://heybook.online/api_test.php")
//        { (result) in
//            switch result {
//            case .success(let upload, _, _):
//                
//                upload.uploadProgress(closure: { (Progress) in
//                    print("Upload Progress: \(Progress.fractionCompleted)")
//                })
//                
//                upload.responseJSON { response in
//                    //self.delegate?.showSuccessAlert()
//                    print(response.request)  // original URL request
//                    print(response.response) // URL response
//                    print(response.data)     // server data
//                    print(response.result)   // result of response serialization
//                    //                        self.showSuccesAlert()
//                    //self.removeImage("frame", fileExtension: "txt")
//                    if let JSON = response.result.value {
//                        print("JSON: \(JSON)")
//                    }
//                }
//                
//            case .failure(let encodingError):
//                //self.delegate?.showFailAlert()
//                print(encodingError)
//            }
//            
//        }
        
   
    }
    var alert = UIAlertView()
    func myImageUploadRequest()
    {
        
      alert = UIAlertView(title: "Mesaj", message: "İşleminiz yapılırken lütfen bekleyiniz...", delegate: nil, cancelButtonTitle: nil);
        
        var loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x:50, y:10, width:37, height:37)) as UIActivityIndicatorView
        loadingIndicator.center = self.view.center;
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.setValue(loadingIndicator, forKey: "accessoryView")
        
        loadingIndicator.startAnimating()
        
        alert.show();
        
        let myUrl = NSURL(string: "http://heybook.online/api.php");
        //let myUrl = NSURL(string: "http://www.boredwear.com/utils/postImage.php");
        
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        let originalString = userTitleLabel.text!
        // let escapedString = originalString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        let subscribe:Int = subscribeSwitch.isOn == true ? 1 : 0
        let disabled:Int = disableSwitch.isOn == true ? 1 : 0
        let param = [
            "request": "settings",
            "user_id": "\(UserDefaults.standard.value(forKey: "user_id")!)",
            "user_title": "\(originalString)",
            "mail": "\(self.emailLabel.text!)",
            "password": "\(self.PassTxt.text!)",
            "new-password": "\(self.newPassTxt.text!)",
            "new-password-again": "\(self.newPassTxt2.text!)",
            "subscribe": "\(subscribe)",
            "disabled": "\(disabled)",
            "photo"  : "Sergey",
            
        ]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        let imageData = UIImageJPEGRepresentation(self.profileImage.image!, 1)
        
        if(imageData==nil)  { return; }
        
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            // You can print out response object
            print("******* response = \(response)")
            
            // Print out reponse body
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("****** response data = \(responseString!)")
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                let jsonMessage = JSON(data: data!)
                print("jjjsssooonnn")
                print(jsonMessage["message"].description)
               
               
                self.alert.dismiss(withClickedButtonIndex: self.alert.cancelButtonIndex, animated: true)
                let tapAlert = UIAlertController(title: "Mesaj", message: jsonMessage["message"].description, preferredStyle: UIAlertControllerStyle.alert)
                tapAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
                self.present(tapAlert, animated: true, completion: nil)
                
                self.PassTxt.text = ""
                self.newPassTxt.text = ""
                self.newPassTxt2.text = ""
                
                UserDefaults.standard.setValue(self.emailLabel.text!, forKey: "user_mail")
                UserDefaults.standard.setValue(self.userTitleLabel.text!, forKey: "user_title")
                self.photo = "img/users/\((UserDefaults.standard.value(forKey: "user_id") as! String)).jpg"
                UserDefaults.standard.setValue(self.photo, forKey: "user_photo")
                
                
                DispatchQueue.main.async(execute: {
                 print("aa")
                });
                
            }catch
            {
                print(error)
            }
            
        }
        
        task.resume()
    }
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = "user-profile.jpg"
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    @IBAction func goLoginPage(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "loginView")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
 
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = imageRotatedByDegrees(oldImage: info[UIImagePickerControllerOriginalImage] as! UIImage , deg: 90)
        
        profileImage.image = selectedImage
      
        
        let imageData : NSData = UIImagePNGRepresentation(selectedImage)! as NSData
        
        //Save
        UserDefaults.standard.set(imageData, forKey: "user_photo")
        
//        
//        //Decode
//        let data = UserDefaults.standard.object(forKey: "user_photo") as! NSData
//        profileImage.image = UIImage(data: data as Data)
//        
        dismiss(animated: true, completion: nil)
    }
    
    func imageRotatedByDegrees(oldImage: UIImage, deg degrees: CGFloat) -> UIImage {
        //Calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: oldImage.size.width, height: oldImage.size.height))
        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        //Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        //Rotate the image context
        bitmap.rotate(by: (degrees * CGFloat.pi / 180))
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(oldImage.cgImage!, in: CGRect(x: -oldImage.size.width / 2, y: -oldImage.size.height / 2, width: oldImage.size.width, height: oldImage.size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    @IBAction func photoAddButton(_ sender: Any) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        
        present(controller, animated: true, completion: nil)
        
      
        
        
        
//        guard let path = localPath else {
//            return
//        }
//        
//        Alamofire.upload(.POST, "http://heybook.online/api_test.php"
//            , multipartFormData: { formData in
//                let filePath = NSURL(fileURLWithPath: path)
//                formData.appendBodyPart(fileURL: filePath, name: "upload")
//                formData.appendBodyPart(data: "Alamofire".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "test")
//        }, encodingCompletion: { encodingResult in
//            switch encodingResult {
//            case .Success:
//                print("SUCCESS")
//            case .Failure(let error):
//                print(error)
//            }
//        })
//    
//    
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
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
}
extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
//extension SettingsViewController{
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
//            return
//        }
//        
//        
//        
//        profileImage.image = image
//        
//        
//        let documentDirectory: NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
//        
//        let imageName = "temp"
//        
//        let imagePath = documentDirectory.appendingPathComponent(imageName)
//        
//        if let data = UIImageJPEGRepresentation(image, 80) {
//            do {
//                try data.write(to: URL(fileURLWithPath: imagePath), options: .atomic)
//            } catch {
//                print(error)
//            }
//        }
//
//        localPath = imagePath
//        
//        dismiss(animated: true, completion: {
//            
//        })
//    }
//    
//    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
//}





