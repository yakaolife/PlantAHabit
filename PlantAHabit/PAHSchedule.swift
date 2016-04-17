//
//  PAHSchedule.swift
//  PlantAHabit
//
//  Created by Ya Kao on 3/25/16.
//  Copyright © 2016 Ya Kao. All rights reserved.
//

import UIKit

class PAHSchedule: NSObject {
    
    //Example: Schedule.Daily.rawValue = "None", etc //Swift 2.1
    enum Schedule : String{
        case None, Daily, Weekly, Monthly
    }
    
    enum Days : String{
        case M, T, W, Th, F, Sa, S
    }
    
    var days : [Days] = [Days]()
    
    var scheduleType: Schedule = .None
    
    var habitUID : String?
    
    //Use by other classes
    init(type: Schedule, days: [Days]){
        self.scheduleType = type
        self.days = days
    }
    
    //Use for getting data from Core Data, or from Habit(default values)
    init(type: Schedule, days: String){
        super.init()
        self.scheduleType = type
        self.stringToDayArray(days)
    }
    
    //TODO: clean up and have all function in same format: return or set property?
    
    func stringToDayArray(input: String){
        var dayStringArray = [String]()
        
        for day in input.componentsSeparatedByString(","){
            dayStringArray.append(day)
        }
        
        self.useStringToSetDays(dayStringArray)
        
    }
    
    func dayArrayToString()->String{
        
        //Turning ["M", "T", "W"] into a string of "M,T,W" for saving into Core Data
        //Convert days array into String first
        var dayStringArray = [String]()
        
        for day in days{
            dayStringArray.append(day.rawValue)
        }
        
        return dayStringArray.joinWithSeparator(",");
        
    }
    
    func useStringToSetDays(input: [String]){
        
        for i in input{
            let dayEnum = Days(rawValue: i)
            self.days.append(dayEnum!)
            
        }
    }

    
}
