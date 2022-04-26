//
//  RolePickerView.swift
//  Scrumdinger
//
//  Created by Ahmed Abaza on 26/04/2022.
//

import SwiftUI

struct RolePickerView: View {
    
    @Binding var selectedRole: ScrumRole
    
    
    var body: some View {
        Picker("Role", selection: $selectedRole) {
            ForEach(ScrumRole.allCases) { role in
                HStack {
                    Image(systemName: "gearshape.2")
                        .padding([.trailing], 8.0)
                    Label(role.name, systemImage: "")
                        .font(.headline)
                        .labelStyle(.titleOnly)
                }
                .tag(role)
            }
        }
    }
}

struct RolePickerView_Previews: PreviewProvider {
    static var previews: some View {
        RolePickerView(selectedRole: .constant(.unspecified))
    }
}
