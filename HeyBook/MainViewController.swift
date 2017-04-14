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
class MainViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, iCarouselDelegate,iCarouselDataSource  {
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
    
    let mSearchController = UISearchController(searchResultsController: nil)
    var isSearch=false
    var originalNavigationView: UIView?
    var searchedRecords: [Record] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        if records.isEmpty {
            let urlString = "http://heybook.online/api.php"
            
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
                        
                        let record: Record = Record(book_id: self.book_id, category_id: self.category_id, publisher_id: self.publisher_id, author_id: self.author_id, narrator_id: self.narrator_id, book_title: self.book_title, desc: self.desc, price: self.price,  photo: self.photo, thumb: self.thumb, audio: self.audio, duration: self.duration, size: self.size,  demo: self.demo, star: self.star, category_title: self.category_title, author_title: self.author_title, publisher_title: self.publisher_title)
                        
                        
                        self.records.append(record)
                        
                        print("record: \(record.book_title)")
                        
                    }
                    
                    self.myCollectionView.reloadData()
                    self.carouselView.reloadData()
                    
                    
                    
                    
                    break
                case .failure(let error):
                    
                    print(error)
                }
            }
            
            
            
        }
        
        
        
        
        
        
        
        
        
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
    
    
    
    @IBAction func menuButtonClick(_ sender: UIBarButtonItem) {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
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
        
        
        
        
        if((sender.titleLabel?.text)! == "Vurun Kahpeye"){
            let record: Record
            record = records[0]
            
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: record)
            UserDefaults.standard.set(encodedData, forKey: "book_record")
            UserDefaults.standard.synchronize()
            
            
            
        }
            
        else if((sender.titleLabel?.text)! == "Serenad"){
            let record: Record
            record = records[1]
            
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: record)
            UserDefaults.standard.set(encodedData, forKey: "book_record")
            UserDefaults.standard.synchronize()
            
            
            
        }
            
        else if((sender.titleLabel?.text)! == "Bakele"){
            let record: Record
            record = records[2]
            
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: record)
            UserDefaults.standard.set(encodedData, forKey: "book_record")
            UserDefaults.standard.synchronize()
            
            
            
        }
            
        else if((sender.titleLabel?.text)! == "Aşk"){
            let record: Record
            record = records[3]
            
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: record)
            UserDefaults.standard.set(encodedData, forKey: "book_record")
            UserDefaults.standard.synchronize()
            
            
            
        }
            
        else if((sender.titleLabel?.text)! == "Dahi Diktatör"){
            let record: Record
            record = records[4]
            
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: record)
            UserDefaults.standard.set(encodedData, forKey: "book_record")
            UserDefaults.standard.synchronize()
            
            
            
        }
            
        else if((sender.titleLabel?.text)! == "Kadın Olmak"){
            let record: Record
            record = records[5]
            
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: record)
            UserDefaults.standard.set(encodedData, forKey: "book_record")
            UserDefaults.standard.synchronize()
            
            
            
        }
            
        else if((sender.titleLabel?.text)! == "Engereğin Gözü"){
            let record: Record
            record = records[6]
            
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: record)
            UserDefaults.standard.set(encodedData, forKey: "book_record")
            UserDefaults.standard.synchronize()
            
            
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
                cell.duration.text = "\(h) sa \(m) dk"
                
                
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

