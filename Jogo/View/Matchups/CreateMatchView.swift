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
    @State private var isChallengeSent: Bool = false
    @State var userExists:Bool?
    @State var mobileNumber:String?
    var contact: CNContact
    var authViewModel: AuthenticationViewModel
    let baseURL = Environment.apiBaseURL
    var body: some View {
        VStack {
            if(userExists != nil){
                if userExists! {
                    Text("Contact Details \(contact.givenName)")
                        .font(.title)
                        .padding()
                    VStack {
                        Text("Challenge User")

                        Button(action: {
                            // Handle the challenge request logic here
                            sendChallengeRequest()
                        }) {
                            Text("Send Challenge")
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(8)
                        }

                        if isChallengeSent {
                            Text("Challenge Sent!")
                        }
                    }
                    .padding()
                }else{
                    if(mobileNumber != nil){
                        ChallengeNonUserView(isPresented: $isMessageComposeViewPresented, phoneNumber: mobileNumber!)
                        Spacer()
                        
                    }
                }
            }
            // Display contact details here
            
        }.navigationBarBackButtonHidden(true)
        .onAppear {
            // Send POST request when the view appears
            checkIfUser(for: contact)
        }
    }
    
    func findMobileNumber(in phoneNumbers: [CNLabeledValue<CNPhoneNumber>]) -> String? {
        for phoneNumber in phoneNumbers {
            let label = phoneNumber.label ?? ""
            let number = phoneNumber.value.stringValue
            
            if label.lowercased().contains("mobile") {
                return number
            }
            
            // You can customize the conditions based on the label if needed
            // For example, you might check for labels like "iPhone" or "Mobile"
        }
        
        return nil
    }
    
    func sendChallengeRequest() {
        isChallengeSent.toggle()
    }
    
    func checkIfUser(for contact: CNContact) {
        guard let url = URL(string: "\(baseURL)/users/check_user") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(authViewModel.authToken, forHTTPHeaderField: "Authorization")
        
        mobileNumber = findMobileNumber(in: contact.phoneNumbers)
        
        let payload = [
            "phone_number": mobileNumber ?? "",
            "name": contact.givenName
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        } catch {
            print("Error encoding JSON: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Ensure that UI-related tasks are performed on the main thread
            DispatchQueue.main.async {
                if let error = error {
                    print("Error: \(error)")
                    // Handle error scenarios
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Invalid response")
                    // Handle unexpected response scenarios
                    return
                }
                
                print("Status Code: \(httpResponse.statusCode)")
                if(httpResponse.statusCode == 401){
                    authViewModel.logout()
                }
                
                if let data = data {
                    // Parse and handle the response data
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                        if let jsonResponse = jsonResponse as? [String: Any] {
                            // Now jsonResponse is safely cast as a dictionary

                            if let userFound = jsonResponse["user_found"] as? Int {
                                // Use userFound here
                                userExists = userFound == 1
                            } else {
                                // Handle the case where "user_found" is not an integer
                                print("Error: 'user_found' is not an integer")
                            }
                        } else {
                            // Handle the case where jsonResponse is not a dictionary
                            print("Error: jsonResponse is not a dictionary")
                        }
                        // Handle the response data
                    } catch {
                        print("Error decoding response: \(error)")
                        // Handle decoding error scenarios
                    }
                }
            }
        }.resume()
    }
}
