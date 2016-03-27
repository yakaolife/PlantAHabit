//
//  TodayViewController.swift
//  PlantAHabit
//
//  Created by Ya Kao on 3/26/16.
//  Copyright © 2016 Ya Kao. All rights reserved.
//

import UIKit
import CoreData


class TodayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate {

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
        cell.delegate = self
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
    
    //Handling the utility button
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        
        print("Click swipebutton")
        
        //TODO: Keep track of which cell is already set Done or Skip! So we can disable the swipe menu, etc
        
        if index == 0 {
            print("Done")
        }else {
            print("Skip")
        }
        
        //For both in UI: gray out the text, set not selectable
        //Cannot use the parameter cell b/c it is in SWTableViewCell :( 
        //Roundabout way to get to HabitTableViewCell
        var cellIndexPath = self.tableView.indexPathForCell(cell)
        var habitCell = self.tableView.cellForRowAtIndexPath(cellIndexPath!) as! HabitTableViewCell
        
        habitCell.habitTitle.textColor = UIColor.lightGrayColor()
        cell.hideUtilityButtonsAnimated(true)
        
        
    }
    
    // prevent multiple cells from showing utilty buttons simultaneously
    func swipeableTableViewCellShouldHideUtilityButtonsOnSwipe(cell: SWTableViewCell!) -> Bool {
        return true
    }
    
//    // utility button open/close event
//    - (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state;
//
//    
//    // prevent cell(s) from displaying left/right utility buttons
//    - (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state;
    
    
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
