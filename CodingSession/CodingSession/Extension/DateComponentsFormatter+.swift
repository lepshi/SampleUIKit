//
//  DateComponentsFormatter.swift
//  CodingSession
//
//  Created by Dzmitry Pats on 15.11.24.
//

import Foundation

extension DateComponentsFormatter {
    static var timeFormatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        formatter.unitsStyle = .positional
        return formatter
    }
}
