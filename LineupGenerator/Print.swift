import Foundation


struct Print {
	
	// Counts iteration while generating lineups. Used in progress()
	private static var counter = 0
	
	
	/// Prints sport that lineups are being generated for
	static func sport() {
		print("Sport: \(Sport.sport)")
	}
	
	
	/// Print progress every 10% Example: 10% - Loops: 1000
	static func progress() {
		counter += 1
		guard counter % Int(Double(AppDelegate.loops) * 0.1) == 0 else { return }
		let percentage = Double(counter) / Double(AppDelegate.loops) * 100
		print("\(String(format: "%.0f", percentage))% - Generated:", counter)
	}
	
	
	/// Displays how many players there are from DraftKings
	static func entriesCount() {
		guard Player.info.count > 0 else { print("ERROR: no players"); return		}
		print("\(Player.info.count) players")
	}
	
	
	/// Displays how many iterations will run and how many lineups are generated
	static func lineupsAndLoops() {
		print("\(Int.addCommas(AppDelegate.loops)) attempts\n\(Lineups.count) lineups \n")
	}
	
	
	/// convenience function to print lineups and percentages
	static func lineupsAndPercentages(positions: [String]) {
		print("\r")
		DispatchQueue.main.async {
			Print.lineups()
			Print.percentages(positions: positions)
		}
	}
	
	
	/// Print lineups that were generated
	static func lineups() {
		
		var lineups = Lineups.getFinal()
		var keys = [Double](lineups.keys); keys.sort(by: > )
		var teamCount = 0
		
		for key in keys {
			let values = lineups[key]!
			
			// Add up lineup salary
			var salary: UInt16 = 0
			for n in 0...values.count - 1 {
				salary += Player.info[values[n]]!.salary
			}
			
			// Print lineup count, points, and salary
			teamCount += 1
			print("_____________ \(teamCount) _____________\nPoints: \(String(format: "%.1f", key)) | Salary: \(salary)")
			
			// Print player information
			for n in 0...values.count - 1 {
				let p = Player.info[values[n]]!
				print("\(p.position): (\(p.team)) \(p.name), \(String(format: "%.1f", p.points)), $\(p.salary)")
			}
		}
		
	}
	
	
	/// Print each player and the percentage of lineups they are in
	static func percentages(positions: [String]) {
		
		var lineups = Lineups.getFinal()
		
		struct PlayerInfo {
			var id: Int
			var name: String
			var salary: UInt16
			var team: String
			var points: Double
			var position: String
			var percentage: Double
			var game: String?
		}
		
		var allPlayers = Array(repeating: [PlayerInfo](), count: positions.count)
		
		
		// Loads array
		func setPlayer(values v: Info) {
			
			for (i, _) in positions.enumerated() {
					let p = PlayerInfo(id: v.id, name: v.name, salary: v.salary, team: v.team, points: v.points, position: v.position, percentage: addUp(values: v), game: v.game)
					
					allPlayers[i].append(p)
			}
		}
		
		
		// Adds up how many players are in lineups
		func addUp(values v: Info) -> Double {
			
			var count: Double = 0
			
			for ids in lineups.values {
				for n in 0...ids.count - 1 { if v.id == ids[n] { count += 1 } }
			}
			
			count = count / Double(lineups.count)
			count *= 100
			
			return count
		}
		
		
		// Display player information
		func display(position: String, players: [PlayerInfo]) {
			
			print("\n______________ \(position) ______________")
			for p in players {
				
				// Positions are not organized, so they are displayed with other player information
				if position == "Players" {
					print("\(String(format: "%.0f", p.percentage))% - \(p.team), \(p.name), \(p.position), $\(p.salary), \(String(format: "%.1f", p.points))")
				} else {
					print("\(String(format: "%.0f", p.percentage))% - \(p.team), \(p.name), $\(p.salary), \(String(format: "%.1f", p.points))")
				}
			}
			
		}
		
		
		// Load allPlayers array
		for v in Player.info.values {
			setPlayer(values: v)
		}
		
		
		// Sort players by points
		for (i, e) in allPlayers.enumerated() {
			var t = e
			t.sort{ $0.points > $1.points }
			allPlayers[i] = t
		}
		
		
		// Display player information
		for n in 0...allPlayers.count - 1 {
			display(position: positions[n], players: allPlayers[n])
		}
		
	}
	
	
}
