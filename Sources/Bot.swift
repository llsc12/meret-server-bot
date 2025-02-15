//
//  BotMain.swift
//  DDBKit-Template
//
//  Created by Lakhan Lothiyi on 02/10/2024.
//

import Foundation
import DDBKit
import DDBKitUtilities

@main
struct DiscordBot: DiscordBotApp {
  init() async {
    bot = await BotGatewayManager( /// Need sharding? Use `ShardingGatewayManager`
      /// Do not store your token in your code in production.
      token: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Token Goes Here@*/#warning("token")/*@END_MENU_TOKEN@*/,
      /// replace the above with your own token, but only for testing
      presence: .init(activities: [], status: .online, afk: false),
      intents: [.guilds]
    )
    // Will be useful
    cache = await .init(
      gatewayManager: bot,
      intents: .all, // it's better to minimise cached data to your needs
      requestAllMembers: .enabledWithPresences,
      messageCachingPolicy: .saveEditHistoryAndDeleted
    )
  }
  
  var body: [any BotScene] {
    ReadyEvent { ready in
      print("\(ready.user.username) is ready and serving \(ready.guilds.count) guilds.")
    }
    
    Command("ping") { i in
      let date = Date.now
      try await i.respond(with: "Pong!")
      // format as milliseconds
      let timeTaken = "\(Int(abs(date.timeIntervalSinceNow) * 1000))ms"
      try await i.editResponse(with: "Pong!\n\(timeTaken)")
    }
    .integrationType(.all, contexts: .all)
  }

  var bot: Bot
  var cache: Cache
}
