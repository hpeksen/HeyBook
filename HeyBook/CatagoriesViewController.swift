//
//  CatagoriesViewController.swift
//  HeyBook
//
//  Created by Admin on 21/03/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit
import SideMenu

class CatagoriesViewController: UIViewController {

  
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    @IBOutlet weak var catagoriesCollectionView: UICollectionView!
    var records:[Record] = []
    var categories:[String] = []
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

    
    var numberOfCells=1
    
    var loadingStatus = LoadMoreStatus.haveMore
    
    func loadMore() {
        
        if numberOfCells >= 1{
            loadingStatus = .finished
            catagoriesCollectionView.reloadData()
            return
        }
        
        
        self.numberOfCells += 5
        self.catagoriesCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        self.automaticallyAdjustsScrollViewInsets = false;

        
        
        let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
        menuLeftNavigationController.leftSide = true
        SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
        
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        SideMenuManager.menuPresentMode = .menuSlideIn
        self.catagoriesCollectionView.reloadData()
        // Do any additional setup after loading the view.
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
                    if !categories.contains(record.category_title) {
                        categories.append(record.category_title)
                    }
                    
                    
                }
                
            }
            else {
                print("NSdata error")
                
            }
        }
        
        
    }
    
 
    
    
    
    
    @IBAction func menuButtonClick(_ sender: Any) {
         present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
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

extension CatagoriesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return numberOfCells
        
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        if(indexPath.row==numberOfCells-1){
            if loadingStatus == .haveMore {
                self.perform(#selector(CatagoriesViewController.loadMore), with: nil, afterDelay: 0)
            }
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VerticalCellIdentifier", for: indexPath) as! VerticalCategoriesCollectionViewCell
        //cell.section = String(indexPath.section)
        return cell
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if (kind ==  UICollectionElementKindSectionFooter) && (loadingStatus != .finished){
            var footerView:LoadMoreCollectionReusableView!
            footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LoadMoreVerticalCollectionFooterViewCellIdentifier", for: indexPath) as! LoadMoreCollectionReusableView
            return footerView
        } else if(kind == UICollectionElementKindSectionHeader){
            var headerView:HeaderCategoriesCollectionReusableView!
            headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! HeaderCategoriesCollectionReusableView
            
            headerView.headerLabel.text = categories[indexPath.section]
            headerView.headerBookCount.text = "\(records.count) kitap"
            
            return headerView
        }
        assert(false, "Unexpected element kind")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return (loadingStatus == .finished) ? CGSize.zero : CGSize(width: self.view.frame.width, height: 150)
        
    }
    
}

extension CatagoriesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.width, height: 150)
        
    }
    
    
    
}
