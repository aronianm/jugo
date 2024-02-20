//
//  GameKitManager.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 2/19/24.
//
import SwiftUI
import GameKit

// GameCenterManager.swift
class GameCenterManager: NSObject, ObservableObject, GKGameCenterControllerDelegate {
    @Published var isAuthenticated = false
        
    override init() {
        super.init()
        authenticateLocalPlayer()
        
    }
    
    func authenticateLocalPlayer() {
        GKLocalPlayer.local.authenticateHandler = { viewController, error in

                if let viewController = viewController {
                    UIApplication.shared.windows.first?.rootViewController?.present(viewController, animated: true, completion: nil)
                } else if GKLocalPlayer.local.isAuthenticated  {
                    // Game Center authentication successful, get user's information
                    let username = GKLocalPlayer.local.alias
                    let displayName = GKLocalPlayer.local.displayName
                    let gamePlayerId = GKLocalPlayer.local.gamePlayerID
                    // Create a dictionary with user data
                    let userData: [String: Any] = [
                        "displayName": displayName,
                        "username": username,
                        "game_center_id": gamePlayerId,
                        
                    ]
                    
                    
                    // Convert user data to JSON
                    guard let jsonData = try? JSONSerialization.data(withJSONObject: userData, options: []) else {
                        print("Error converting user data to JSON")
                        return
                    }
                    
                    // Create a URL request
                    guard let url = URL(string: "\(Environment.apiBaseURL)/game_center_auth/authenticate") else {
                        print("Invalid URL")
                        return
                    }
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.httpBody = jsonData
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                    // Send the request
                    URLSession.shared.dataTask(with: request) { data, response, error in
                        // Handle the response or error
                        if let error = error {
                            print("Error sending user data to server: \(error)")
                            self.isAuthenticated = false
                        } else if let response = response as? HTTPURLResponse {
                            print("Server response: \(response.statusCode)")
                            if !(400..<500).contains(response.statusCode) {
                                // Success response, status code is not in the 400 range
                                self.isAuthenticated = true
                                if let data = data {
                                   if let jwt = String(data: data, encoding: .utf8) {
                                       // Store the JWT key in UserDefaults
                                       UserDefaults.standard.set(jwt, forKey: "jwt")
                                   }
                                }else{
                                    self.isAuthenticated = false
                                }
                                
                            } else {
                                // Error response, status code is in the 400 range
                                self.isAuthenticated = false
                                // Handle the error response further if needed
                            }
                        }
                    }.resume()
                    
                    
                    // Update UI or perform any other actions
                   
                } else {
                    print("Game Center authentication error: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
    }
    
    func showGameCenter() {
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .default
        UIApplication.shared.windows.first?.rootViewController?.present(gcVC, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}
