//
//  PresentsSearch.swift
//  PresentsReminder
//
//  Created by Prateek Sharma on 24/03/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import Foundation
import CoreSpotlight
import MobileCoreServices

extension PresentsList {
    
    static let domainName = "prat14k.PresentsSearch"
    
    var userInfoDict : [AnyHashable : Any] {
        return [ "title" : personName ?? "Name" ]
    }
    
    var userActivity : NSUserActivity {
        let userActivity = NSUserActivity(activityType: PresentsList.domainName)
        userActivity.title = personName
        userActivity.userInfo = userInfoDict
        userActivity.keywords = ["presents" , personName! , gift! , "gifts"]
        
        userActivity.contentAttributeSet = attributeSet
        
        return userActivity
    }
    
    var attributeSet : CSSearchableItemAttributeSet {
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeContent as String)
        attributeSet.title = personName
        attributeSet.contentDescription = gift
        attributeSet.thumbnailData = image
        attributeSet.keywords = ["presents" , personName! , gift! , "gifts"]
        
        return attributeSet
    }
}
