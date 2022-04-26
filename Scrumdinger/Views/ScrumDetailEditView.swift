//
//  ScrumDetailEditView.swift
//  Scrumdinger
//
//  Created by Ahmed Abaza on 25/04/2022.
//

import SwiftUI

struct ScrumDetailEditView: View {
    
    @Binding var data: DailyScrum.Data
    @State private var newAttendeeName: String = .emptyString
    @State private var newAttendeeRole: ScrumRole = .unspecified
    
    var body: some View {
        
        Form {
            Section(header: Text("Meeting Info")) {
                TextField("Title", text: $data.title)
                    .padding(8.0)
                HStack {
                    Slider(value: $data.lengthInMinutes, in: 5...30, step: 1) {
                        Text("Length")
                    }
                    .accessibilityValue("\(Int(data.lengthInMinutes)) minutes")
                    Spacer()
                    
                    Text("\(Int(data.lengthInMinutes)) minutes")
                        .accessibilityHidden(true)
                }
                .padding(8.0)
                
                ThemePickerView(selectedTheme: $data.theme)
                    .padding(8.0)
            }
            
            Section(header: Text("People in Meeting")) {
                if (data.attendees.count == 0) {
                    Label("No peope added yet",
                          systemImage: "person.crop.circle.badge.exclamationmark.fill"
                    )
                    .padding(8.0)
                }
                ForEach(data.attendees) { attendee in
                    HStack {
                        Label(attendee.name, systemImage: "person")
                            .padding(8.0)
                        Spacer()
                        Text(attendee.role.name)
                            .font(.footnote)
                    }
                }
                .onDelete { indexSet in
                    data.attendees.remove(atOffsets: indexSet)
                }
            }
            
            Section (header: Text("Add People")){
                TextField("New Attendee", text: $newAttendeeName)
                    .padding(8.0)
                
                RolePickerView(selectedRole: $newAttendeeRole)
                    .padding(8.0)
                
                Button(action: {
                    withAnimation {
                        let attendee = ScrumPerson.init(name: newAttendeeName, role: newAttendeeRole)
                        self.data.attendees.append(attendee)
                        self.newAttendeeName.clear()
                    }
                }) {
                    HStack {
                        Text("Add To Meeting")
                        Spacer()
                        Image(systemName: "plus.circle.fill")
                    }
                    .accessibilityLabel("Add attendee")
                }
                .disabled(newAttendeeName.isEmpty)
                .disabled(newAttendeeRole == .unspecified)
            }
        }
    }
}

struct ScrumDetailEditView_Previews: PreviewProvider {
    static var previews: some View {
        ScrumDetailEditView(data: .constant(DailyScrum.sampleData[0].data))
    }
}
