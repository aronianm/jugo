//
//  SignUpFormView.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/20/24.
//

import SwiftUI

struct SignUpFormView: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    @State private var phoneNumber: String = ""
    @State private var fname: String = ""
    @State private var lname: String = ""
    @State private var password: String = ""

    
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
            VStack{
                HStack {
                    SimpleInput(text: $phoneNumber, title: "Phone Number").keyboardType(.phonePad).padding().onChange(of: phoneNumber, perform: { _ in
                        // Format the phone number as the user types
                        formatPhoneNumber()
                    })
                }
                HStack{
                    SimpleInput(text: $fname, title: "First").keyboardType(.emailAddress)
                
                    SimpleInput(text: $lname, title: "Last").keyboardType(.emailAddress)
                }.padding()
          
                HStack{
                    SimpleInput(text: $password, title: "Password").padding()
                }
                Spacer()
                Button(action: {
                    // Handle registration action
                    authViewModel.signup(phone_number: phoneNumber, fname: fname, lname: lname, password: password)
                }) {
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .navigationBarTitle("Registration")
        }
    }
}

#Preview {
    SignUpFormView(authViewModel: AuthenticationViewModel())
}
