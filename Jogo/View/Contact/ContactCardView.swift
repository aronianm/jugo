//
//  ContactCardView.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/20/24.
//

import SwiftUI

struct ContactCardView: View {
    var contact: Contact

    var body: some View {
        VStack {
            Text(contact.name)
                .font(.title)
            Text("Phone: \(contact.phoneNumber)")
        }
        .padding()
        .navigationTitle("Contact Details")
    }
}

#Preview {
    ContactCardView()
}
