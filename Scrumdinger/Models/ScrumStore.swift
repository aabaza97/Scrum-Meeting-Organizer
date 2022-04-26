//
//  ScrumStore.swift
//  Scrumdinger
//
//  Created by Ahmed Abaza on 26/04/2022.
//

import SwiftUI

class ScrumStore: ObservableObject {
    @Published var scrums: [DailyScrum] = []
    
    ///Retrieves the URL of the data store from documents directory if found. Creates it, otherwise.
    private static func fileURL() throws -> URL {
        try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent("scrums.data")
    }
    
    static func load() async throws -> [DailyScrum] {
        try await withCheckedThrowingContinuation { continuation in
            load { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let scrums):
                    continuation.resume(returning: scrums)
                }
            }
        }
    }
    
    
    
    ///Loads the data from the data store if found.
    static func load(completion: @escaping (Result<[DailyScrum], Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let url = try fileURL()
                guard let file = try? FileHandle.init(forReadingFrom: url) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let scrums = try JSONDecoder().decode([DailyScrum].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(scrums))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    @discardableResult
    static func save(scrums: [DailyScrum]) async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            save(scrums: scrums) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let scrumsSaved):
                    continuation.resume(returning: scrumsSaved)
                }
            }
        }
    }
    
    ///Saves the user's data to the file system.
    static func save(scrums: [DailyScrum], completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(scrums)
                let fileURL = try fileURL()
                try data.write(to: fileURL)
                
                DispatchQueue.global(qos: .background).async {
                    completion(.success(scrums.count))
                }
            } catch {
                DispatchQueue.global(qos: .background).async {
                    completion(.failure(error))
                }
            }
        }
    }
}
