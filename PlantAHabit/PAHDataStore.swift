//
//  PAHDataStore.swift
//  PlantAHabit
//
//  Created by Ya Kao on 3/26/16.
//  Copyright © 2016 Ya Kao. All rights reserved.
//

import UIKit
import CoreData

//This is mostly for handling core data operation so any view controller can use the method here

class PAHDataStore {
    //One line singleton!
    static let sharedInstance = PAHDataStore()
    //Not sure if I can do this
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var managedContext: NSManagedObjectContext
    
    enum DataError: ErrorType{
        case SavingError
    }
    
    
    //Prevents other people using default init()
    private init() {
       managedContext = appDelegate.managedObjectContext
    }
    
    //Generate unique id for Habit
    //Using timeStamp + Habit Title
    //We never change this afterwards
    func generateHabitUid(habitTitle: String)->String{
        
        return "\(NSDate().timeIntervalSince1970 * 1000)-\(habitTitle)"
    }
    
    
    
    // predicate can be nill or not
    func fetchData(entityName: String, predicate: NSPredicate?)->[NSManagedObject]{
        
        let fetchRequest = NSFetchRequest(entityName: entityName)
        
        if predicate != nil{
            fetchRequest.predicate = predicate
        }
    
        var data = [NSManagedObject]()
        
        do{
            let results = try managedContext.executeFetchRequest(fetchRequest)
            data =  results as! [NSManagedObject]
            
        }catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
            
        }
        
        return data
    }
    
    //Assuming habit title is unique
    func getManagedObjectToSet(entityName: String)-> NSManagedObject{
        //print("dataStore:getManageObjectToSet: entityName: \(entityName)")
        
        let entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: managedContext)
        
        let managedObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        return managedObject
    }
    
    
    //Modify + Save New Habit, if oldHabitTitle is nil than this is new
    func saveHabit(habit: PAHHabit) throws{
        
        
        //Check if the new title (New Habit or Edit Habit) is duplicate with other in the core data
//        let predicate = NSPredicate(format: "title == %@", habit.title)
//        let duplicate = fetchData("Habit", predicate: predicate)
//        
//        if duplicate.count != 0{
//            //The title is not good
//            print("Duplicate Habit title with existing other habit!, edit")
//
//            throw DataError.DuplicateTitle
//        }
        
        //See if this is Modify
        //Find the original in Core Data to edit
        var predicate = NSPredicate(format: "uid == %@", habit.uid!)
        let foundHabit = fetchData("Habit", predicate: predicate)
            
        if foundHabit.count == 1{
            
            //Found the one we want to edit!
            foundHabit[0].setValue(habit.title, forKey: "title")
            foundHabit[0].setValue(habit.note, forKey: "note")
            foundHabit[0].setValue(habit.totalCount, forKey: "totalCount")
            foundHabit[0].setValue(habit.completeCount, forKey: "completeCount")
            
            //Schedule
            predicate = NSPredicate(format: "habitUID == %@", habit.uid!)
            let foundSchedule = fetchData("Schedule", predicate: predicate)
            
            if foundSchedule.count == 1{
                
                foundSchedule[0].setValue(habit.schedule.scheduleType.rawValue, forKey: "type")
                foundSchedule[0].setValue(habit.schedule.dayArrayToString(), forKey: "days")
                
            }else{
                print("No Schedule with a habit, something is wrong!")
            }
            
            //Plant
            //Can only modify the Growth Status
            foundHabit[0].setValue(habit.plantStatus.rawValue, forKey: "plantStatus")
            
            
        }else{
            //Save the new habit!
            
            let coreHabit = getManagedObjectToSet("Habit")
            coreHabit.setValue(habit.title, forKey: "title")
            coreHabit.setValue(habit.note, forKey: "note")
            coreHabit.setValue(0, forKey: "completeCount")
            coreHabit.setValue(0, forKey: "totalCount")
            coreHabit.setValue(habit.uid, forKey: "uid")
            
            //print("dataStore:saveHabit:new")
            
            //Schedule
            let schedule = getManagedObjectToSet("Schedule")
            
            //print("get schedule entity, and type rawValue is \(habit.schedule.scheduleType.rawValue), days: \(habit.schedule.dayArrayToString())")
            schedule.setValue(habit.schedule.scheduleType.rawValue, forKey: "type")
            schedule.setValue(habit.schedule.dayArrayToString(), forKey: "days")
            schedule.setValue(habit.uid, forKey: "habitUID")
            
            coreHabit.setValue(schedule, forKey: "schedule")
            
            //Plant
            coreHabit.setValue(habit.plantType, forKey: "plantType")
            coreHabit.setValue(habit.plantStatus.rawValue, forKey: "plantStatus")
            
            
        }
        
        do{
            try managedContext.save()
            
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
            throw DataError.SavingError
        }
        
    }

}
