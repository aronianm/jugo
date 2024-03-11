//
//  Environment.swift
//  Fogo
//
//  Created by Michael Aronian Aronian on 1/20/24.
//

import Foundation


enum AppConfiguration {
  case Debug
  case TestFlight
  case AppStore
}

struct Config {
  // This is private because the use of 'appConfiguration' is preferred.
  private static let isTestFlight = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
  
  // This can be used to add debug statements.
  static var isDebug: Bool {
    #if DEBUG
      return true
    #else
      return false
    #endif
  }

  static var appConfiguration: AppConfiguration {
    if isDebug {
      return .Debug
    } else if isTestFlight {
      return .TestFlight
    } else {
      return .AppStore
    }
  }
}

enum Environment {
    static var configuration = Config.self
    static var apiBaseURL: String {
        if (configuration.appConfiguration == .Debug) {
            return "http://michaels-macbook-air.local:3001"
        } else if (configuration.appConfiguration == .TestFlight) {
            return "http://qa.fogo-fitness.com"
        } else {
            return "http://production.fogo-fitness.com"
        }
    }
}
