//
//  Utilities.swift
//  Food Dictator
//
//  Created by Mat Davidson on 5/12/16.
//  Copyright © 2016 Mat Davidson. All rights reserved.
//

import Foundation
import UIKit



extension UITextView {
    
    //  Function to avoid a bug where setting the text when selectable = false will reset the font
    //
    func setSafeText(text: String) {
        let originalSelectable = selectable
        selectable = true
        self.text = text
        selectable = originalSelectable
    }
}

extension NSDate {
    
    enum NextTimeslot {
        case Breakfast
        case Lunch
        case Snacks
        case Dinner
        case None
    }
    
    func systemDate() -> NSDate {
        let tz = NSTimeZone.defaultTimeZone()
        let seconds = tz.secondsFromGMTForDate(self)
        return NSDate.init(timeInterval: NSTimeInterval(seconds), sinceDate: self)
    }
    
    func dateByNeutralizingDateComponents() -> NSDate {
        
        guard let gregorian = NSCalendar.init(calendarIdentifier: NSCalendarIdentifierGregorian) else {
            fatalError("error creating gregorian calendar")
        }
        
        // Get the components for this date
        let unitFlags: NSCalendarUnit = [.Second, .Minute, .Hour, .Day, .Month, .Year]
        let comps = gregorian.components(unitFlags, fromDate: self)
        
        // Set the year, month and day to same arbitrary values
        comps.year = 2000
        comps.month = 1
        comps.day = 1
        
        return gregorian.dateFromComponents(comps)!
    }
    
    func isTimeBetween(startDate: NSDate, endDate: NSDate) -> Bool {
        
        // Make sure all the dates have the same date component.
        let newStartDate = startDate.dateByNeutralizingDateComponents()
        let newEndDate = endDate.dateByNeutralizingDateComponents()
        let newTargetDate = self.dateByNeutralizingDateComponents()
        
        // Compare the target with the start and end dates
        let compareTargetToStart = newTargetDate.compare(newStartDate)
        let compareTargetToEnd = newTargetDate.compare(newEndDate)
        
        return (compareTargetToStart == .OrderedDescending && compareTargetToEnd == .OrderedAscending);
    }
    
    
    func currentTimeslot() -> NextTimeslot {
        
        let currentDate = self.systemDate()
    
        let formatter = NSDateFormatter.init()
        formatter.timeZone = NSTimeZone.systemTimeZone()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // Breakfast slot (9:00 AM - 11:00 AM)
        let breakfastBeginingTime = "2016-02-23 09:00:00";
        let breakfastEndingTime = "2016-02-23 11:00:00";
        let breakfastBeginingDate =  formatter.dateFromString(breakfastBeginingTime)!.systemDate()
        let breakfastEndingDate = formatter.dateFromString(breakfastEndingTime)!.systemDate()
        if (currentDate.isTimeBetween(breakfastBeginingDate, endDate: breakfastEndingDate)) {
           return .Breakfast
        }
        
        // Lunch slot (11:00 AM - 1:30 PM)
        let lunchBeginingTime = "2016-02-23 11:00:00";
        let lunchEndingTime = "2016-02-23 13:30:00";
        let lunchBeginingDate = formatter.dateFromString(lunchBeginingTime)!.systemDate()
        let lunchEndingDate = formatter.dateFromString(lunchEndingTime)!.systemDate()
        if (currentDate.isTimeBetween(lunchBeginingDate, endDate: lunchEndingDate)) {
            return .Lunch
        }
        
        // Snacks slot (1:30 PM - 4:00 PM)
        let snacksBeginingTime = "2016-02-23 13:30:00";
        let snacksEndingTime = "2016-02-23 16:00:00";
        let snacksBeginingDate = formatter.dateFromString(snacksBeginingTime)!.systemDate()
        let snacksEndingDate = formatter.dateFromString(snacksEndingTime)!.systemDate()
        if (currentDate.isTimeBetween(snacksBeginingDate, endDate: snacksEndingDate)) {
            return .Snacks
        }
        
        // Dinner slot (04:00 PM - 10:00 PM)
        let dinnerBeginingTime = "2016-02-23 16:00:00";
        let dinnerEndingTime = "2016-02-23 22:00:00";
        let dinnerBeginingDate = formatter.dateFromString(dinnerBeginingTime)!.systemDate()
        let dinnerEndingDate = formatter.dateFromString(dinnerEndingTime)!.systemDate()
        if (currentDate.isTimeBetween(dinnerBeginingDate, endDate: dinnerEndingDate)) {
            return .Dinner
        }
    
        return .None;
    }
    
}

