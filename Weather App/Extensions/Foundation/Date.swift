//
//  Date.swift
//  Weather App
//
//  Created by Radek Herold on 21.03.2021.
//

import Foundation

extension Date {
    var dayOfWeek: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
    
    var dateComponents: DateComponents {
        let calendar = Calendar.current
        return calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
    }
}
