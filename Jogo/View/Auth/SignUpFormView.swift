//
//  SignUpFormView.swift
//  Fogo
//
//  Created by Michael Aronian Aronian on 1/20/24.
//

import SwiftUI

import SwiftUI

struct SignUpFormView: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    @State private var phoneNumber: String = ""
    @State private var fname: String = ""
    @State private var lname: String = ""
    @State private var password: String = ""
    @Binding var shouldNavigateBack:Bool
    
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
    let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? "Unknown"
    var body: some View {
        NavigationView {
            VStack{
                Image("Logo")
                    .resizable()
                    .cornerRadius(20)
                    .frame(width: 100, height: 100)
                    .padding()
                HStack {
                    SimpleInput(text: $phoneNumber, title: "Phone Number").keyboardType(.phonePad) .onChange(of: phoneNumber, perform: { _ in
                        // Format the phone number as the user types
                        formatPhoneNumber()
                    })
                }
                HStack{
                    SimpleInput(text: $fname, title: "First").keyboardType(.emailAddress).foregroundColor(.white)
                    SimpleInput(text: $lname, title: "Last").keyboardType(.emailAddress)
                }.padding()
          
                HStack{
                    SimpleInput(text: $password, title: "Password").padding()
                }
                Spacer()
                HStack{
                    VStack{
                        Text("Sign Up Wth")
                        HStack{
                            
                        }
                    }
                }
                Button(action: {
                    // Handle registration action
                    authViewModel.signup(username: deviceID,
                                         fname: fname,
                                         lname: lname,
                                         password: password)
                    // Dismiss the view on successful sign-up
                    shouldNavigateBack = false
                    
                }) {
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(gradient: Gradient(colors: [ColorTheme.secondary, ColorTheme.primary]), startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(8)
                }
            }
        }
    }
}
struct SignUpFormView_Previews: PreviewProvider {
    @State static var shouldNavigateBack = false // Define a state variable for the binding

    static var previews: some View {
        SignUpFormView(authViewModel: AuthenticationViewModel(), shouldNavigateBack: $shouldNavigateBack)
    }
}
