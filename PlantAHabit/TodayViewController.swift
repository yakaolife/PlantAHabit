//
//  TodayViewController.swift
//  PlantAHabit
//
//  Created by Ya Kao on 3/26/16.
//  Copyright © 2016 Ya Kao. All rights reserved.
//

import UIKit
import CoreData


class TodayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var naviBar: UINavigationBar!
    
    //var habits = [PAHHabit]()
    var coreHabits = [NSManagedObject]()
    let dataStore = PAHDataStore.sharedInstance
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
     
        //init the tab bar item so it will show up on the tab when first loaded
        //TODO: change into custom icon
        tabBarItem = UITabBarItem(title: "Today", image: UIImage(named: "list-fat-7"), tag: 1)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Today"
        naviBar.topItem?.title = "Today"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadCoreData()
        
        tableView.reloadData()
    }
    
    //For updating after we just Add/Edit Habit
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadCoreData()
        tableView.reloadData()
    }
    
    //Load from Core Data
    func loadCoreData(){
        coreHabits = dataStore.fetchData("Habit", predicate: nil)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return coreHabits.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        var cell = tableView.dequeueReusableCellWithIdentifier("HabitCell", forIndexPath: indexPath) as! HabitTableViewCell
        //SWTableViewCell add a selection style, remove it for now
        cell.selectionStyle = .None
        cell.rightUtilityButtons = self.addRightUtilityButtonsToCell() as [AnyObject]
        let coreData = coreHabits[indexPath.row] //Core data
        
        let habit = PAHHabit(coreDataObj: coreData)
        
        cell.habit = habit
        cell.habitTitle.text = habit.title
        
        return cell
    }
    
    //Because we added SWTableViewCell, we have to trigger the segue manuall
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("EditHabitSegue", sender: tableView.cellForRowAtIndexPath(indexPath))
    }
    
    func addRightUtilityButtonsToCell() -> NSMutableArray{
        var buttons: NSMutableArray = NSMutableArray()
        buttons.sw_addUtilityButtonWithColor(UIColor.greenColor(), title: "Done")
        buttons.sw_addUtilityButtonWithColor(UIColor.redColor(), title: "Skip")
        
        return buttons
    }
    
//    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
//        
//        //Done
//        let done = UITableViewRowAction(style: .Normal, title: "Done") { (<#UITableViewRowAction#>, <#NSIndexPath#>) in
//            <#code#>
//        }
//        
//        //Skip
//        
//        //<#T##(UITableViewRowAction, NSIndexPath) -> Void#>
//    }
//    
//    func habitDone(rowAction)
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "EditHabitSegue"{
            if let destination = segue.destinationViewController as? HabitViewController{
                let index = tableView.indexPathForSelectedRow?.row
                let coreData = coreHabits[index!]
                let habit = PAHHabit(coreDataObj: coreData)
                
                destination.habit = habit
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
