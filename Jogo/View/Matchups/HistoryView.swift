//
//  HistoryView.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/22/24.
//

import SwiftUI

struct HistoryView: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("Your History").titleStyle()
            HStack {
                Text("Wins - 6").foregroundColor(.green)
                Spacer()
                Text("2  - Losses").foregroundColor(.red)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(.systemBackground))
                .shadow(radius: 5)
        )
        .padding()
    }
}

#Preview {
    HistoryView()
}
