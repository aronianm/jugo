//
//  CheckUserView.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/23/24.
//

import SwiftUI

struct CheckUserView: View {
    @State var contactUser:Int?
    var phoneNumber:String
    @State var userExist:Bool = false
    @Binding var shouldNavigateBack:Bool
    @Binding var isSheetPresented:Bool
    var body: some View {
        Button(action: {
            // Handle button tap action
        }) {
            if userExist{
                Text("Challenge")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10).onTapGesture {
                        sendChallenge(phoneNumber: phoneNumber)
                    }
            }else{
                Text("Text User to join")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
        }.onAppear {
            checkUser(mobileNumber: phoneNumber)
        }
        
    }
    
    func sendChallenge(phoneNumber: String){
        let authToken:String =  UserDefaults.standard.string(forKey: "AuthToken") ?? ""
        let baseURL = Environment.apiBaseURL
        guard let url = URL(string: "\(baseURL)/matchups") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("\(authToken)", forHTTPHeaderField: "Authorization")
    
        
        let payload = [
            "phone_number": phoneNumber
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
                
                if let data = data {
                    // Parse and handle the response data
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                        shouldNavigateBack = false
                        isSheetPresented = false
                        if let jsonResponse = jsonResponse as? [String: Any] {
                            // Now jsonResponse is safely cast as a dictionary

                            if let userFound = jsonResponse["user_found"] as? Bool {
                                // Use userFound here
                                if(userExist == false){
                                    userExist = userFound
                                }
                            } else {
                                // Handle the case where "user_found" is not an integer
                                print("Error: 'user_found' is not an integer")
                            }
                            
                            if let userId = jsonResponse["user_id"] as? Int {
                                contactUser = userId
                            } else{
                                // Handle the case where "user_found" is not an integer
                                print("Error: 'user_id' is not an integer")
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
    func checkUser(mobileNumber:String) {
        let authToken:String =  UserDefaults.standard.string(forKey: "AuthToken") ?? ""
        let baseURL = Environment.apiBaseURL
        guard let url = URL(string: "\(baseURL)/users/check_user") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("\(authToken)", forHTTPHeaderField: "Authorization")
    
        
        let payload = [
            "phone_number": mobileNumber
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
                
                if let data = data {
                    // Parse and handle the response data
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                        if let jsonResponse = jsonResponse as? [String: Any] {
                            // Now jsonResponse is safely cast as a dictionary

                            if let userFound = jsonResponse["user_found"] as? Bool {
                                // Use userFound here
                                if(userExist == false){
                                    userExist = userFound
                                }
                            } else {
                                // Handle the case where "user_found" is not an integer
                                print("Error: 'user_found' is not an integer")
                            }
                            
                            if let userId = jsonResponse["user_id"] as? Int {
                                contactUser = userId
                            } else{
                                // Handle the case where "user_found" is not an integer
                                print("Error: 'user_id' is not an integer")
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

//#Preview {
//    CheckUserView(phoneNumber: "(774) 573-5663")
//}
