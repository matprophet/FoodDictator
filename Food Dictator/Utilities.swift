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
    func setSafeText(_ text: String) {
        let originalSelectable = isSelectable
        isSelectable = true
        self.text = text
        isSelectable = originalSelectable
    }
}

extension Date {
    
    enum NextTimeslot {
        case breakfast
        case lunch
        case snacks
        case dinner
        case none
    }
    
    func systemDate() -> Date {
        let tz = TimeZone.current
        let seconds = tz.secondsFromGMT(for: self)
        return Date.init(timeInterval: TimeInterval(seconds), since: self)
    }
    
    func dateByNeutralizingDateComponents() -> Date {
        
        let gregorian = Calendar.init(identifier: Calendar.Identifier.gregorian)
        
        // Get the components for this date
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .month, .year]
        var comps = (gregorian as NSCalendar).components(unitFlags, from: self)
        
        // Set the year, month and day to same arbitrary values
        comps.year = 2000
        comps.month = 1
        comps.day = 1
        
        return gregorian.date(from: comps)!
    }
    
    func isTimeBetween(_ startDate: Date, endDate: Date) -> Bool {
        
        // Make sure all the dates have the same date component.
        let newStartDate = startDate.dateByNeutralizingDateComponents()
        let newEndDate = endDate.dateByNeutralizingDateComponents()
        let newTargetDate = self.dateByNeutralizingDateComponents()
        
        // Compare the target with the start and end dates
        let compareTargetToStart = newTargetDate.compare(newStartDate)
        let compareTargetToEnd = newTargetDate.compare(newEndDate)
        
        return (compareTargetToStart == .orderedDescending && compareTargetToEnd == .orderedAscending);
    }
    
    
    func currentTimeslot() -> NextTimeslot {
        
        let currentDate = self.systemDate()
    
        let formatter = DateFormatter.init()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // Breakfast slot (9:00 AM - 11:00 AM)
        let breakfastBeginingTime = "2016-02-23 09:00:00";
        let breakfastEndingTime = "2016-02-23 11:00:00";
        let breakfastBeginingDate =  formatter.date(from: breakfastBeginingTime)!.systemDate()
        let breakfastEndingDate = formatter.date(from: breakfastEndingTime)!.systemDate()
        if (currentDate.isTimeBetween(breakfastBeginingDate, endDate: breakfastEndingDate)) {
           return .breakfast
        }
        
        // Lunch slot (11:00 AM - 1:30 PM)
        let lunchBeginingTime = "2016-02-23 11:00:00";
        let lunchEndingTime = "2016-02-23 13:30:00";
        let lunchBeginingDate = formatter.date(from: lunchBeginingTime)!.systemDate()
        let lunchEndingDate = formatter.date(from: lunchEndingTime)!.systemDate()
        if (currentDate.isTimeBetween(lunchBeginingDate, endDate: lunchEndingDate)) {
            return .lunch
        }
        
        // Snacks slot (1:30 PM - 4:00 PM)
        let snacksBeginingTime = "2016-02-23 13:30:00";
        let snacksEndingTime = "2016-02-23 16:00:00";
        let snacksBeginingDate = formatter.date(from: snacksBeginingTime)!.systemDate()
        let snacksEndingDate = formatter.date(from: snacksEndingTime)!.systemDate()
        if (currentDate.isTimeBetween(snacksBeginingDate, endDate: snacksEndingDate)) {
            return .snacks
        }
        
        // Dinner slot (04:00 PM - 10:00 PM)
        let dinnerBeginingTime = "2016-02-23 16:00:00";
        let dinnerEndingTime = "2016-02-23 22:00:00";
        let dinnerBeginingDate = formatter.date(from: dinnerBeginingTime)!.systemDate()
        let dinnerEndingDate = formatter.date(from: dinnerEndingTime)!.systemDate()
        if (currentDate.isTimeBetween(dinnerBeginingDate, endDate: dinnerEndingDate)) {
            return .dinner
        }
    
        return .none;
    }
    
}

