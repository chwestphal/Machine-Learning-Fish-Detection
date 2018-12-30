//
//  ViewController.swift
//  Bei Fisch frag Chrisch
//
//  Created by Christian Westphal on 14/07/2018.
//  Copyright © 2018 Christian Westphal. All rights reserved.
//
//  Credits to these guys for the nice framework & support
//  TOCropViewController - https://github.com/TimOliver/TOCropViewController
//  Paper Onboarding - https://github.com/Ramotion/paper-onboarding
//  Apple - https://developer.apple.com/documentation/vision/classifying_images_with_vision_and_core_ml

import UIKit
import PaperOnboarding

class ViewController: UIViewController, PaperOnboardingDataSource, PaperOnboardingDelegate {
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var viewOnboarding: ViewControllerOnboarding!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        viewOnboarding.dataSource = self
        viewOnboarding.delegate = self
    }
    
    // number of onboarding screens
    func onboardingItemsCount() -> Int {
        return 4
    }
    
    private func getTitleFont() -> UIFont {
        let font = UIFont(name: "Noteworthy", size: 36.0)
        if let titleFont = font {
            return titleFont
        }
        return UIFont.systemFont(ofSize: 36.0)
        }
    
    private func getDescriptionFont() -> UIFont {
        let font = UIFont(name: "Noteworthy", size: 18.0)
        if let descriptionFont = font {
            return descriptionFont
        }
        return UIFont.systemFont(ofSize: 18.0)
    }

    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        let titleFont = self.getTitleFont()
        let descriptionFont = self.getDescriptionFont()
        let blankImage: UIImage = UIImage.init()
        let backgroundColor1 = UIColor(displayP3Red: 111/255, green: 143/255, blue: 181/255, alpha: 1)
        let backgroundColor2 = UIColor(displayP3Red: 121/255, green: 176/255, blue: 181/255, alpha: 1)
        let backgroundColor3 = UIColor(displayP3Red: 154/255, green: 145/255, blue: 188/255, alpha: 1)
        let backgroundColor4 = UIColor(displayP3Red: 136/255, green: 166/255, blue: 188/255, alpha: 1)
        return [
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "pic3") , title: "Bei Fisch frag Chrisch!", description: "Die App zur Erkennung von Fischen auf deinen Bildern." , pageIcon: blankImage, color: backgroundColor1, titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "onBoardingImage123") , title: "Erkennt die auch das?", description: "Die App erkennt 10 verschiedene Fische:  \n Aal, Bachforelle, Barsch, Hecht, Karpfen, Rapfen, Regenbogenforelle,  \n Stoer, Wels & Zander.", pageIcon: blankImage, color: backgroundColor2, titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "boringGuy") , title: "Ganz Wichtig !", description: "Optimale Ergebnisse erzielst du, wenn auf dem Bild fast nur noch der Fisch zu sehen ist." , pageIcon: blankImage, color: backgroundColor3, titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "happyGuy"), title: "Petri Heil !", description: "", pageIcon: blankImage, color: backgroundColor4, titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont)
            ][index]
    }
    
    @IBAction func gotStarted(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "onBoardingComplete")
        userDefaults.synchronize()
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        if index == 2 {
            UIView.animate(withDuration: 0, animations: {
                self.startButton.alpha = 0
            })
        }
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 3 {
            UIView.animate(withDuration: 0.3, animations: {
                self.startButton.layer.borderWidth = 2
                self.startButton.layer.borderColor = UIColor.white.cgColor
                self.startButton.layer.cornerRadius = 5
                self.startButton.alpha = 1
            })
        }
    }
    
    func onboardingPageItemSelectedRadius() -> CGFloat {
        return 7
    }
    
    func onboardinPageItemRadius() -> CGFloat {
        return 3.5
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}






