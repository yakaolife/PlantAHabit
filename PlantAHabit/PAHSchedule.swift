//
//  PAHSchedule.swift
//  PlantAHabit
//
//  Created by Ya Kao on 3/25/16.
//  Copyright © 2016 Ya Kao. All rights reserved.
//

import UIKit

class PAHSchedule: NSObject {
    
    enum Schedule{
        case Daily, Weekly, Monthly
    }
    
    //["M", "T", "W", "Th", "F", "Sa", "S"]
    var days: [String] = [String]()
    var scheduleType: Schedule = .Daily
    
    init(type: Schedule, days: [String]){
        self.scheduleType = type
        self.days = days
    }
    

    
}
