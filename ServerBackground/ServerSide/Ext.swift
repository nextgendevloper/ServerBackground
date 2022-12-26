//
//  Ext.swift
//  ServerBackground
//
//  Created by zmobile on 22/12/22.
//

import Foundation
func getCurrentShortDate() -> String {
    var todaysDate = NSDate()
    var dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy"
    var DateInFormat = dateFormatter.string(from: todaysDate as Date)

    return DateInFormat
}
