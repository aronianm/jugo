//
//  SplashScreen.swift
//  Fogo
//
//  Created by Michael Aronian Aronian on 2/13/24.
//

import SwiftUI

struct SplashScreen: View {
    @State private var isWiggling = false
    
    var body: some View {
        HStack{
            Spacer()
            VStack {
                Spacer()
                HStack{
                    Text("Fogo")
                        .font(Font.custom("PixelFont", size: 90))
                        .foregroundColor(ColorTheme.background).bold()
                }
                Spacer()
                LogoView()
                    .scaleEffect(isWiggling ? 1.2 : 1.0) // Scale up when wiggling
                    .rotationEffect(Angle(degrees: isWiggling ? 10 : 0)) // Rotate when wiggling
                    .animation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isWiggling) // Apply wiggling animation
                Spacer()
            }
            .onAppear {
                isWiggling = true // Start wiggling animation when view appears
            }
            Spacer()
        }.background(ColorTheme.white)
    }
}

struct LogoView: View {
    var body: some View {
        // Replace this with your logo image
        Image("Logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100)
            .foregroundColor(.blue)
            .cornerRadius(20)
    }
}

#Preview {
    SplashScreen()
}
