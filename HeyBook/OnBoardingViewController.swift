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
        return 7
    }
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        let backgroundColorOne = UIColor(red: 217/255, green: 72/255, blue: 89/255, alpha: 1)
        let backgroundColorTwo = UIColor(red: 186/255, green: 166/255, blue: 211/255, alpha: 1)
        let backgroundColorThree = UIColor(red: 168/255, green: 200/255, blue: 78/255, alpha: 1)
        
        let titleFont = UIFont(name: "AvenirNext-Bold", size: 24)!
        let descriptionFont = UIFont(name: "AvenirNext-Regular", size: 18)!
        
        return [
            ("logo","Vitrin","Sistemimizde var olan kitaplara göz atabileceğiniz ana sayfamız.","",backgroundColorOne,UIColor.black,UIColor.black,titleFont,descriptionFont),
            
            ("logo","Kategoriler","İstediğiniz kategoride kitapların erişim noktası.","",backgroundColorTwo,UIColor.black,UIColor.black,titleFont,descriptionFont),
            ("logo","HeyBook'ta Ara","Kitap adına, yazara veya seslendirene göre arama yapabilirsiniz.","",backgroundColorThree,UIColor.black,UIColor.black,titleFont,descriptionFont),
            ("logo","Kitaplarım","Satın aldığınız kitapları görüntüleyebilir ve çevrimdışı dinleyebilirsiniz.","",backgroundColorOne,UIColor.black,UIColor.black,titleFont,descriptionFont),
            ("logo","Sepet","Satın almak istediğiniz kitapları sepetinize ekleyip, toplu bir şekilde ödeme yapabilirsiniz.","",backgroundColorTwo,UIColor.black,UIColor.black,titleFont,descriptionFont),
            ("logo","Giriş Yap","Sistemimize kayıt olduktan sonra, giriş yaparak daha fazla özelliğe erişim sağlayabilirsiniz.","",backgroundColorThree,UIColor.black,UIColor.black,titleFont,descriptionFont),
            ("logo","HeyBook","HeyBook'u keşfetmeye başla!","",backgroundColorTwo,UIColor.black,UIColor.black,titleFont,descriptionFont),
            
            ][index]
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        
    }
    func onboardingWillTransitonToIndex(_ index: Int) {
        if index != 6 {
            if self.getStartedButton.alpha == 1 {
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.getStartedButton.alpha = 0
                    self.getStartedButton.isHidden = true
                })
            }
        }
    }
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 6 {
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
