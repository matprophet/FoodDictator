//
//  DictatorViewController.swift
//  Food Dictator
//
//  Created by Mat Davidson on 5/9/16.
//  Copyright © 2016 Mat Davidson. All rights reserved.
//

import UIKit
import AudioToolbox
import CoreLocation

class DictatorViewController: UIViewController {
    
    @IBOutlet var title1:UILabel!
    @IBOutlet var title2:UILabel!
    @IBOutlet var profileImage:UIImageView!
    @IBOutlet var name:UILabel!
    @IBOutlet var subtitle:UILabel!
    @IBOutlet var quoteText:UITextView!
    @IBOutlet var findRestaurantsButton:UIButton!
    
    weak var candidateManager: CandidateManager?
    private var locationManager: CLLocationManager!
    private var crowdSound: SystemSoundID = 0
    private var boosSound: SystemSoundID = 0
    private var hasPendingMapsLink: Bool
    
    required init?(coder aDecoder: NSCoder) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        candidateManager = appDelegate.candidateManager
        
        hasPendingMapsLink = false
        
        if let crowdURL = NSBundle.mainBundle().URLForResource("crowd", withExtension: "wav") {
            AudioServicesCreateSystemSoundID(crowdURL, &crowdSound)
        }
        
        if let boosURL = NSBundle.mainBundle().URLForResource("booing", withExtension: "wav") {
            AudioServicesCreateSystemSoundID(boosURL, &boosSound)
        }
        
        super.init(coder: aDecoder)
    
        locationManager = CLLocationManager.init()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title1.alpha = 0
        title2.alpha = 0
        profileImage.alpha = 0
        name.alpha = 0
        subtitle.alpha = 0
        findRestaurantsButton.alpha = 0
        quoteText.alpha = 0

        profileImage.backgroundColor = UIColor.whiteColor()
        profileImage.clipsToBounds = true
        profileImage.layer.masksToBounds = true
        profileImage.layer.borderWidth = 1.0
        profileImage.layer.borderColor = UIColor.init(white: 0.80, alpha: 1.0).CGColor
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2.0

        findRestaurantsButton.layer.borderWidth = 1.0
        findRestaurantsButton.layer.borderColor = UIColor.init(white: 0.50, alpha: 1.0).CGColor
        findRestaurantsButton.layer.cornerRadius = 6.0
        
        if let c = candidateManager?.randomCandidate() {
            profileImage.image = c.profileImage != nil ? c.profileImage : Constants.fdDefaultProfileImage
            name.text = c.name
            subtitle.text = c.title
        }
        
        if let quote = candidateManager?.randomCandidateQuote() {
            quoteText.setSafeText( quote )
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
     
        AudioServicesPlaySystemSound(crowdSound);

        presentCandidate()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        AudioServicesDisposeSystemSoundID(self.crowdSound)
        AudioServicesDisposeSystemSoundID(self.boosSound)
    }
    
    @IBAction func handleFindRestaurantsButton(sender: UIButton) {
        
        // async
        if CLLocationManager.authorizationStatus() == .NotDetermined {

            hasPendingMapsLink = true

            locationManager.requestWhenInUseAuthorization()
        }
        else {
            openMapsLink()
        }
    }
    
    func openMapsLink() {
    
        // clear the flag
        hasPendingMapsLink = false
        
        let d = NSDate.init()
        var foodType: String
        switch d.currentTimeslot() {
        case .Breakfast:
            foodType = "breakfast"
            break
            
        case .Lunch:
            foodType = "lunch"
            break;
            
        case .Snacks:
            foodType = "cafe"
            break
            
        case .Dinner:
            foodType = "dinner"
            break
            
        case .None:
            foodType = "food"
            break
        }
        
        var urlStr: String
        if (CLLocationManager.authorizationStatus() == .AuthorizedAlways ||
            CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse) {
            
            let location = locationManager.location
            let coordinate = location!.coordinate
            
            urlStr = "http://maps.apple.com/?q=\(foodType)&near=\(coordinate.latitude),\(coordinate.longitude)";
        }
        else {
            urlStr = "http://maps.apple.com/?q=\(foodType)";
        }

        
        let url = NSURL.init(string: urlStr)!
        UIApplication.sharedApplication().openURL(url)
    }
    
    
    func presentCandidate() {
        
        UIView.animateWithDuration(0.5,
                                   delay: 1.0,
                                   options: .CurveEaseIn,
                                   animations: {
                                    self.title1.alpha = 1.0
                                    self.title2.alpha = 1.0
            },
                                   completion: { (didComplete) in
                                    if (didComplete) {
                                        self.animateProfile()
                                    }
        })
    }
    
    func animateProfile() {
        UIView.animateWithDuration(0.25,
                                   delay: 2.0,
                                   options: .CurveEaseOut,
                                   animations: {
                                    self.profileImage.alpha = 1.0
                                    self.name.alpha = 1.0
                                    self.subtitle.alpha = 1.0
            },
                                   completion: { (didComplete) in
                                    if (didComplete) {
                                        AudioServicesDisposeSystemSoundID(self.crowdSound)
                                        AudioServicesPlaySystemSound(self.boosSound)
                                        self.animateFindButton()
                                    }
        })
    }
    
    func animateFindButton() {
        UIView.animateWithDuration(0.75,
                                   delay: 1.0,
                                   options: .CurveEaseOut,
                                   animations: {
                                    self.findRestaurantsButton.alpha = 1.0
                                    self.quoteText.alpha = 1.0
            },
                                   completion: nil)
    }
}


extension DictatorViewController : CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if (hasPendingMapsLink) {
            openMapsLink()
        }
    }
}


