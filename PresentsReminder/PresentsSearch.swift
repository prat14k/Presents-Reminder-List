//
//  PresentsSearch.swift
//  PresentsReminder
//
//  Created by Prateek Sharma on 24/03/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices
import CoreData
import Intents

extension PresentsList {
    
    static let domainName = "prat14k.PresentsSearch"
    
    var userInfoDict : [AnyHashable : Any] {
        return ["title" : personName ?? "Name" , "uid" : uid!, "dateToGive": dateToGive ?? Date()]
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
    
    func removeIndexFromSearch() {
        CSSearchableIndex.default().deleteSearchableItems(withDomainIdentifiers: [PresentsList.domainName]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    
}



extension PresentsList {
    
    var intent: PresentReminderIntent {
        let presentIntent = PresentReminderIntent()
        presentIntent.personName = personName
        presentIntent.presentName = gift
        presentIntent.dateToGive = dateToGive?.toString()
        presentIntent.uid = uid
        return presentIntent
    }
    static func present(from intent: PresentReminderIntent) -> PresentsList? {
        guard let presentUID = intent.uid  else { return nil }
        return loadSpecificManagedObject(withUID: presentUID)
    }
    
}


extension PresentsList {
    
    static func loadSpecificManagedObject(withUID uid : String) -> PresentsList? {
        guard let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        else { return nil }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: NSStringFromClass(PresentsList.self), in: managedObjectContext)
        
        fetchRequest.returnsObjectsAsFaults = false
        
        fetchRequest.predicate = NSPredicate(format: "uid == %@", uid)
        
        do {
            if let data = try managedObjectContext.fetch(fetchRequest) as? [PresentsList] {
                return data.first
            }
        }
        catch {
            print("Unable To Fetch single entry \(error.localizedDescription)")
        }
        return nil
    }
    
    func donatePresentToSiri() {
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.donate { (error) in
            print(error != nil ? "Error: \(error!.localizedDescription)" : "Successful")
        }
    }
    
}
