//
//  ViewController.swift
//  HeyBook
//
//  Created by Admin on 04/01/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit
import SideMenu

class MainViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, iCarouselDelegate,iCarouselDataSource  {
    var records: [Record] = []
    
    var imageAnim : [String] = []
    
    //image animation(carousel)
    @IBOutlet weak var carouselView: iCarousel!
    var numbers = [Int]()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("ŞİKLKJHGCHVHJHJK")
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var myCollectionView: UICollectionView!
    var book_title = ""
    var author_title = ""
    var duration = ""
    var photo = ""
    var desc = ""
     var demo = ""
    var thumb = ""
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    let mSearchController = UISearchController(searchResultsController: nil)
    var isSearch=false
    var originalNavigationView: UIView?
    var searchedRecords: [Record] = []
    
    @IBAction func segmentedBtn(_ sender: Any) {
        
       myCollectionView.reloadData()
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
      self.view.backgroundColor = UIColor(patternImage: UIImage(named: "register_bg.png")!)
        //image animation

        carouselView.type = .rotary
        
       
        
        //Left menu
        menuButton.target = revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
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

        SideMenuManager.menuPresentMode = .menuSlideIn
    

    
    
    }

    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let mURL = URL(string: "http://heybook.online/api.php?request=books") { //http://heybook.online/api.php?request=books
            if let data = try? Data(contentsOf: mURL) {
                let json = JSON(data: data)
                //print(json)
                
                let total = json["data"].count
                //print(total)
                
                for index in 0..<total {
                    book_title = json["data"][index]["book_title"].string!
                    author_title = json["data"][index]["author_title"].string!
                    duration = json["data"][index]["duration"].string!
                    photo = json["data"][index]["photo"].string!
                    desc = json["data"][index]["description"].string!
                    demo = json["data"][index]["audio"].string!
                    thumb = json["data"][index]["thumb"].string!
                    //print(book_title)
                    //print(author_title)
                    //print(duration)
                    //print(photo)
                    let record: Record = Record(book_title: book_title, author_title: author_title, duration: duration, photo: photo, desc: desc, demo: demo,thumb: thumb)
                    
                    
                    
                    
                    records.append(record)
                    
                    
                    
                }
                
            }
            else {
                print("NSdata error")
                
            }
        }
        
        
        
        
        
        
        
    }
    
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return records.count
    }
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: 150 , height: 150))
        
        
        
        
        
        
        // Aschronized image loading !!!!
        URLSession.shared.dataTask(with: NSURL(string: records[index].photo)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                
                
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
                button.setTitle("\(index)", for: .normal)
                button.setImage(UIImage(data: data!), for: .normal)
                //                            button.imageView?.image = UIImage(data: data!)
                tempView.addSubview(button)
                
                
                //cell.bookImage.image = UIImage(data: data!)
                
            })
            
        }).resume()
        
        
        return tempView
    }
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == iCarouselOption.spacing{
            return 1
        }
        return value
    }

    
    
    
    @IBAction func unwindToVitrin(_ sender: UIStoryboardSegue) {
        
    }
    
    
    
    override var prefersStatusBarHidden: Bool {
        return true
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
        return 1
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
        
                
        cell.duration.text = record.duration + " min."
        
        
        cell.bookImage.image = UIImage(data: data!)
                
             })
            
        }).resume()
    
    
        
        return cell
    }
    
  
    // For each header setting the data
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! HeaderCollectionReusableView
        if(segmentedController.selectedSegmentIndex == 0 )
        {
        headerView.header.text = "Son Eklenenler"
        }
        
        if(segmentedController.selectedSegmentIndex == 1 )
        {
            headerView.header.text = "En Populer"
        }
        
        if(segmentedController.selectedSegmentIndex == 2 )
        {
            headerView.header.text = "Çok satan"
        }
        return headerView
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

