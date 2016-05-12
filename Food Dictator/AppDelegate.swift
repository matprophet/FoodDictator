//
//  AppDelegate.swift
//  Food Dictator
//
//  Created by Mat Davidson on 5/9/16.
//  Copyright © 2016 Mat Davidson. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var candidateManager: CandidateManager
    
    override init() {
        candidateManager = CandidateManager.init()
        super.init()
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UINavigationBar.appearance().barTintColor =  Constants.fdRedColor
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName:  Constants.fdLargeFont,
            NSForegroundColorAttributeName: Constants.fdFontColor];

        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: Constants.fdFontColor,
            NSFontAttributeName: Constants.fdMiddleFont], forState: UIControlState.Normal)
        
        return true
    }
}

