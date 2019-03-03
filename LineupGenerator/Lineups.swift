import Foundation


protocol Algorithm {
	func loadData()
	func createLineups()
}

// MARK: -

class Lineups {
	
	private var counter = 0
	var minPoints = 0.0
	static var count = 0
	static var final = [Double: [Int]]() // points: ids
 private static var delegate: Algorithm!
	
	
	/// Set delegate
	static func setLeague() {
		switch Sport.league {
		case .NBA: delegate = NBA()
		case .NFL: delegate = NFL()
		case .NHL: delegate = NHL()
		default: break
		}
	}
	
	
	/// Load lineups
	static func loadData() {
		self.delegate.loadData()
	}
	
	
	/// Start generating lineups
	static func start() {
		DispatchQueue.global(qos: .userInitiated).async {
			self.delegate.createLineups()
		}
	}
	
	
	/// Get the player with the highest points under budget using an array
	func get(_ players: [Info], budget: UInt16, ids: Int...) -> Int {
		
		var points = 0.0
		var id = -1
		
		outerLoop: for p in players {
			if p.points > points && p.salary <= budget {
				for i in ids {
					if i == p.id { continue outerLoop } // already have player
				}
				points = p.points
				id = p.id
			}
		}
		
		if let index = players.index(where: {$0.id == id}) { return index }
		return -1
	}
	
	
	/// Check if lineup already exists
	func exists(ids: Int...) -> Bool {
		for lineup in Lineups.final.values {
			if Set(lineup).symmetricDifference(ids).isEmpty { // compares lineups (keep values that don't match)
				return true
			}
		}
		return false
	}
	
	
	/// Store lineup in final lineups
	func store(lineup: Int..., points: Double) {
		Lineups.final[points] = lineup
		setMin() // sets minimum value and deletes lowest lineup
	}
	
	
	/// Sets minimum value and deletes lowest lineup
	private func setMin() {
		guard Lineups.final.count > Lineups.count else { return } // less than minimum
		Lineups.final[Lineups.final.keys.min()!] = nil // delete lowest lineup
		minPoints = Lineups.final.keys.min()! // new min
	}
	
	
	/// Get new dictionary key (points)
	func lineupKey(_ points: Double) -> Double {
		var p = points
		repeat { p += 0.01
		} while Lineups.final[p] != nil
		return p
	}
	
	
	/// Get final lineups that were generated
	static func getFinal() -> [Double: [Int]] {
		var lineups = [Double: [Int]]() // points: ids
		lineups = Lineups.final
		return lineups
	}
	
}

// MARK: - 

extension Lineups {
	
	/// Unique lineup
	func unique(_ ids: Int...) -> Bool {
		let lineup = Set(ids)
		return lineup.count == ids.count ? true : false
	}
	
	/// Make sure there are players from two teams
	func twoTeams(_ t: String...) -> Bool {
		for n in 1...t.count - 1 {
			if t[0] != t[n] { return true }
		}
		return false
	}
	
	/// Make sure there are players from two games
	func twoGames(_ g: String...) -> Bool {
		for n in 1...g.count - 1 {
			if g[0] != g[n] { return true }
		}
		return false
	}
	
	/// Make sure same player not in same lineup
	func twoPlayersOneLineupCapt(_ ids: String...) -> Bool {
		for n in 1...ids.count - 1 {
			if ids[0] == ids[n] {
				return true }
		}
		return false
	}
	
	/// Has players from three different teams
	func threeDifferentTeams(_ t: String...) -> Bool {
		let teams = Set(t)
		return teams.count >= 3 ? 	true : false
	}
	
	/// Four or less players from the same team
	func fourOrLessPlayersSameTeam(_ team: String...) -> Bool {
		let c = NSCountedSet()
		for t in team { c.add(t) } // add up all teams
		for t in team { if c.count(for: t) > 4 { return false } } // if more than 4: false
		return 	true
	}
	
}


