//
//  KitaplarimViewController.swift
//  HeyBook
//
//  Created by Admin on 03/04/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire
import Speech
import Foundation

class KitaplarimViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, SFSpeechRecognizerDelegate  {
    
    var records: [Record] = []
    var downloadedBooks: [Record] = []
    var downloadedBooksIndexes: [Int] = []
    
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
    
    var mp3FileNames:[String] = []
    var mp3Files:[URL] = []
    
    
    //voice
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "tr-TUR"))!
    
    var btn2 = UIButton(type: .custom)
    var alert = UIAlertView()
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        records = []
        
        let urlString = "http://heybook.online/api.php"
        let parameters = ["request": "user_books",
                          "user_id": "\(UserDefaults.standard.value(forKey: "user_id")!)"]
        
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                
                
                let json = JSON(data: response.data!)
                
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
                    
                }
                
                
                
                self.myCollectionView.reloadData()
                
                
                
                
                break
            case .failure(let error):
                self.records = self.downloadedBooks
                print("ERRORRR!!!! \(error)")
            }
            
            if let decoded = UserDefaults.standard.object(forKey: "book_record_downloaded"),
                let decodedBooks = NSKeyedUnarchiver.unarchiveObject(with: decoded as! Data) as? [Record] {
                self.downloadedBooks = decodedBooks
            }
            if !self.downloadedBooks.isEmpty {
                if self.records.isEmpty {
                    self.records = self.downloadedBooks
                }
                else {
                    let index:Int = 0
                    for i in 0..<self.records.count {
                        for j in 0..<self.downloadedBooks.count {
                            if self.records[i].book_id == self.downloadedBooks[j].book_id {
                                self.downloadedBooksIndexes.append(i)
                            }
                        }
                    }
                }
                print("downloaded \(self.downloadedBooks[0].book_title)")
                self.myCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        btn2.addTarget(self, action: #selector(KitaplarimViewController.btnVoice), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: btn2)
        
        
        let btnSearch = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(KitaplarimViewController.btnSearch))
        btnSearch.tintColor = UIColor.white
        
        
        self.navigationItem.setRightBarButtonItems([item2,btnSearch], animated: true)
        
        let btn3 = UIButton(type: .custom)
        btn3.setImage(UIImage(named: "hamburger"), for: .normal)
        btn3.frame = CGRect(x: 0, y: 0, width: 35, height: 25)
        btn3.addTarget(self, action: #selector(KitaplarimViewController.btnMenu), for: .touchUpInside)
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
                
                print(result?.bestTranscription.formattedString)  //9
                
                if(result?.bestTranscription.formattedString == "Vitrin"){
                    self.audioEngine.stop()
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "MainViewController")
                    self.navigationController?.pushViewController(controller, animated: true)
                    self.alert.dismiss(withClickedButtonIndex: self.alert.cancelButtonIndex, animated: true)
                }
                else if(result?.bestTranscription.formattedString == "Kitaplarım"){
                    self.audioEngine.stop()
                    recognitionRequest.endAudio()
                    self.alert.dismiss(withClickedButtonIndex: self.alert.cancelButtonIndex, animated: true)
                }
                else if(result?.bestTranscription.formattedString == "Arama"){
                    self.audioEngine.stop()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "SearchViewController")
                    self.navigationController?.pushViewController(controller, animated: true)
                    self.alert.dismiss(withClickedButtonIndex: self.alert.cancelButtonIndex, animated: true)
                }
                else if(result?.bestTranscription.formattedString == "Kategoriler"){
                    self.audioEngine.stop()
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "CatagoriesViewController")
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
        
        // textView.text = "Say something, I'm listening!"
        
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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    func getIndexPathForSelectedCell() -> IndexPath? {
        var indexPath: IndexPath?
        
        if myCollectionView.indexPathsForSelectedItems!.count > 0 {
            indexPath = myCollectionView.indexPathsForSelectedItems![0] as IndexPath
        }
        
        return indexPath
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return records.count
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        //return mDataSource.groups.count
        return 1
    }
    
    // For each cell setting the data
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CustomKitaplarimCollectionViewCell
        
        //let records: [Record] = mDataSource.recordsInSection(indexPath.section)
        var record: Record
        record = records[indexPath.row]
        
        if downloadedBooksIndexes.contains(indexPath.row) {
            cell.bookName.textColor = UIColor.green
            //indirilmiş göstergesi
        }
        else {
            cell.bookName.textColor = UIColor.black
        }
        
        //Aschronized image loading !!!!
        print(record.photo)
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
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! HeaderKitaplarimCollectionReusableView
        
            headerView.header.text = ""
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: records[indexPath.row])
            UserDefaults.standard.set(encodedData, forKey: "book_record_play")
            UserDefaults.standard.synchronize()
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
