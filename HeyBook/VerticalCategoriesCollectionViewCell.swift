//
//  VerticalCategoriesCollectionViewCell.swift
//  HeyBook
//
//  Created by Admin on 23/03/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit

enum LoadMoreStatus{
    case loading
    case finished
    case haveMore
}

class VerticalCategoriesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var numberOfCells = 7
    var loadingStatus = LoadMoreStatus.haveMore
    
    var records:[Record] = []
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
    
    var section = ""

    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let mURL = URL(string: "http://heybook.online/api.php?request=books") { //http://heybook.online/api.php?request=books
            if let data = try? Data(contentsOf: mURL) {
                let json = JSON(data: data)
                //print(json)
                
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
                    
                    
                    
                }
                
            }
            else {
                print("NSdata error")
                
            }
        }
        
        
    }
    
    func reloadData(){
        numberOfCells = 7
        collectionView.reloadData()
        if numberOfCells > 0 {
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
        }
    }
    
    func loadMore() {
        
        if numberOfCells >= 7{
            loadingStatus = .finished
            collectionView.reloadData()
            return
        }
        
        self.numberOfCells += 5
        self.collectionView.reloadData()
    }
    
}

extension VerticalCategoriesCollectionViewCell: UICollectionViewDataSource, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfCells
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontallCellIdentifier", for: indexPath) as! HorizontalCategoriesCollectionViewCell
        
        cell.categoriesBookName.text = section
        //Aschronized image loading !!!!
        URLSession.shared.dataTask(with: NSURL(string: records[indexPath.row].photo)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                
                cell.categoriesBookImage.image = UIImage(data: data!)
                
            })
            
        }).resume()
        
        if(indexPath.row==numberOfCells-1){
            if loadingStatus == .haveMore {
                self.perform(#selector(VerticalCategoriesCollectionViewCell.loadMore), with: nil, afterDelay: 0)
            }
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var footerView:LoadMoreCollectionReusableView!
        
        if (kind ==  UICollectionElementKindSectionFooter) && (loadingStatus != .finished){
            footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LoadMoreVerticalCollectionFooterViewCellIdentifier", for: indexPath) as! LoadMoreCollectionReusableView
            
        }
        return footerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return (loadingStatus == .finished) ? CGSize.zero : CGSize(width: 80, height: self.frame.height)
    }
    
    @objc(collectionView:didSelectItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        getIndexPathForSelectedCell()
    }
    func getIndexPathForSelectedCell() -> IndexPath? {
        var indexPath: IndexPath?
        
        if collectionView.indexPathsForSelectedItems!.count > 0 {
            indexPath = collectionView.indexPathsForSelectedItems![0] as IndexPath
            
            let record: Record
            
            record = records[(indexPath?.row)!]
            
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: record)
            UserDefaults.standard.set(encodedData, forKey: "book_record")
            UserDefaults.standard.synchronize()
        }
        
        return indexPath
    }
    
}

extension VerticalCategoriesCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        print("KATEGORi")
        print(self.frame.height)
        return CGSize(width: 80, height: self.frame.height)
    }
    
}
