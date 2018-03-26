//
//  TableViewCell.swift
//  PresentsReminder
//
//  Created by Prateek Sharma on 24/03/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var subHeading: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let color = lineView.backgroundColor
        super.setSelected(selected, animated: animated)
        
        if selected {
            lineView.backgroundColor = color
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let color = lineView.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            lineView.backgroundColor = color
        }
    }
    
}
