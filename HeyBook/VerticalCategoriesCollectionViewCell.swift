//
//  VerticalCategoriesCollectionViewCell.swift
//  HeyBook
//
//  Created by Admin on 23/03/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit
import Alamofire

class VerticalCategoriesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
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
    var narrator_title = ""
    
    var section = ""
    
}

extension VerticalCategoriesCollectionViewCell: UICollectionViewDataSource, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return records.count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontallCellIdentifier", for: indexPath) as! HorizontalCategoriesCollectionViewCell
        
        cell.categoriesBookName.text = records[indexPath.row].book_title
        cell.categoriesBookRating.rating = Double(records[indexPath.row].star)!
        cell.categoriesBookPrice.text = "\(records[indexPath.row].price) TL"
        cell.categoriesBookAuthor.text = records[indexPath.row].author_title
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
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
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
        
        return CGSize(width: 80, height: self.frame.height)
    }
    
}
