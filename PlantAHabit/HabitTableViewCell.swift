//
//  HabitTableViewCell.swift
//  PlantAHabit
//
//  Created by Ya Kao on 3/26/16.
//  Copyright © 2016 Ya Kao. All rights reserved.
//

import UIKit


class HabitTableViewCell: SWTableViewCell {

    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var habitTitle: UILabel!
    
    //Cannot use for display, just for sending the data to edit later
    var habit: PAHHabit?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
