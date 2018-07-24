//
//  PresentsViewController.swift
//  PresentsReminder
//
//  Created by Prateek Sharma on 25/03/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import UIKit

class PresentsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var giftName: UILabel!
    @IBOutlet weak var dateToGiveGiftLabel: UILabel!
    
    var present : PresentsList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        personName.text = present?.personName
        giftName.text = present?.gift
        dateToGiveGiftLabel.text = present?.dateToGive?.toString()
        imageView.image = UIImage(data: (present?.image!)!)
        
        let activity = present?.userActivity
        activity?.isEligibleForSearch = true
        activity?.contentAttributeSet?.relatedUniqueIdentifier = nil
        activity?.isEligibleForPrediction = true
        
        userActivity = activity
    }
    
    override func updateUserActivityState(_ activity: NSUserActivity) {
        activity.addUserInfoEntries(from: (present?.userInfoDict)!)
    }
    
}
