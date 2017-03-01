//
//  ListenViewController.swift
//  HeyBook
//
//  Created by Admin on 04/01/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit
import AVFoundation

class ListenViewController: UIViewController {

    var player = AVPlayer()
    var timer:Timer!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
 

    @IBOutlet weak var bookListenImage: UIImageView!
    var desc = ""
    var bookName = ""
    var authorName = ""
    var bookLink = ""
    var bookImage = ""
    override func viewDidLoad() {
        super.viewDidLoad()

     
        descriptionLabel.text = desc
        bookNameLabel.text = bookName
        authorNameLabel.text = authorName
        
        let url = URL(string: bookImage)
        let data = try? Data(contentsOf: url!)
        print(bookImage)
        print("BOOOOKKİMAAAAJJJ")

        bookListenImage.image = UIImage(data: data!)
        
        
        // Do any additional setup after loading the view.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkTime() {
        if self.player.currentTime().seconds >= 5 {
            self.player.pause()
            self.player.replaceCurrentItem(with: nil)
            timer.invalidate()
        }
    }
    
    @IBAction func listenBook(_ sender: UIButton) {
        
        let url = bookLink
        let playerItem = AVPlayerItem( url:NSURL( string:url ) as! URL )
        player = AVPlayer(playerItem:playerItem)
        player.rate = 1.0;
        player.play()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ListenViewController.checkTime), userInfo: nil, repeats: true)
        let t1 = Float(self.player.currentTime().value)
        let t2 = Float(self.player.currentTime().timescale)
        let currentSeconds = t1 / t2
        if(currentSeconds >= 10){
            player.pause()
        }
        
        print("çalıyo ")
        print(bookLink)
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
