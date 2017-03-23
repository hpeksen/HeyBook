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
                  let  book_title = json["data"][index]["book_title"].string!
                  let  author_title = json["data"][index]["author_title"].string!
                   let duration = json["data"][index]["duration"].string!
                   let photo = json["data"][index]["photo"].string!
                   let desc = json["data"][index]["description"].string!
                  let  demo = json["data"][index]["audio"].string!
                  let  thumb = json["data"][index]["thumb"].string!
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
        return cell
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if (kind ==  UICollectionElementKindSectionFooter) && (loadingStatus != .finished){
            var footerView:LoadMoreCollectionReusableView!
            footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LoadMoreVerticalCollectionFooterViewCellIdentifier", for: indexPath) as! LoadMoreCollectionReusableView
            return footerView
        } else if(kind == UICollectionElementKindSectionHeader){
            var headerView:HeaderCategoriesCollectionReusableView!
            headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! HeaderCategoriesCollectionReusableView
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
