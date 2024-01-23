//
//  View+NavTitle.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/20/24.
//

import Foundation
import SwiftUI

extension View {
    func navigationTitleView<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        self.overlay(

                HStack {
                    Spacer()
                    content()
                        .foregroundColor(.primary)
                        .font(.headline)
                        .padding()
                }
            
        )
    }
}
