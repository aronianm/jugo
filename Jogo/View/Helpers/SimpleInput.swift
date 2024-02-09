//
//  SimpleInput.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/20/24.
//

import SwiftUI

struct SimpleInput: View {
    @Binding var text: String
    var title: String = ""

    var body: some View {
        VStack {
            TextField(title, text: $text)
                .padding()
                
        }.cornerRadius(21.0)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .autocapitalization(.none)
            .padding(.horizontal, 20)
            .foregroundColor(.black)
    }
}
#Preview {
    SimpleInput(text: .constant("Fname"))
}
