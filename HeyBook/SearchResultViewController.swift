//
//  SearchResultViewController.swift
//  HeyBook
//
//  Created by Admin on 27/04/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit
import Speech
import SideMenu
import Alamofire

class SearchResultViewController: UIViewController, SFSpeechRecognizerDelegate,UICollectionViewDataSource, UICollectionViewDelegate {

    var message1 = 0
    var message2 = ""
    
    var records: [Record] = []
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    //voice
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "tr-TUR"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
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

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(message1)
        print(message2)
        
        
        let urlString = "http://heybook.online/api.php"
        
        Alamofire.request(urlString, method: .post, parameters: ["request": "books"],encoding: URLEncoding.httpBody, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                
                
                let json = JSON(data: response.data!)
               // print(json["data"][0]["book_title"].string!)
                
                
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
                    
                    
                    if (self.message1 == 1) {
                    if(record.book_title.lowercased() == self.message2.lowercased()){
                    
                    self.records.append(record)
                    
                    print("record: \(record.book_title)")
                    }
                    }
                    else if (self.message1 == 2) {
                        if(record.author_title.lowercased() == self.message2.lowercased()){
                            
                            self.records.append(record)
                            
                            print("record: \(record.book_title)")
                        }
                    }
                    if (self.message1 == 3) {
                        if(record.narrator_title.lowercased() == self.message2.lowercased()){
                            
                            self.records.append(record)
                            
                            print("record: \(record.book_title)")
                        }
                    }
                    
                }
                
                self.myCollectionView.reloadData()
         
                
                
                
                break
            case .failure(let error):
                
                print(error)
            }
        }
        

        
        
        if(self.records.isEmpty){
        
            let tapAlert = UIAlertController(title: "Mesaj", message: "Aradığınız kriterlere uygun kitap bulunamadı.", preferredStyle: UIAlertControllerStyle.alert)
            tapAlert.addAction(UIAlertAction(title: "Tekrar Ara", style: UIAlertActionStyle.destructive, handler: {(action: UIAlertAction!) in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "SearchViewController")
                self.navigationController?.pushViewController(controller, animated: true)
            }))
            self.present(tapAlert, animated: true, completion: nil)
            
        }
        
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
        
        let btn2 = UIButton(type: .custom)
        btn2.setImage(UIImage(named: "mikrofon"), for: .normal)
        btn2.frame = CGRect(x: 0, y: 0, width: 20, height: 30)
        btn2.addTarget(self, action: #selector(SearchResultViewController.btnVoice), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: btn2)
        
        
        let btnSearch = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(SearchResultViewController.btnSearch))
        btnSearch.tintColor = UIColor.black
        
        
        self.navigationItem.setRightBarButtonItems([item2,btnSearch], animated: true)
        
        let btn3 = UIButton(type: .custom)
        btn3.setImage(UIImage(named: "hamburger"), for: .normal)
        btn3.frame = CGRect(x: 0, y: 0, width: 35, height: 25)
        btn3.addTarget(self, action: #selector(SearchResultViewController.btnMenu), for: .touchUpInside)
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
        let record: Record
    
        
        
        record = records[indexPath.row]
        
        //Aschronized image loading !!!!
        URLSession.shared.dataTask(with: NSURL(string: record.photo)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                
                cell.authorName.text = record.author_title
                cell.bookName.text = record.book_title
                cell.duration.text = "\(record.price) TL"
                
                cell.bookImage.image = UIImage(data: data!)
                cell.leftView.backgroundColor = UIColor(hex: "50D2C2")
                
            })
            
        }).resume()
   
        
        
        return cell
    }
    
 
 


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "PlayBookViewController")
            self.navigationController?.pushViewController(controller, animated: true)
            
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: records[indexPath.row])
            UserDefaults.standard.set(encodedData, forKey: "book_record")
            UserDefaults.standard.synchronize()
       
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
