//
//  PresentsList+CoreDataProperties.swift
//  PresentsReminder
//
//  Created by Prateek Sharma on 24/03/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//
//

import Foundation
import CoreData


extension PresentsList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PresentsList> {
        return NSFetchRequest<PresentsList>(entityName: "PresentsList")
    }

    @NSManaged public var image: NSData?
    @NSManaged public var personName: String?
    @NSManaged public var gift: String?

}
