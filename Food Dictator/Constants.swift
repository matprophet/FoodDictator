//
//  Constants.swift
//  Food Dictator
//
//  Created by Mat Davidson on 5/12/16.
//  Copyright © 2016 Mat Davidson. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let fdRedColor = UIColor.init(red: 171.0/255.0, green: 0, blue: 0, alpha: 1)
    static let fdLightRedColor = UIColor.init(red: 200.0/255.0, green: 0, blue: 0, alpha: 1).cgColor
    static let fdFontColor = UIColor.white
    static let fdLargeFont = UIFont.init(name: "Dictator", size: 20)!
    static let fdMiddleFont = UIFont.init(name: "Dictator", size: 14)!
    static let fdCellHeight: CGFloat = 64.0
    static let fdDefaultProfileImage: UIImage = UIImage.init(named: "Profile")!
    static let fdPersistanceFile: String = "Candidates.plist"
    static let fdCellIdentifier: String = "CandidateCell"
}

