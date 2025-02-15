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
	@Property var timer: Timer?
	
  init() async {
    bot = await BotGatewayManager( /// Need sharding? Use `ShardingGatewayManager`
      /// Do not store your token in your code in production.
      token: env.token,
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
			
			self.timer = Timer.scheduledTimer(withTimeInterval: 60 * 60 * 24, repeats: true) { _ in
				Task {
					do {
						try await self.changeIcon()
					} catch {
						print("Icon Error: \(error)")
					}
				}
			}
    }
    
    Command("trigger") { i in
			self.timer?.fire()
			
			try await i.respond {
				Message {
					Text("Icon changed")
				}
				.ephemeral()
			}
    }
    .integrationType(.all, contexts: .all)
		.defaultPermissionRequirement([.administrator])
		.description("Change the server's icon.")
  }
	
	func changeIcon() async throws {
		print("Changing icon")
		let fsIcons = Bundle.main.executableURL!.deletingLastPathComponent().appendingPathComponent("icons")
		let icons = try FileManager.default.contentsOfDirectory(at: fsIcons, includingPropertiesForKeys: nil, options: [])
		
		guard let icon = icons.randomElement() else { return print("No icons found, does the directory exist? Are there icons?") }
		let data = try Data(contentsOf: icon)
		let filename = icon.pathExtension
		
		guard let server = await cache.storage.guilds[.init("1340334184413265970")] else { return }
		let imgData: Payloads.ImageData = .init(file: .init(data: .init(data: data), filename: "img.\(filename)"))
		_ = try await bot.client.updateGuild(id: .init("1340334184413265970"), payload: .init(name: server.name, icon: imgData))
		_ = try await bot.client.updateOwnUser(payload: .init(avatar: imgData))
	}

  var bot: Bot
  var cache: Cache
}

@propertyWrapper
class Property<Value> {
	init(wrappedValue: Value) {
		self.wrappedValue = wrappedValue
	}
	
	var wrappedValue: Value
}
