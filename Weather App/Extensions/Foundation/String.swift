//
//  String.swift
//  Weather App
//
//  Created by Radek Herold on 20.03.2021.
//

import Foundation

extension String {
    var dateItem: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: self) ?? Date()
    }
    
    var formatDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.date(from: self) ?? Date()
    }
    
    var formatTime: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.date(from: self) ?? Date()
    }
    
    var localize: String {
        NSLocalizedString(self, comment: self)
    }
}
