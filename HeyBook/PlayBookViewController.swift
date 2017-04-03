//
//  PlayBookViewController.swift
//  HeyBook
//
//  Created by Admin on 03/04/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit

class PlayBookViewController: UIViewController {

    @IBOutlet weak var bookAuthorLabel2: UILabel!
    @IBOutlet weak var bookAuthorLabel: UILabel!
    @IBOutlet weak var bookNameLabel: UILabel!
    var bookName = ""
    var authorName = ""
    var bookLink = ""
    var bookImage = ""
    var duration = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        if let dataa = UserDefaults.standard.data(forKey: "book_record_play"),
            let record = NSKeyedUnarchiver.unarchiveObject(with: dataa) as? Record {
            
            bookName = (record.book_title)
            authorName = (record.author_title)
            bookLink = (record.demo)
            bookImage = (record.thumb)
            duration = (record.duration)
        } else {
            print("olmadi lan....")
            
        }
        
        bookAuthorLabel.text = authorName
        bookAuthorLabel2.text = authorName
        bookNameLabel.text = bookName
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
