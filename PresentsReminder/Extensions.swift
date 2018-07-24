//
//  Extensions.swift
//  PresentsReminder
//
//  Created by Prateek Sharma on 7/3/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import Foundation

extension Date
{
    func toString(dateFormat: String = "dd-mm-yyyy") -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
    
}

extension String {
    
    func toDate(dateFormat: String = "dd-mm-yyyy") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat //Your date format
        return dateFormatter.date(from: self)
    }
    
}
