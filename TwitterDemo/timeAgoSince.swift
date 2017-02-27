//
//  timeAgoSince.swift
//  TwitterDemo
//
//  Created by Victoria Zhou on 2/26/17.
//  Copyright © 2017 Victoria Zhou. All rights reserved.
//

import Foundation


/* Credits to https://github.com/zemirco/swift-timeago/blob/master/swift-timeago/TimeAgo.swift */
public func timeAgoSince(_ date: Date) -> String {
    
    let calendar = Calendar.current
    let now = Date()
    let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
    let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
    
    if let year = components.year, year >= 2 {
        return "\(year)y"
    }
    
    if let year = components.year, year >= 1 {
        return "1y"
    }
    
    if let month = components.month, month >= 2 {
        return "\(month)mo"
    }
    
    if let month = components.month, month >= 1 {
        return "1mo"
    }
    
    if let week = components.weekOfYear, week >= 2 {
        return "\(week)w"
    }
    
    if let week = components.weekOfYear, week >= 1 {
        return "1w"
    }
    
    if let day = components.day, day >= 2 {
        return "\(day)d"
    }
    
    if let day = components.day, day >= 1 {
        return "1d"
    }
    
    if let hour = components.hour, hour >= 2 {
        return "\(hour)h"
    }
    
    if let hour = components.hour, hour >= 1 {
        return "1h"
    }
    
    if let minute = components.minute, minute >= 2 {
        return "\(minute)m"
    }
    
    if let minute = components.minute, minute >= 1 {
        return "1m"
    }
    
    if let second = components.second, second >= 3 {
        return "\(second)s"
    }
    
    return "Just now"
    
}
