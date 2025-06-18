//
//  Item.swift
//  Luna
//
//  Created by Christian Francis on 2025-06-18.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
