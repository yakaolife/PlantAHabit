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
    var plant: PAHPlant?
    
    
    //Habit Stats
    
    //TODO: These two might have dependency! beware of totalCount = 0 but completeCount is set first...
    var totalCount: Int = 0 {
        didSet{
            rate = Double(completeCount / totalCount)
            //TODO: set plant growth here too?
        }
    }
    var completeCount: Int = 0
    var rate: Double = 0
    
    //TODO: Add Alarm class
    //TODO: Add Tag?
    
    //Convenience init coming from Core Data
    init(coreDataObj: NSManagedObject){
        self.title = (coreDataObj.valueForKey("title") as? String)!

    }
    
    init(title: String, note: String, schedule: PAHSchedule){
        self.title = title
        self.note = note
        self.schedule = schedule

        
//        if(plant != nil){
//            self.plant = PAHPlant()
//        }else{
//            self.plant = plant
//        }
        
    }
    

    
}
