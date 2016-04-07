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

class HabitViewController: UITableViewController {
    
    //TODO: How to initialize?
    var habit: PAHHabit?
    var dataStore = PAHDataStore.sharedInstance
    var isEdit = false
    
    @IBOutlet weak var menuCell: UITableViewCell!
    
    @IBOutlet weak var habitTitleTextField: UITextField!
    //@IBOutlet weak var naviBar: UINavigationBar!
    
    @IBOutlet weak var noteTextField: UITextField!

    @IBOutlet weak var PlantInfoCell: UITableViewCell!
    
    @IBOutlet weak var ChoosePlantCell: UITableViewCell!
    
    @IBOutlet weak var scheduleDailyBtn: UIButton!
    
    @IBOutlet weak var scheduleWeeklyBtn: UIButton!
    
    @IBOutlet weak var scheduleMonthlyBtn: UIButton!
    @IBOutlet weak var deleteCell: UITableViewCell!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //init the tab bar item so it will show up on the tab when first loaded
        //TODO: change into custom icon
        tabBarItem = UITabBarItem(title: "New", image: UIImage(named: "plus-simple-7"), tag: 2)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuCell.backgroundColor = UIColor.blueColor();
        

        // Do any additional setup after loading the view.
        
        if let h = habit{
            //Edit/Detail view! Populate all the fields
            isEdit = true
            habitTitleTextField.text = h.title
            noteTextField.text = h.note
            
            self.title = "\(h.title)"
            
            print("note is \(h.note)")

        }else{
            //New Habit view!
            
            //Hide the delete button!
            //deleteButton.hidden = true
            deleteCell.hidden = true;
            habitTitleTextField.placeholder = "New Habit"
            
            self.title = "New Habit"

        }
        
        //Customizing the navigation bar
        
        let back = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(HabitViewController.dismiss(_:)))
        
        let save = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(HabitViewController.saveHabit))
        
        self.navigationItem.rightBarButtonItem = save
        self.navigationItem.leftBarButtonItem = back
        
        // So we won't show empty cells at the bottom
        tableView.tableFooterView = UIView()
        
        //
//        naviBar.topItem?.leftBarButtonItem = back
//        naviBar.topItem?.rightBarButtonItem = save
        
        
    }
    
    
    @IBAction func dismiss(sender: UIButton) {
         self.dismissViewControllerAnimated(true, completion: nil)
    }
    
//    func dismiss(sender: UIBarButtonItem){
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
    
    //The reason we do this here is because we are only going to do this here...
    //func saveHabit(){
    
    @IBAction func saveHabit(sender: UIButton) {

        if !isEdit{
            habit = PAHHabit(title: habitTitleTextField.text!, note: noteTextField.text!, schedule: PAHSchedule(type:PAHSchedule.Schedule.Daily, days: ["M"]))
        }else{
            //Modify the habit
            habit?.title = habitTitleTextField.text!
            habit?.note = noteTextField.text!
        }
        
        do{
            try dataStore.saveHabit(habit!)
            
        }catch PAHDataStore.DataError.SavingError{
            print("Could not save data!")
            
        }catch{
            print("Could not save data! Other error")
        }
        
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
    

    
    // Mark: TableView functions
    
    //A very hacky way of making static cell disappear on runtime
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        
        if cell.tag == 1{
            //Select Plant cell
            if isEdit{
                return 0
            }else{
                return 100
            }
        }else if cell.tag == 2{
            //Plant info cell
            if !isEdit{
                return 0
            }else{
                return 100
            }
            
        }else if cell.tag == 3 {
            //Delete cell
            if !isEdit{
                return 0
            }
        }
        
        return 50
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
