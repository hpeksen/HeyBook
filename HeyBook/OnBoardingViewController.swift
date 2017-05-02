//
//  OnBoardingViewController.swift
//  HeyBook
//
//  Created by Admin on 02/05/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit
import paper_onboarding
class OnBoardingViewController: UIViewController,PaperOnboardingDataSource, PaperOnboardingDelegate {
    @IBOutlet weak var getStartedButton: UIButton!

    @IBOutlet weak var onBoardingView: PaperOnboarding!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onboardingItemsCount() -> Int {
        return 3
    }
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        let backgroundColorOne = UIColor(red: 217/255, green: 72/255, blue: 89/255, alpha: 1)
        let backgroundColorTwo = UIColor(red: 186/255, green: 166/255, blue: 211/255, alpha: 1)
        let backgroundColorThree = UIColor(red: 168/255, green: 200/255, blue: 78/255, alpha: 1)
        
        let titleFont = UIFont(name: "AvenirNext-Bold", size: 24)!
        let descriptionFont = UIFont(name: "AvenirNext-Regular", size: 18)!
        
        return [("bg1","First View","Description","",backgroundColorOne,UIColor.blue,UIColor.yellow,titleFont,descriptionFont),
                ("login_bg","ghkjtuykyu","sfgjstyjst","",backgroundColorTwo,UIColor.red,UIColor.white,titleFont,descriptionFont),
                ("register_bg","fghfghfghf","dgjhdghjd","",backgroundColorThree,UIColor.white,UIColor.white,titleFont,descriptionFont)][index]
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        
    }
    func onboardingWillTransitonToIndex(_ index: Int) {
        if index == 0 {
            if self.getStartedButton.alpha == 1 {
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.getStartedButton.alpha = 0
                    self.getStartedButton.isHidden = true
                })
            }
        }
        if index == 1 {
            if self.getStartedButton.alpha == 1 {
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.getStartedButton.alpha = 0
                    self.getStartedButton.isHidden = true
                })
            }
        }
    }
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 2 {
            UIView.animate(withDuration: 0.4, animations: {
                self.getStartedButton.alpha = 1
                self.getStartedButton.isHidden = false
            })
            
        }
        
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
