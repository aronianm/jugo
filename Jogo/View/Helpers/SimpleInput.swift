//
//  SimpleInput.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/20/24.
//

import SwiftUI

struct SimpleInput: View {
    @Binding var text: String
    var title:String = ""

    var body: some View {
        VStack {
            TextField(title, text: $text)
                .autocapitalization(.none) 
                .padding()
                    .cornerRadius(21.0)
                    .overlay(RoundedRectangle(cornerRadius: 21.0).stroke(Color.black, lineWidth: 1))
                    
                    
        }
    }
}

#Preview {
    SimpleInput(text: .constant("Fname"))
}
