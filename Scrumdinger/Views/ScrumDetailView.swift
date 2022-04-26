//
//  ScrumDetailView.swift
//  Scrumdinger
//
//  Created by Ahmed Abaza on 24/04/2022.
//

import SwiftUI

struct ScrumDetailView: View {
    //MARK: - Properties
    @Binding var scrum: DailyScrum
    
    @State private var data: DailyScrum.Data = .init()
    @State private var isEditing: Bool = false
    
    //MARK: - View Heirarchy
    var body: some View {
        List {
            Section(header: Text("Meeting Info")) {
                NavigationLink(destination: MeetingView(scrum: $scrum)) {
                    Label("Start Meeting", systemImage: "timer")
                        .font(.headline)
                    .foregroundColor(.accentColor)
                }
                
                HStack {
                    Label("Length", systemImage: "clock")
                    Spacer()
                    Text("\(scrum.lengthInMinutes) minutes")
                }
                .accessibilityElement(children: .combine)
                
                HStack {
                    Label("Theme", systemImage: "paintpalette")
                    Spacer()
                    Text(scrum.theme.name)
                        .padding(4)
                        .foregroundColor(scrum.theme.accentColor)
                        .background(scrum.theme.mainColor)
                        .cornerRadius(4)
                }
            }
            
            
            Section(header: Text("Attendees")) {
                if (scrum.attendees.count == 0) {
                    Label("No peope added yet",
                          systemImage: "person.crop.circle.badge.exclamationmark.fill"
                    )
                }
                ForEach(scrum.attendees) { attendee in
                    HStack {
                        Label(attendee.name, systemImage: "person")
                        Spacer()
                        Text(attendee.role.name)
                            .padding([.trailing])
                            .font(.footnote)
                    }
                }
            }
            
            Section(header: Text("History")) {
                if scrum.history.isEmpty {
                    Label("No meetings yet", systemImage: "calendar.badge.exclamationmark")
                }
                ForEach(scrum.history) { history in
                    HStack {
                        Image(systemName: "calendar")
                        Text(history.date, style: .date)
                    }
                }
            }
        }
        .listStyle(.sidebar)
        .navigationTitle(scrum.title)
        .toolbar {
            Button("Edit") {
                self.isEditing = true
                self.data = scrum.data
            }
        }
        .sheet(isPresented: $isEditing) {
            NavigationView {
                ScrumDetailEditView(data: $data)
                    .navigationTitle(scrum.title)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                self.isEditing = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                self.isEditing = false
                                scrum.update(from: data)
                            }
                        }
                    }
            }
        }
    }
}

struct ScrumDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ScrumDetailView(scrum: .constant(DailyScrum.sampleData[1]))
        }
    }
}
