//
//  PAHPlant.swift
//  PlantAHabit
//
//  Created by Ya Kao on 3/25/16.
//  Copyright © 2016 Ya Kao. All rights reserved.
//

/// This is Plant class
import UIKit

//enum: plant growth type (corresponding to image)

class PAHPlant: NSObject {
    
    //TODO: Add more status in the future?
    enum Growth{
        case None, Baby, Teen, Adult, Flower, Fruit
        
        mutating func next(){
            switch self{
            case .None:
                self = .Baby
            case .Baby:
                self = .Teen
            case .Teen:
                self = .Adult
            case .Adult:
                self = .Flower
            case .Flower:
                self = .Fruit
            case .Fruit: //Basically the top most status...
                self = .Fruit
            }
            
        }
        
        mutating func back(){
            switch self{
            case .None:
                self = .None
            case .Baby:
                self = .None
            case .Teen:
                self = .Baby
            case .Adult:
                self = .Teen
            case .Flower:
                self = .Adult
            case .Fruit:
                self = .Flower
            }
        }
        
    }

    //Plant type:
    //ie. if type is "tullip", then plant growth image is type+growthEnum
    // "tullip" + "-" + "baby"  = imageNamed: "tullip-baby"
    
    //Once this is set, we cannot change the type of plant
    let type: String
    //Default
    //Usage: growthStatus.next() to advance type
    var growthStatus: Growth = .None
    
    init(plantType: String){
        
        self.type = plantType
    }

}
