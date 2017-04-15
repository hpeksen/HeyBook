//
//  PlayBookViewController.swift
//  HeyBook
//
//  Created by Admin on 03/04/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit
import AVFoundation
import SideMenu

class PlayBookViewController: UIViewController {

    @IBOutlet weak var bookPhoto: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var playButtonImage: UIButton!
    @IBOutlet weak var bookAuthorLabel2: UILabel!
    @IBOutlet weak var bookAuthorLabel: UILabel!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var sureLabel: UILabel!
    @IBOutlet weak var publisherNameLabel: UILabel!
    @IBOutlet weak var narratorNameLabel: UILabel!
    
    var bookName = ""
    var authorName = ""
    var bookLink = ""
    var bookImage = ""
    var narratorName = ""
    var publisherName = ""
    var duration = ""
    
    var player = AVPlayer()
    var playerLayer:AVPlayerLayer?
    
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
            bookLink = (record.audio)
            bookImage = (record.thumb)
            narratorName = record.narrator_title
            publisherName = record.publisher_title
            duration = (record.duration)
        } else {
            print("olmadi lan....")
            
        }
        
        bookAuthorLabel.text = authorName
        bookAuthorLabel2.text = authorName
        bookNameLabel.text = bookName
        narratorNameLabel.text = narratorName
        publisherNameLabel.text = publisherName
        let (h,m,s) = secondsToHoursMinutesSeconds(seconds: Int(duration)!)
        var durationMessage = ""
        if h != 0 {
            durationMessage += "\(h) saat"
        }
        if m != 0 {
            durationMessage += "\(m) dakika"
        }
        sureLabel.text = durationMessage
        
        self.bookPhoto.layer.cornerRadius = self.bookPhoto.frame.size.width / 2;
        self.bookPhoto.clipsToBounds = true;
        
        //Aschronized image loading !!!!
        URLSession.shared.dataTask(with: NSURL(string: bookImage)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                
                self.bookPhoto.image = UIImage(data: data!)
                
            })
            
        }).resume()
        
        let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
        menuLeftNavigationController.leftSide = true
        SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
        
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        SideMenuManager.menuPresentMode = .menuSlideIn
        
        
        let url = URL(string: bookLink)
        let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem)
        
        
        slider.maximumValue = Float(CMTimeGetSeconds((player.currentItem?.asset.duration)!))
        slider.value = 0.0
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menuButtonClick(_ sender: Any) {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func playButton(_ sender: UIButton) {
        
        if((player.rate != 0) && (player.error == nil)) {
            player.pause()
            playButtonImage.setImage(UIImage(named: "play-1.png"), for: UIControlState.normal)
        }
        else {
            
            player.play()
            
            playButtonImage.setImage(UIImage(named: "pause-1.png"), for: UIControlState.normal)
            
            print("çalıyo")
            print(bookLink)
        }
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        player.seek(to: CMTimeMakeWithSeconds(Float64(sender.value), 10000))
        
    }
    
    func updateTime(_ timer: Timer) {
        let time = Int(CMTimeGetSeconds((player.currentItem?.currentTime())!))
        
        let (h,m,s) = secondsToHoursMinutesSeconds(seconds: time)
        
        slider.value = Float(CMTimeGetSeconds((player.currentItem?.currentTime())!))
        timeLabel.text = NSString(format: "%02d:%02d", m,s) as String
    }
    
    @IBAction func forwardButtonClicked(_ sender: AnyObject) {
        let forwardTimeInSeconds = (Float(CMTimeGetSeconds((player.currentItem?.currentTime())!)) + 10)
        
        player.seek(to: CMTimeMakeWithSeconds(Float64(forwardTimeInSeconds), 10000))
    }
    
    @IBAction func backwardButtonClicked(_ sender: AnyObject) {
        let backwardTimeInSeconds = (Float(CMTimeGetSeconds((player.currentItem?.currentTime())!)) - 10)
        player.seek(to: CMTimeMakeWithSeconds(Float64(backwardTimeInSeconds), 10000))
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        let hours = Int(seconds) / 3600
        let minutes = Int(seconds) / 60 % 60
        let seconds = Int(seconds) % 60
        return (hours, minutes, seconds)
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

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
