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
    
    
    //Prevents other people using default init()
    private init() {
       managedContext = appDelegate.managedObjectContext
    }
    
    func fetchData(entityName: String)->[NSManagedObject]{
        
        let fetchRequest = NSFetchRequest(entityName: entityName)
        var data = [NSManagedObject]()
        
        do{
            let results = try managedContext.executeFetchRequest(fetchRequest)
            data =  results as! [NSManagedObject]
            
        }catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
            
        }
        
        return data
    }
    
    
    
    
    

}
