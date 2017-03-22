//
//  CatagoriesViewController.swift
//  HeyBook
//
//  Created by Admin on 21/03/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit
import SideMenu

class CatagoriesViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {

  
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    @IBOutlet weak var catagoriesCollectionView: UICollectionView!
    var buttonArr:[Record]=[]
    var records:[Record] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return records.count
        
    }
    
    
    
    // For each cell setting the data
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CustomCatagoriesCollectionViewCell
        cell.bookImageCatagory.image = UIImage(named: "kullanici")
        cell.bookNameCatagory.text = records[indexPath.row].book_title
        
        
        //Aschronized image loading !!!!
        URLSession.shared.dataTask(with: NSURL(string: records[indexPath.row].photo)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                
                
                cell.bookImageCatagory.image = UIImage(data: data!)
                
            })
            
        }).resume()
        
        
        
        
  
        return cell
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
