//
//  PAHHabit.swift
//  PlantAHabit
//
//  Created by Ya Kao on 3/25/16.
//  Copyright © 2016 Ya Kao. All rights reserved.
//

/// This is the Habit class

import UIKit
import CoreData

class PAHHabit: NSObject {
  
    //Default
    var title: String = "title"
    var note: String = ""

    var schedule: PAHSchedule = PAHSchedule(type: PAHSchedule.Schedule.Daily, days: ["M", "T", "W", "Th", "F", "Sa", "S"])
    
    //TODO: how to init this
    // Use plantType for now
    var plant: PAHPlant?
    var plantType: String = "bush"
    var uid: String?
    
    
    //Habit Stats
    var completeCount: Int = 0
    var totalCount: Int = 0
    //Rate is calculated: see getRate function
    
    //TODO: Add Alarm class
    //TODO: Add Tag?
    
    //Convenience init coming from Core Data
    init(coreDataObj: NSManagedObject){
        self.title = (coreDataObj.valueForKey("title") as? String)!
        self.note = (coreDataObj.valueForKey("note") as? String)!
        self.completeCount = (coreDataObj.valueForKey("completeCount") as? Int)!
        self.totalCount = (coreDataObj.valueForKey("totalCount") as? Int)!
        self.plantType = (coreDataObj.valueForKey("plantType") as? String)!
        self.uid = (coreDataObj.valueForKey("uid") as? String)!

    }
    
    init(title: String, note: String, schedule: PAHSchedule){
        self.title = title
        self.note = note
        self.schedule = schedule
        self.uid = PAHDataStore.sharedInstance.generateHabitUid(self.title)
        
        print("id is \(self.uid)")
        
//        if(plant != nil){
//            self.plant = PAHPlant()
//        }else{
//            self.plant = plant
//        }
        
    }
    
    func getRate()->Double{
        print("getRate")
        if self.completeCount == 0{
            return 0.0
        }else{
        
            return roundRate(Double(self.completeCount) / Double(self.totalCount))
        }
    }
    
    //Just helper function stuff
    
    //From http://stackoverflow.com/a/26351144
    func roundRate(num: Double)->Double{
        let numberOfPlaces = 2.0
        let multiplier = pow(10.0, numberOfPlaces)
        
        return round(num * multiplier) / multiplier
    }
    

    

    
}
