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

class KitaplarimViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {

    var records: [Record] = []
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                
                print(error)
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func menuButtonClick(_ sender: UIBarButtonItem) {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
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
        
        if(indexPath.section == 0 )
        {
            headerView.header.text = "ROMAN"
        }
        
        if(indexPath.section == 1 )
        {
            headerView.header.text = "KİŞİSEL GELİŞİM"
        }
        
        if(indexPath.section == 2 )
        {
            headerView.header.text = "BİLİM KURGU"
        }
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
