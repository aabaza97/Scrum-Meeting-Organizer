//
//  ScrumsListView.swift
//  Scrumdinger
//
//  Created by Ahmed Abaza on 24/04/2022.
//

import SwiftUI

struct ScrumsListView: View {
    @Binding var scrums: [DailyScrum]
    @State private var isPresentingNewScrumView = false
    @State private var newScrumData = DailyScrum.Data()
    
    @Environment(\.scenePhase) private var scenePhase
    
    let saveAction: ()->Void
    
    var body: some View {
        List {
            ForEach($scrums) { $scrum in
                NavigationLink(destination: ScrumDetailView(scrum: $scrum)) {
                    CardView(scrum: scrum)
                }
                .listRowBackground(scrum.theme.mainColor)
                .listRowSeparator(.hidden)
            }
            .onDelete { index in
                self.scrums.remove(atOffsets: index)
                self.deleteScrum()
            }
        }
        .navigationTitle("Daily Scrums")
        .toolbar {
            Button(action: {isPresentingNewScrumView = true}) {
                Image(systemName: "plus")
            }
            .accessibilityLabel("New Scrum")
        }
        .sheet(isPresented: $isPresentingNewScrumView) {
            NavigationView {
                ScrumDetailEditView(data: $newScrumData)
                    .navigationTitle("New Meeting")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Dismiss") {
                                isPresentingNewScrumView = false
                                newScrumData = .init()
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                let newScrum = DailyScrum(data: newScrumData)
                                scrums.append(newScrum)
                                isPresentingNewScrumView = false
                                newScrumData = .init()
                            }
                        }
                    }
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
        
    }
    
    
    private func deleteScrum() -> Void {
        Task {
            do {
                try await ScrumStore.save(scrums: self.scrums)
            } catch {
                fatalError("Error saving scrums.")
            }
        }
    }
}

struct ScrumsListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ScrumsListView(
                scrums: .constant(DailyScrum.sampleData),
                saveAction: {}
            )
        }
        .preferredColorScheme(.light)
    }
}
