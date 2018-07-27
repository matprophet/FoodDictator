//
//  Candidate.swift
//  Food Dictator
//
//  Created by Mat Davidson on 5/9/16.
//  Copyright © 2016 Mat Davidson. All rights reserved.
//

import Foundation
import UIKit


struct Candidate {
    let name: String
    let title: String
    let profileImage: UIImage?
    let contactsIdentifier: String
    var isElectable: Bool
}

extension Candidate: Equatable {}

func ==(lhs: Candidate, rhs: Candidate) -> Bool {
    return lhs.contactsIdentifier == rhs.contactsIdentifier
}


extension Candidate: ArchivableStruct {

    // --------------------------------------
    // ArchivableStruct protocol
    // --------------------------------------
    var dataDictionary: [String: AnyObject] {
        get {
            var dict:[String: AnyObject] = [
                "name": self.name as AnyObject,
                "title": self.title as AnyObject,
                "contactsIdentifier": self.contactsIdentifier as AnyObject,
                "isElectable": self.isElectable as AnyObject
            ]
            
            if self.profileImage != nil {
                dict["profileImage"] = self.profileImage!
            }
            
            return dict
        }
    }
    
    init(dataDictionary aDict: [String : AnyObject]) {
        self.name = aDict["name"] as! String
        self.title = aDict["title"] as! String
        self.profileImage = aDict["profileImage"] as? UIImage
        self.contactsIdentifier = aDict["contactsIdentifier"] as! String
        self.isElectable = aDict["isElectable"] as! Bool
    }
}
