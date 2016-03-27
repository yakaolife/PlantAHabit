//
//  HabitViewController.swift
//  PlantAHabit
//
//  Created by Ya Kao on 3/26/16.
//  Copyright © 2016 Ya Kao. All rights reserved.
//

import UIKit
import CoreData

//This viewController is used for both adding New Habit and also Edit/Detail view
//We'll set a variable to see if this is new (don't populate or not), or if habit is not passed in, then assuming this is new

class HabitViewController: UIViewController {
    
    //TODO: How to initialize?
    var habit: PAHHabit?
    var dataStore = PAHDataStore.sharedInstance
    var isEdit = false
    
    @IBOutlet weak var habitTitleTextField: UITextField!
    @IBOutlet weak var naviBar: UINavigationBar!
    @IBOutlet weak var deleteButton: UIButton!

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //init the tab bar item so it will show up on the tab when first loaded
        //TODO: change into custom icon
        tabBarItem = UITabBarItem(title: "New", image: UIImage(named: "plus-simple-7"), tag: 2)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let h = habit{
            //Edit/Detail view! Populate all the fields
            isEdit = true
            habitTitleTextField.text = h.title
            
            self.title = "\(h.title)"
            //print("Habit title is \(h.title)")
        }else{
            //New Habit view!
            
            //Hide the delete button!
            deleteButton.hidden = true
            
            habit = PAHHabit(title: "New Habit Title", note: "Note", schedule: PAHSchedule(type:             PAHSchedule.Schedule.Daily, days: ["M"]))
            
            habitTitleTextField.placeholder = habit?.title
            
            self.title = "New Habit"
            //print("New Habit!")
        }
        
        
        //Customizing the navigation bar
        
        let back = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(HabitViewController.dismiss(_:)))
        
        let save = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(HabitViewController.saveHabit))
        
        naviBar.topItem?.leftBarButtonItem = back
        naviBar.topItem?.rightBarButtonItem = save
        
        
    }
    
    func dismiss(sender: UIBarButtonItem){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    func saveHabit(){
        
        //TODO: Data validation! (empty title, etc)
        //Check if the new title (New Habit or Edit Habit) is duplicate with other in the core data
        let predicate = NSPredicate(format: "title == %@", habitTitleTextField.text!)
        let duplicate = dataStore.fetchData("Habit", predicate: predicate)
        
        if duplicate.count != 0{
            //The title is not good
            print("Duplicate Habit title with existing other habit!, edit")
            //TODO: add a error message in UI!
            habitTitleTextField.text = habitTitleTextField.text! + "-Title already exist!"
            
            return
        }
        
        if isEdit{
            //Find the original in Core Data to edit
            let predicate = NSPredicate(format: "title == %@", (habit?.title)!)
            let foundHabit = dataStore.fetchData("Habit", predicate: predicate)
            
            if foundHabit.count == 1{
                //Found the one we want to edit!
                foundHabit[0].setValue(habitTitleTextField.text, forKey: "title")
            }
            
        }else{
            //Save the habit!
            let coreHabit = dataStore.getMangedObjectToSet("Habit")
            coreHabit.setValue(habitTitleTextField.text!, forKey: "title")
        
        }
        
        do{
            try dataStore.managedContext.save()
            
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
        //dismiss the viewController!
        self.dismissViewControllerAnimated(true, completion: nil)

    }

    @IBAction func deleteHabit(sender: UIButton) {
        
        //Find the one we want to remove
        //Use the PAHHabit object's title, in case user already tries to edit the habit and decide to delete it, then we won't have matching title with CoreData and textfield
        let predicate = NSPredicate(format: "title == %@", (habit?.title)!)
        let coreHabits = dataStore.fetchData("Habit", predicate: predicate)
        
        if coreHabits.count == 1{
            //Found
            for habit in coreHabits{
                dataStore.managedContext.deleteObject(habit)
                var success = true
                
                do{
                    try dataStore.managedContext.save()
                    
                }catch let error as NSError{
                    print("Could not delete \(error), \(error.userInfo)")
                    success = false
                }
                
                if success {
                    //dismiss the viewController!
                    self.dismissViewControllerAnimated(true, completion: nil)
                }else{
                    //Display error?
                }
                
            }
        }else{
            print("Cannot find this habit you are deleting! Something is wrong!")
 
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
