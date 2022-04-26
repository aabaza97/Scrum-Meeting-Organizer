//
//  ScrumHistory.swift
//  Scrumdinger
//
//  Created by Ahmed Abaza on 26/04/2022.
//

import Foundation


struct ScrumHistory: Identifiable, Codable {
    let id: UUID
    let date: Date
    var attendees: [ScrumPerson]
    var lengthInMinutes: Int
    
    init(id: UUID = UUID(), date: Date = Date(), attendees: [ScrumPerson], lengthInMinutes: Int = 5) {
        self.id = id
        self.date = date
        self.attendees = attendees
        self.lengthInMinutes = lengthInMinutes
    }
}
