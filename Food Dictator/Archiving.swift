//
//  Archiving.swift
//  Food Dictator
//
//  Created by Mat Davidson on 5/10/16.
//  Copyright © 2016 Mat Davidson. All rights reserved.
//

import Foundation


protocol ArchivableStruct {
    var dataDictionary: [String: AnyObject] { get }
    init(dataDictionary aDict: [String: AnyObject])
}
