import Foundation


struct Info {
	
	var id = 0
	var name = ""
	var salary: UInt16 = 0
	var team = ""
	var game = ""
	var position = ""
	var points = 0.0
	
	
	init(_ info: [String]) {
		
		// Rows that holds clear info
		var row = [Int]()
		
		// Sets the rows that are needed to get player info
		switch Sport.sport {
		case .NFL, .NHL: row = [17, 16, 19, 21, 20, 14]
		default: row = [16, 15, 18, 20, 19, 13] // NBA
		}

		// Set player info
		id = Int(info[row[0]]) ?? 0
		name = info[row[1]]
		salary = UInt16(info[row[2]]) ?? 0
		team = info[row[3]]
		game = info[row[4]]
  position = info[row[5]]
		points = 0.0
		Team.set(game)
	}
	
}

// MARK -

struct Player {
	
	static var info = [Int: Info]()
	static var name = [String: Int]()
	
	
	/// Add players to dictionaries
	static func add(_ info: Info) {
		Player.info[info.id] = info // store player
		let key = String.removeSpaces(info.name) // get key
		name[key] = info.id // store name
	}
	
	
	/// Filter out players with no points, and load data to generate lineups
	static func filter() {
		
		// Delete players with no projected points
		for (key, p) in Player.info {
			if p.points <= 0 { Player.info[key] = nil }
		}
		
		Lineups.loadData()
	}
	
}

// MARK -

struct Team {
	
	// Teams that are playing
	static var playing = Set<String>()

	
	/// Set teams that are playing
	static func set(_ game: String) {
		let t2 = game.components(separatedBy: " ") // ATL@HOU 03/25/2018 08:00PM ET
		let t = t2[0].components(separatedBy: "@") // ATL@HOU
		playing.insert(t[0]) // ATL
		playing.insert(t[1]) // HOU
	}
	
	
	/// Returns whether or not team is playing
	static func playing(_ info: [String]) -> Bool {
		let team = info[2]
		guard !playing.contains(team) else { return true } // team exists
		return false
	}
	
	
}

