//
//  SepetViewController.swift
//  HeyBook
//
//  Created by Admin on 27/03/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit
import SideMenu

class SepetViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {

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
    
    
    var totalPrice:Double = 0.0
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    @IBOutlet weak var btnMenu: UIBarButtonItem!
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
        
        totalPriceLabel.text = "\(String(format: "%.2f", totalPrice)) TL"
    }

    @IBAction func menuButtonClick(_ sender: Any) {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let mURL = URL(string: "http://heybook.online/api.php?request=user_cart&user_id=\(UserDefaults.standard.value(forKey: "user_id")!)") { //http://heybook.online/api.php?request=books
            if let data = try? Data(contentsOf: mURL) {
                let json = JSON(data: data)
                print(UserDefaults.standard.value(forKey: "user_title"))
                print(UserDefaults.standard.value(forKey: "user_mail"))
                print(UserDefaults.standard.value(forKey: "user_id")!)
                print("SEPETİM")
                print(json)
                
                let total = json["data"].count
                //print(total)
                
                for index in 0..<total {
                    book_id = json["data"][index]["book_id"].string!
                    category_id = json["data"][index]["category_id"].string!
                    publisher_id = json["data"][index]["publisher_id"].string!
                    author_id = json["data"][index]["author_id"].string!
                    narrator_id = json["data"][index]["narrator_id"].string!
                    book_title = json["data"][index]["book_title"].string!
                    desc = json["data"][index]["description"].string!
                    price = json["data"][index]["price"].string!
                    photo = json["data"][index]["photo"].string!
                    thumb = json["data"][index]["thumb"].string!
                    audio = json["data"][index]["audio"].string!
                    duration = json["data"][index]["duration"].string!
                    size = json["data"][index]["size"].string!
                    demo = json["data"][index]["demo"].string!
                    star = json["data"][index]["star"].string!
                    category_title = json["data"][index]["category_title"].string!
                    author_title = json["data"][index]["author_title"].string!
                    publisher_title = json["data"][index]["publisher_title"].string!
                    //print(book_title)
                    //print(author_title)
                    //print(duration)
                    //print(photo)
                    let record: Record = Record(book_id: book_id, category_id: category_id, publisher_id: publisher_id, author_id: author_id, narrator_id: narrator_id, book_title: book_title, desc: desc, price: price,  photo: photo, thumb: thumb, audio: audio, duration: duration, size: size,  demo: demo, star: star, category_title: category_title, author_title: author_title, publisher_title: publisher_title)
                    
                    
                    
                    
                    
                    records.append(record)
                    
                    print("hoppala")
                    print(records[index].book_title)
                    print(records[index].duration)
                    print(records[index].photo)
                    
                    totalPrice += Double(record.price)!
                }
            }
            else {
                print("NSdata error")
                
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
        print("records.count")
        print(records.count)
        return records.count
        
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
                print(error)
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
        print(index)
        
        if let mURL = URL(string: "http://heybook.online/api.php?request=user_cart-delete&user_id=\(UserDefaults.standard.value(forKey: "user_id")!)&book_id=\(index)") { //http://heybook.online/api.php?request=books
            if let data = try? Data(contentsOf: mURL) {
                let json = JSON(data: data)
                print(json)
          
                for i in 0..<records.count {
                    if (Int(records[i].book_id) == index) {
                        totalPrice -= Double(records[i].price)!
                        records.remove(at: i)
                        break
                    }
                }
                totalPriceLabel.text = "\(String(format: "%.2f", totalPrice)) TL"
                myCollectionView.reloadData()
            }
        }
    
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

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
