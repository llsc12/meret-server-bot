//
//  Constants.swift
//  DDBKit-Template
//
//  Created by Lakhan Lothiyi on 15/02/2025.
//

import Foundation
import DiscordBM

let env = Constants.env
public struct Constants: Codable {
  public static let env = Constants.loadEnv()
  
  /// Bot login token
  public let token: String
}

extension Constants {
  /// This creates an instance of this struct from the Constants.env file or errors fatally.
  static let homeOverrideURL = URL.homeDirectory.appendingPathComponent("Constants").appendingPathExtension("env")
  static let fileURL = URL.currentDirectory().appending(path: "Constants").appendingPathExtension("env")
  static func loadEnv() -> Self {
    if let file = (try? Data(contentsOf: homeOverrideURL)) ?? (try? Data(contentsOf: fileURL)) {
      do {
        let constants = try JSONDecoder().decode(Self.self, from: file)
        guard constants.token.isEmpty == false else { fatalError("Please configure the Constants.env file before running.") }
        return constants
      } catch {
        fatalError(String(reflecting: error))
      }
    } else {
      try? JSONEncoder().encode(Self.default).write(to: fileURL, options: .atomic)
      fatalError("""
You've not set up a constants file. 
One with default values has been created for you.
Edit this file as needed, then rerun the bot.
""")
    }
  }
  
  
  static let `default` = Constants.init(
    token: ""
  )
}
