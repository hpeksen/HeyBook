//
//  SepetViewController.swift
//  HeyBook
//
//  Created by Admin on 27/03/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire
import Speech

class SepetViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, SFSpeechRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var kartBilgileriView: UIView!
    @IBOutlet weak var sepetView: UIView!
    @IBOutlet weak var onayView: UIView!
    @IBOutlet weak var onaylandıView: UIView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var kartNameSurname: UITextField!
    @IBOutlet weak var kartNumarası: UITextField!
    @IBOutlet weak var cvcNumarası: UITextField!
    @IBOutlet weak var dOnaySifreTextField: UITextField!
    
    
    var timer = Timer()
     var timer2 = Timer()
    let timeInterval : TimeInterval = 0.1
     var timeCount : TimeInterval = 180.0
    
     var odemeWait : TimeInterval = 3.0
     var onayWait : TimeInterval = 3.0
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    var records: [Record] = []
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
    
    
    
    //voice
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "tr-TUR"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    
   var mounth = "01"
    var year = "2017"
    @IBOutlet weak var monthPickerView: UIPickerView!
    @IBOutlet weak var yearPickerView: UIPickerView!
    @IBOutlet weak var CreditCardNameSurname: UITextField!
    @IBOutlet weak var CreditCardNo: UITextField!
    var monthArr = ["01","02","03", "04","05","06","07","08", "09","10","11","12"]
    var yearArr = ["2017","2018", "2019", "2020"]
    
    var totalPrice:Double = 0.0
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sepetView.isHidden = false
        onayView.isHidden = true
        kartBilgileriView.isHidden = true
        onaylandıView.isHidden = true
        
        self.kartNumarası.text = ""
        self.kartNameSurname.text = ""
        self.cvcNumarası.text = ""
        self.dOnaySifreTextField.text = ""
        timeCount = 180.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.kartNameSurname.resignFirstResponder()
        self.kartNumarası.resignFirstResponder()
         self.cvcNumarası.resignFirstResponder()
        
        
        
        
        let urlString = "http://heybook.online/api.php"
        let parameters = ["request": "user_cart",
                          "user_id": "\(UserDefaults.standard.value(forKey: "user_id")!)"]
        
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil)
            .responseJSON {
            response in
            switch response.result {
            case .success:
                
                
                let json = JSON(data: response.data!)
                
                let total = json["data"].count
              //  print("json \(total)")
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
                    
                    self.totalPrice += Double(record.price)!
                    
                }
                                
                self.totalPriceLabel.text = "\(String(format: "%.2f", self.totalPrice)) TL"
                self.myCollectionView.reloadData()
                
                
                
                
                break
            case .failure(let error):
                
                print("NABIYON:")
            }
        }

        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
        menuLeftNavigationController.leftSide = true
        SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
        
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        SideMenuManager.menuPresentMode = .menuSlideIn
        
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
        
        totalPriceLabel.text = "\(String(format: "%.2f", totalPrice)) TL"
        
        
        
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
        btn2.addTarget(self, action: #selector(SepetViewController.btnVoice), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: btn2)
        
        
        let btnSearch = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(SepetViewController.btnSearch))
        btnSearch.tintColor = UIColor.white
        
        
        self.navigationItem.setRightBarButtonItems([item2,btnSearch], animated: true)
        
        let btn3 = UIButton(type: .custom)
        btn3.setImage(UIImage(named: "hamburger"), for: .normal)
        btn3.frame = CGRect(x: 0, y: 0, width: 35, height: 25)
        btn3.addTarget(self, action: #selector(SepetViewController.btnMenu), for: .touchUpInside)
        btn3.tintColor = UIColor.white
        let item3 = UIBarButtonItem(customView: btn3)
        self.navigationItem.setLeftBarButton(item3, animated: true)
        
        
    }
    
  
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var countrows : Int = monthArr.count
        if pickerView == yearPickerView {
            
            countrows = self.yearArr.count
        }
        
        return countrows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == monthPickerView {
            
            let titleRow = monthArr[row]
            
            return titleRow
            
        }
            
        else if pickerView == yearPickerView{
            let titleRow = yearArr[row]
            
            return titleRow
        }
        
        return ""
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == monthPickerView {
            mounth = self.monthArr[row]
        }
            
        else if pickerView == yearPickerView{
            year = self.yearArr[row]
            
        }
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
    

    

  
    
    func getIndexPathForSelectedCell() -> IndexPath? {
        var indexPath: IndexPath?
        
        if myCollectionView.indexPathsForSelectedItems!.count > 0 {
            indexPath = myCollectionView.indexPathsForSelectedItems![0] as IndexPath
        }
        
        return indexPath
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // print("records.count")
       // print(records.count)
        if !records.isEmpty {
            return records.count
        }
        return 0
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        //return mDataSource.groups.count
        return 1
    }
    
    // For each cell setting the data
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CustomSepetCollectionViewCell
        
        //let records: [Record] = mDataSource.recordsInSection(indexPath.section)
        let record: Record
        record = records[indexPath.row]
        
        //Aschronized image loading !!!!
        URLSession.shared.dataTask(with: NSURL(string: record.photo)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
           //     print(error)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                
                cell.bookName.text = record.book_title
                cell.bookImage.image = UIImage(data: data!)
                cell.bookPrice.text = record.price
               
                cell.deleteBookFromFav.tag = Int(record.book_id)!
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
    

    
    @IBAction func deleteBookFromSepet(sender : UIButton){
    
    let index = sender.tag
        print("book Id sini bastırıyom: ")
       // print(index)
        
        
        
        let urlString = "http://heybook.online/api.php"
        let parameters = ["request": "user_cart-delete",
                          "user_id": "\(UserDefaults.standard.value(forKey: "user_id")!)",
                        "book_id": "\(index)"]
        
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                
                
                let json = JSON(data: response.data!)
                print(json)
                
                for i in 0..<self.records.count {
                    if (Int(self.records[i].book_id) == index) {
                        self.totalPrice -= Double(self.records[i].price)!
                        self.records.remove(at: i)
                        break
                    }
                }
                self.totalPriceLabel.text = "\(String(format: "%.2f", self.totalPrice)) TL"
                self.myCollectionView.reloadData()
                
                
                
                
                break
            case .failure(let error):
                
                print(error)
            }
        }
    
    }
    
    @IBAction func odemeYapButton(_ sender: Any) {
        
        if(records.isEmpty) {
            let longPressAlert = UIAlertController(title: "Mesaj", message: "Sepetinizde kitap bulunmamaktadır.", preferredStyle: UIAlertControllerStyle.alert)
            longPressAlert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.destructive, handler: nil))
            self.present(longPressAlert, animated: true, completion: nil)
        
        }
        else {
        
        kartBilgileriView.isHidden = false
        sepetView.isHidden = true
         onayView.isHidden = true
        onaylandıView.isHidden = true
        }
        
    }
    var alert  = UIAlertView()
    @IBAction func odemeyiOnaylaButton(_ sender: Any) {
      
        if((kartNameSurname.text?.isEmpty)! || (kartNumarası.text?.isEmpty)! || (cvcNumarası.text?.isEmpty)! ){
            let longPressAlert = UIAlertController(title: "Hata", message: "Lütfen bütün alanları doldurunuz!", preferredStyle: UIAlertControllerStyle.alert)
            longPressAlert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.destructive, handler: nil))
            self.present(longPressAlert, animated: true, completion: nil)
            
        }
        else {
             alert = UIAlertView(title: "Mesaj", message: "İşleminiz yapılırken lütfen bekleyiniz...", delegate: nil, cancelButtonTitle: nil);
            
            var loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x:50, y:10, width:37, height:37)) as UIActivityIndicatorView
            loadingIndicator.center = self.view.center;
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            loadingIndicator.startAnimating();
            
            alert.setValue(loadingIndicator, forKey: "accessoryView")
            
            loadingIndicator.startAnimating()
            
            alert.show();
            
            
            if !timer2.isValid { // Prevent more than one timer on the thread
                timer2 = Timer.scheduledTimer(timeInterval: timeInterval,
                                             target: self,
                                             selector: #selector(SepetViewController.timerDidEnd2),
                                             userInfo: nil,
                                             repeats: true) // Repeating timer
                
                
            }
            
          
       
            
        
        }
    }
    func timeToString(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = time - Double(minutes) * 60
        return String(format:"%02d:%02d", minutes, Int(seconds))
    }
    func timerDidEnd2(){
        odemeWait -= timeInterval
        if (odemeWait <= 0 ){  // Test for target time reached
            onayView.isHidden = false
            kartBilgileriView.isHidden = true
            sepetView.isHidden = true
            onaylandıView.isHidden = true
            
            timer2.invalidate()
            
            if !timer.isValid { // Prevent more than one timer on the thread
                timeLabel.text = timeToString(timeCount) // Change to show clock instead of message
                timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                             target: self,
                                             selector: #selector(SepetViewController.timerDidEnd),
                                             userInfo: nil,
                                             repeats: true) // Repeating timer
                
                
            }
            
            self.alert.dismiss(withClickedButtonIndex: self.alert.cancelButtonIndex, animated: true)
        }
        
        
    }
    func timerDidEnd3(){
        onayWait -= timeInterval
        if (onayWait <= 0 ){  // Test for target time reached
            self.alert.dismiss(withClickedButtonIndex: self.alert.cancelButtonIndex, animated: true)
            self.onaylandıView.isHidden = false
            self.onayView.isHidden = true
            self.kartBilgileriView.isHidden = true
            self.sepetView.isHidden = true
            //  print(response)
            self.totalPriceLabel.text = "0.00 TL"
            self.records = []
            self.myCollectionView.reloadData()
            
            timer2.invalidate()
            
           
        }
        
        
    }
    func timerDidEnd(){
        timeCount -= timeInterval
        if (timeCount <= 0 &&  onayView.isHidden == false){  // Test for target time reached
            let longPressAlert = UIAlertController(title: "Hata", message: "Süreniz doldu", preferredStyle: UIAlertControllerStyle.alert)
            longPressAlert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.destructive, handler: nil))
            self.present(longPressAlert, animated: true, completion: nil)
            timer.invalidate()
        }
        else {
            timeLabel.text = timeToString(timeCount)
    
        }
    }
    @IBAction func dOnaylamaButton(_ sender: Any) {
        
        if (!(dOnaySifreTextField.text?.isEmpty)!){
       
            print("user id:")
            print(UserDefaults.standard.value(forKey: "user_id")!)
            let urlString = "http://heybook.online/api.php"
            let parameters = ["request": "user_cart-pay",
                              "user_id": "\(UserDefaults.standard.value(forKey: "user_id")!)",
                                "payment_hash": "ok"]
            alert = UIAlertView(title: "Mesaj", message: "İşleminiz yapılırken lütfen bekleyiniz...", delegate: nil, cancelButtonTitle: nil);
            
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
                    if !self.timer2.isValid { // Prevent more than one timer on the thread
                        self.timer2 = Timer.scheduledTimer(timeInterval: self.timeInterval,
                                                     target: self,
                                                     selector: #selector(SepetViewController.timerDidEnd3),
                                                     userInfo: nil,
                                                     repeats: true) // Repeating timer
                        
                        
                    }
                    
                    
                    
                    break
                case .failure(let error):
                    
                    print(error)
                }
            }
//            
//            var alert: UIAlertView = UIAlertView(title: "Meaj", message: "İşleminiz yapılırken lütfen bekleyiniz...", delegate: nil, cancelButtonTitle: nil);
//            
//            
//            var loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x:50, y:10, width:37, height:37)) as UIActivityIndicatorView
//            loadingIndicator.center = self.view.center;
//            loadingIndicator.hidesWhenStopped = true
//            loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
//            loadingIndicator.startAnimating();
//            
//            alert.setValue(loadingIndicator, forKey: "accessoryView")
//            loadingIndicator.startAnimating()
//            
//            alert.show();

            
        }
        else {
            let longPressAlert = UIAlertController(title: "Hata", message: "Lütfen 3D güvenlik şifrenizi giriniz!", preferredStyle: UIAlertControllerStyle.alert)
            longPressAlert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.destructive, handler: nil))
            self.present(longPressAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func goToKitaplarim(_ sender: Any) {
        sepetView.isHidden = false
        onayView.isHidden = true
        kartBilgileriView.isHidden = true
        onaylandıView.isHidden = true
        self.kartNumarası.text = ""
        self.kartNameSurname.text = ""
        self.cvcNumarası.text = ""

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "KitaplarimViewController")
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
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

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
