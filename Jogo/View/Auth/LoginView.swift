//
//  LoginView.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/20/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject var authViewModel: AuthenticationViewModel
    @State private var phoneNumber: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = "" // New state variable for error message
    @State var shouldNavigateBack:Bool = false
    private func formatPhoneNumber() {
        // Remove non-numeric characters from the phone number
        let cleanedPhoneNumber = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()

        // Format the phone number as xxx-xxx-xxxx
        var formattedNumber = ""
        for (index, digit) in cleanedPhoneNumber.enumerated() {
            if index == 3 || index == 6 {
                formattedNumber += "-"
            }
            formattedNumber.append(digit)
        }

        // Update the state with the formatted phone number
        phoneNumber = formattedNumber
    }

    private func formattedPhoneNumber() -> String {
        // Return the formatted phone number
        return phoneNumber
    }

    var body: some View {
        NavigationView {
            VStack {
                Image("Logo")
                    .resizable()
                    .cornerRadius(20)
                    .frame(width: 100, height: 100)
                    .padding()
                
                TextField("Phone Number", text: $phoneNumber).onChange(of: phoneNumber, perform: { _ in
                    // Format the phone number as the user types
                    formatPhoneNumber()
                }).keyboardType(.numberPad)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .padding(.horizontal, 20).autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .autocapitalization(.none)
                    .padding(.horizontal, 20)
                
                // Show error message if there is one
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                HStack{
                    Button("Login") {
                        // Attempt login and handle error
                        authViewModel.login(phone_number: phoneNumber, password: password) { error in
                            if let error = error {
                                errorMessage = error.localizedDescription
                            } else {
                                // Clear error message on successful login
                                errorMessage = ""
                            }
                        }
                    }.font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [ColorTheme.secondary, ColorTheme.primary]), startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 15)
                    
                    NavigationLink(destination: SignUpFormView(authViewModel: authViewModel, shouldNavigateBack: $shouldNavigateBack), isActive: $shouldNavigateBack) {
                        Text("Sign Up")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [ColorTheme.secondary, ColorTheme.primary]), startPoint: .leading, endPoint: .trailing)
                            )
                            .cornerRadius(10)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 15)
                    }
                }
                Spacer()
            }.navigationBarTitle("Login")
            Spacer()
        }
    }
}



#Preview {
    LoginView(authViewModel: AuthenticationViewModel())
}
