//
//  DailyScrum.swift
//  Scrumdinger
//
//  Created by Ahmed Abaza on 24/04/2022.
//

import Foundation


struct DailyScrum: Identifiable, Codable {
    
    //MARK: - Associated Types
    struct Data: Codable {
        var title: String = .emptyString
        var attendees: [ScrumPerson] = []
        var lengthInMinutes: Double = 5.0
        var theme: Theme = .seafoam
    }
    
    //MARK: Properties
    var id: UUID = .init()
    var title: String
    var attendees: [ScrumPerson]
    var lengthInMinutes: Int
    var theme: Theme
    var history: [ScrumHistory] = []
    
    //MARK: - Initializers
    init(id: UUID = UUID(), title: String, attendees: [ScrumPerson], lengthInMinutes: Int, theme: Theme) {
        self.id = id
        self.title = title
        self.attendees = attendees
        self.lengthInMinutes = lengthInMinutes
        self.theme = theme
    }
    
    init(data: Data) {
        id = UUID()
        title = data.title
        attendees = data.attendees
        lengthInMinutes = Int(data.lengthInMinutes)
        theme = data.theme
    }
}


extension DailyScrum {
    static let sampleData: [DailyScrum] = [
        .init(title: "Design", attendees: ScrumPerson.peopleEnrolled.filter { $0.role == .design} , lengthInMinutes: 10, theme: .yellow),
        .init(title: "App Dev", attendees: ScrumPerson.peopleEnrolled.filter { $0.role == .dev} , lengthInMinutes: 5, theme: .orange),
        .init(
            title: "Operations",
            attendees: ScrumPerson.peopleEnrolled.filter { $0.role == .master || $0.role == .humanResources || $0.role == .ops},
            lengthInMinutes: 5, theme: .poppy
        )
    ]
    
}

extension DailyScrum {
    
    
    var data: Data {
        Data(title: title, attendees: attendees, lengthInMinutes: Double(lengthInMinutes), theme: theme)
    }
    
    
    mutating func update(from data: Data) {
        title = data.title
        attendees = data.attendees
        lengthInMinutes = Int(data.lengthInMinutes)
        theme = data.theme
    }
}


struct ScrumPerson: Identifiable, Codable {
    var id: UUID = .init()
    var name: String
    var role: ScrumRole
    
    static let peopleEnrolled: [ScrumPerson] = [
        .init(name: "Cathy", role: .design),
        .init(name: "Daisy", role: .design),
        .init(name: "Simon", role: .design),
        .init(name: "Abaza", role: .dev),
        .init(name: "Markus", role: .dev),
        .init(name: "Omar", role: .dev),
        .init(name: "Christine", role: .humanResources),
        .init(name: "John", role: .humanResources),
        .init(name: "Daniel", role: .master),
        .init(name: "Sarah", role: .ops),
        .init(name: "Kate", role: .ops),
    ]
}


enum ScrumRole: String, CaseIterable,Identifiable, Codable {
    case design
    case dev
    case humanResources
    case master
    case ops
    case unspecified
    
    var name: String {
        rawValue.capitalized
    }
    
    var id: String {
        name
    }
}


extension String {
    static let emptyString: String = ""
    
    mutating func clear() -> Void {
        self = .emptyString
    }
    
//    mutating func clear() -> Self {
//        let oldValue = self
//        self = .emptyString
//        return oldValue
//    }
}
