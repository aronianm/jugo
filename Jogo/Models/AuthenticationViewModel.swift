//
//  AuthenticationViewModel.swift
//  Fogo
//
//  Created by Michael Aronian Aronian on 1/20/24.
//
import Foundation
import SwiftUI

class AuthenticationViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var userId:Int = 0
    @Published var accessDenied:Bool = false
    @Published var user: User?
    @Published var gameCenterManager:GameCenterManager = GameCenterManager()
    let baseURL = Environment.apiBaseURL

    init() {
        restoreAuthTokenFromUserDefaults()
    }

    private func restoreAuthTokenFromUserDefaults() {
        if let storedToken = UserDefaults.standard.string(forKey: "AuthToken"), !storedToken.isEmpty {
            self.isLoggedIn = true
        }else{
            self.isLoggedIn = false
            gameCenterManager.isAuthenticated = false
        }
    }

    func handleLoginSuccess() {
        self.isLoggedIn = true
        self.current_user()
    }

    func signup(username: String, fname: String, lname: String, password: String) {
        guard let url = URL(string: "\(baseURL)/signup") else {
            print("Invalid URL")
            return
        }

        let parameters = ["user": ["username": username, "fname": fname, "lname": lname, "password": password]]

        performRequest(url: url, method: "POST", parameters: parameters) { result in
            switch result {
            case .success:
                self.handleLoginSuccess()
            case .failure(let error):
                print("Signup Error: \(error)")
            }
        }
    }

    func login(phone_number: String, password: String, completion: @escaping (Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)/login") else {
            print("Invalid URL")
            completion(NetworkError.invalidURL)
            return
        }

        let parameters = ["user": ["phone_number": phone_number, "password": password]]
        
        performRequest(url: url, method: "POST", parameters: parameters) { result in
            switch result {
            case .success(let (data, headers)):
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    print("JSON Response: \(jsonResponse)")
                    if let jsonDict = jsonResponse as? [String: Any], let userId = jsonDict["userId"] as? Int {
                        self.userId = userId
                    }
                    if let token = (headers as? [String: Any])?["Authorization"] as? String {
                       
                        // Update UI-related components on the main thread
                        UserDefaults.standard.set(token, forKey: "AuthToken")
                        self.handleLoginSuccess()
                        
                        completion(nil) // Success, so call completion with nil error
                    } else {
                        print("Missing Authorization key in response headers.")
                        completion(NetworkError.missingAuthorizationKey)
                    }
                    
                } catch {
                    print("Error decoding response: \(error)")
                    completion(error) // Pass decoding error to completion
                }
            case .failure(let error):
                print("Login Error: \(error)")
                completion(error) // Pass networking error to completion
            }
        }
    }

    func current_user() {
        guard let url = URL(string: "\(baseURL)/users/primary_user") else {
            print("Invalid URL")
            return
        }

        performAuthorizedRequest(url: url, method: "GET") { result in
            switch result {
            case .success(let data):
                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(user.id, forKey: "userId")
                        UserDefaults.standard.synchronize()
                    }
                } catch {
                    self.isLoggedIn = false
                    print("Error decoding JSON: \(error)")
                }
            case .failure(let error):
                self.isLoggedIn = false
                print("current_user Error: \(error)")
            }
        }
    }

    func logout() {
        isLoggedIn = false
        UserDefaults.standard.removeObject(forKey: "AuthToken")
        UserDefaults.standard.synchronize()
        
    }

    private func performRequest(url: URL, method: String, parameters: [String: Any], completion: @escaping (Result<(Data, [AnyHashable: Any]), Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            print("Error encoding parameters: \(error)")
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request Error: \(error)")
                completion(.failure(error))
                return
            }

            if let httpResponse = response as? HTTPURLResponse, let data = data {
                let responseHeaders = httpResponse.allHeaderFields
                print("Response Headers: \(responseHeaders)")

                switch httpResponse.statusCode {
                case 200..<300:
                    self.accessDenied = false
                    completion(.success((data, responseHeaders)))
                case 401:
                    // Unauthorized: Handle authentication issues
                    self.accessDenied = true
                    let error = NSError(domain: "AuthenticationViewModel", code: 401, userInfo: nil)
                    completion(.failure(error))
                case 400..<500:
                    // Client-side error: Handle as appropriate
                    let error = NSError(domain: "AuthenticationViewModel", code: httpResponse.statusCode, userInfo: nil)
                    completion(.failure(error))
                case 500..<600:
                    // Server-side error: Handle as appropriate
                    let error = NSError(domain: "AuthenticationViewModel", code: httpResponse.statusCode, userInfo: nil)
                    completion(.failure(error))
                default:
                    // Handle other status codes
                    let error = NSError(domain: "AuthenticationViewModel", code: httpResponse.statusCode, userInfo: nil)
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    private func performAuthorizedRequest(url: URL, method: String, completion: @escaping (Result<Data, Error>) -> Void) {

        
        if let authToken = UserDefaults.standard.string(forKey: "AuthToken") {
            
            var request = URLRequest(url: url)
            request.httpMethod = method
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(authToken, forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Authorized Request Error: \(error)")
                    completion(.failure(error))
                    return
                }
                
                if let data = data {
                    completion(.success(data))
                }
            }.resume()
        }
    }
}
