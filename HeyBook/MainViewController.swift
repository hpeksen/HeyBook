//
//  ViewController.swift
//  HeyBook
//
//  Created by Admin on 04/01/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit

class MainViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {
    var records: [Record] = []

    @IBOutlet weak var myCollectionView: UICollectionView!
    var book_title = ""
    var author_title = ""
    var duration = ""
    var photo = ""
    var desc = ""
     var demo = ""
    var thumb = ""
    
    let mSearchController = UISearchController(searchResultsController: nil)
    var isSearch=false
    var originalNavigationView: UIView?
    var searchedRecords: [Record] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let mURL = URL(string: "http://heybook.online/api.php?request=books") { //http://heybook.online/api.php?request=books
            if let data = try? Data(contentsOf: mURL) {
                let json = JSON(data: data)
                print(json)
                
                let total = json["data"].count
                print(total)
                
                   for index in 0..<total {
                 book_title = json["data"][index]["book_title"].string!
                 author_title = json["data"][index]["author_title"].string!
                duration = json["data"][index]["duration"].string!
                 photo = json["data"][index]["photo"].string!
                desc = json["data"][index]["description"].string!
                 demo = json["data"][index]["audio"].string!
                   thumb = json["data"][index]["thumb"].string!
                print(book_title)
                print(author_title)
                print(duration)
                print(photo)
                    let record: Record = Record(book_title: book_title, author_title: author_title, duration: duration, photo: photo, desc: desc, demo: demo,thumb: thumb)
                    
                    
                    records.append(record)
                
                }
                
            }
            else {
                print("NSdata error")
            
            }
        }
    
    
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
        if let mVC1 = segue.destination as? LoginViewController {
            let record: Record
            
            if mSearchController.isActive && mSearchController.searchBar.text != "" {
                record = searchedRecords[indexPath.row]
            } else {
                record = records[indexPath.row]
            }
            
                mVC1.desc = record.desc
                mVC1.authorName = record.author_title
                mVC1.bookLink = record.demo
                mVC1.bookImage = record.photo
                mVC1.bookName = record.book_title
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
        cell.authorName.text = record.author_title
        cell.bookName.text = record.book_title
        
        
        
        cell.duration.text = record.duration + " min."
        
        
        let url = URL(string: record.photo)
        let data = try? Data(contentsOf: url!)
        
        cell.bookImage.image = UIImage(data: data!)

      
        
        return cell
    }
    
    // For each header setting the data
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! HeaderCollectionReusableView
        
        
        
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

