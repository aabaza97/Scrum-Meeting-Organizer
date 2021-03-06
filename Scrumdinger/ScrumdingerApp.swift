//
//  ScrumdingerApp.swift
//  Scrumdinger
//
//  Created by Ahmed Abaza on 24/04/2022.
//

import SwiftUI

@main
struct ScrumdingerApp: App {
    
    @StateObject private var store = ScrumStore()
    
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ScrumsListView(scrums: $store.scrums) {
//                    ScrumStore.save(scrums: store.scrums) { result in
//                        if case .failure(let error) = result {
//                            print(error.localizedDescription)
//                        }
//                    }
                    
                    Task {
                        do {
                            try await ScrumStore.save(scrums: store.scrums)
                        } catch {
                            fatalError("Error saving scrums.")
                        }
                    }
                }
                .background(Color.black)
            }
            .task {
                do {
                    store.scrums = try await ScrumStore.load()
                } catch {
                    print(error.localizedDescription)
                }
            }
//            .onAppear {
//                ScrumStore.load { loadResult in
//                    switch loadResult {
//                    case .failure(let error):
//                        print(error.localizedDescription)
//                    case .success(let scrums):
//                        store.scrums = scrums
//                    }
//                }
//            }
        }
    }
}
