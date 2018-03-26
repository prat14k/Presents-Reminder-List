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
        return [ "title" : personName ?? "Name" , "uid" : uid! ]
    }
    
    var userActivity : NSUserActivity {
//        let identifier = "\(PresentsList.domainName)_\(uid!)"
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

    
    func removeIndexFromSearch() {
        
//        let identifier = "\(PresentsList.domainName)_\(uid!)"
        
        CSSearchableIndex.default().deleteSearchableItems(withDomainIdentifiers: [PresentsList.domainName]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    
}
