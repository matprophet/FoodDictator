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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().barTintColor =  Constants.fdRedColor
        UINavigationBar.appearance().tintColor = UIColor.white
        
        //[: UIFont(name: "HelveticaNeue-Light", size: 19)!]

        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.font:  Constants.fdLargeFont,
            NSAttributedString.Key.foregroundColor: Constants.fdFontColor];

        
        UIBarButtonItem.appearance().setTitleTextAttributes(convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): Constants.fdFontColor,
            convertFromNSAttributedStringKey(NSAttributedString.Key.font): Constants.fdMiddleFont]), for: UIControl.State())
        
        return true
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
