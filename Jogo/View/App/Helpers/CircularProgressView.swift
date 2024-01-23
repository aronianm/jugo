//
//  CircularProgressView.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/20/24.
//

import SwiftUI

struct CircularProgressView: View {
    @State var progress: CGFloat = 0.9 // Change this value to set the percentage
    
    var color:Color = Color.blue
    var body: some View {
        HStack {
            Text("\(Int(progress * 100))%")
                .font(.title)
            
            ZStack {
                Circle()
                    .stroke(lineWidth: 20.0)
                    .opacity(0.3)
                    .foregroundColor(Color.blue)

                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(color)
                    .rotationEffect(Angle(degrees: -90))
            }
            .padding(20)
        }
    }
}

#Preview {
    CircularProgressView()
}
