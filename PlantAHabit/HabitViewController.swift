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
            habitTitleTextField.placeholder = h.title
            
            self.title = "\(h.title)"
            print("Habit title is \(h.title)")
        }else{
            //New Habit view!
            
            //Hide the delete button!
            deleteButton.hidden = true
            
            habit = PAHHabit(title: "New Habit Title", note: "Note", schedule: PAHSchedule(type:             PAHSchedule.Schedule.Daily, days: ["M"]))
            
            habitTitleTextField.placeholder = habit?.title
            
            self.title = "New Habit"
            print("New Habit!")
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
        //Save the habit!
        habit?.title = habitTitleTextField.text!
        
        //Check if there's a duplicate!!
        let predicate = NSPredicate(format: "title == %@", habitTitleTextField.text!)
        let foundHabit = dataStore.fetchData("Habit", predicate: predicate)
        
        if foundHabit.count != 0{
            print("Duplicate Habit title!, edit")
            //TODO: add a error message in UI!
            
            
        }else{
            let coreHabit = dataStore.getMangedObjectToSet("Habit")
            
            coreHabit.setValue(habit?.title, forKey: "title")
            
            do{
                try dataStore.managedContext.save()
                
            }catch let error as NSError{
                print("Could not save \(error), \(error.userInfo)")
            }
            
            //dismiss the viewController!
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        

    }

    @IBAction func deleteHabit(sender: UIButton) {
        
        //Find the one we want to remove
        let predicate = NSPredicate(format: "title == %@", habitTitleTextField.text!)
        let coreHabits = dataStore.fetchData("Habit", predicate: predicate)
        
        for habit in coreHabits{
            if let habitTitle = habit.valueForKey("title") as? String{
                if habitTitle == habitTitleTextField.text! {
                    //Found and delete
                    dataStore.managedContext.deleteObject(habit)
                }
            }
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
