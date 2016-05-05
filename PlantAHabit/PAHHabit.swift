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

    var schedule: PAHSchedule = PAHSchedule(type: PAHSchedule.Schedule.Daily, days: "M,T,W,Th,F,Sa,S")
    //var created: String? //NSDate, in YYYY-MM-DD format
    
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
        
        //Schedule
        
        let scheduleObj = (coreDataObj.valueForKey("schedule")) as! NSManagedObject
        let type = scheduleObj.valueForKey("type") as? String
        let days = scheduleObj.valueForKey("days") as? String
        
        schedule = PAHSchedule(type: PAHSchedule.Schedule(rawValue: type!)!, days: days!)
        
        schedule.habitUID = self.uid
        
        //Plant
        
        

    }
    
    //Schedule is not required, since we have default
    init(title: String, note: String, plantType: String){
        self.title = title
        self.note = note
        self.uid = PAHDataStore.sharedInstance.generateHabitUid(self.title)
        self.schedule.habitUID = self.uid
        
        print("id is \(self.uid)")
        
        
        
//        if(plant != nil){
//            self.plant = PAHPlant()
//        }else{
//            self.plant = plant
//        }
        
    }
    
    func getRate()->Double{
        
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
