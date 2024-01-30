//
//  CreateMatchView.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/20/24.
//

import SwiftUI
import Contacts


struct CreateMatchView: View {
    @State private var isMessageComposeViewPresented = true
    var contact: CNContact
    @StateObject var authViewModel: AuthenticationViewModel
    @StateObject var matchupManager: MatchupManager
    @Binding var shouldNavigateBack:Bool
    @Binding var isSheetPresented:Bool

    var body: some View {
        NavigationView {
            VStack {
                Text(contact.givenName)
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                    .padding()
                // Access image data and check for availability
                if let imageData = contact.thumbnailImageData, contact.imageDataAvailable {
                    // Use the image data to create a UIImage
                    let uiImage = UIImage(data: imageData)
                    
                    // Display the image using Image view in SwiftUI
                    Image(uiImage: uiImage!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)  // Adjust the frame size as needed
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .shadow(radius: 5)
                } else {
                    Image(systemName: "person.circle.fill")  // You can use any default image system name
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)  // Adjust the frame size as needed
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                .shadow(radius: 5)
                }
                VStack {
                    Text("Challenge User")
                        .font(.title)
                        .foregroundColor(.black)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(contact.phoneNumbers, id: \.identifier) { phoneNumber in
                            HStack {
                                CheckUserView(phoneNumber: phoneNumber.value.stringValue,
                                              shouldNavigateBack: $shouldNavigateBack,
                                              isSheetPresented: $isSheetPresented)
                            }
                        }
                    }
                    .padding()
                    
                    
                }
            }
        }
        .onAppear {
            // Send POST request when the view appears
            matchupManager.checkIfUser(for: contact)
        }
    }

    func sendChallengeRequest() {
        matchupManager.sendChallengeRequest { success in
            matchupManager.isChallengeSent = true
            shouldNavigateBack = false
            isSheetPresented = false
        }
    }
}
