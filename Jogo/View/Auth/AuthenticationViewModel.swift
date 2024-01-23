//
//  AuthenticationViewModel.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/20/24.
//
import Foundation
import SwiftUI

class AuthenticationViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var authToken: String = ""
    @Published var user: User?
    let baseURL = Environment.apiBaseURL

    init() {
        restoreAuthTokenFromUserDefaults()
    }

    private func restoreAuthTokenFromUserDefaults() {
        if let storedToken = UserDefaults.standard.string(forKey: "AuthToken"), !storedToken.isEmpty {
            self.authToken = storedToken
            self.isLoggedIn = true
        }
    }

    private func saveAuthTokenToUserDefaults() {
        UserDefaults.standard.set(authToken, forKey: "AuthToken")
        UserDefaults.standard.synchronize()
    }

    private func handleLoginSuccess() {
        self.isLoggedIn = true
        self.current_user()
    }

    func signup(phone_number: String, fname: String, lname: String, password: String) {
        guard let url = URL(string: "\(baseURL)/signup") else {
            print("Invalid URL")
            return
        }

        let parameters = ["user": ["phone_number": phone_number, "fname": fname, "lname": lname, "password": password]]

        performRequest(url: url, method: "POST", parameters: parameters) { result in
            switch result {
            case .success:
                self.handleLoginSuccess()
            case .failure(let error):
                print("Signup Error: \(error)")
            }
        }
    }

    func login(phone_number: String, password: String) {
        guard let url = URL(string: "\(baseURL)/login") else {
            print("Invalid URL")
            return
        }

        let parameters = ["user": ["phone_number": phone_number, "password": password]]
        
        performRequest(url: url, method: "POST", parameters: parameters) { result in
            switch result {
            case .success(let (data, headers)):
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    print("JSON Response: \(jsonResponse)")
                    
                    if let token = (headers as? [String: Any])?["Authorization"] as? String {
                       
                        // Update UI-related components on the main thread
                        self.authToken = token
                        self.saveAuthTokenToUserDefaults()
                        self.handleLoginSuccess()
                    } else {
                        print("Missing Authorization key in response headers.")
                    }
                } catch {
                    print("Error decoding response: \(error)")
                }
            case .failure(let error):
                print("Login Error: \(error)")
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
                        self.user = user
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            case .failure(let error):
                print("current_user Error: \(error)")
            }
        }
    }

    func logout() {
        isLoggedIn = false
        authToken = ""
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
                    // Status code indicates success
                    completion(.success((data, responseHeaders)))
                case 401:
                    // Unauthorized: Handle authentication issues
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
        guard !authToken.isEmpty else {
            print("Unauthorized request: No auth token")
            completion(.failure(NSError(domain: "AuthenticationViewModel", code: 401, userInfo: nil)))
            return
        }

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