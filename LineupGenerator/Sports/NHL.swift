import Foundation


final class NHL: Lineups, Algorithm {
	
	// Positions
	private var Cs = [Int: Info]()
	private var Ws = [Int: Info]()
	private var Ds = [Int: Info]()
	private var Gs = [Int: Info]()
	private var UTIL = [Info]()
	
	
	func loadData() {
		
		// Load players by position
		for v in Player.info.values {
			if v.position.contains("C") { Cs[Int(Cs.count)] = v }
			if v.position.contains("W") { Ws[Int(Ws.count)] = v }
			if v.position.contains("D") { Ds[Int(Ds.count)] = v }
			if v.position.contains("G") { Gs[Int(Gs.count)] = v }
			if v.position == "W" || v.position == "C" || v.position == "D" { UTIL.append(v) }
		}
		
		UTIL.sort{ $0.points > $1.points }
		Print.lineupsAndLoops()
	}
	
	
	func createLineups() {
		loop: for _ in 0...AppDelegate.loops {
			Print.progress()

			// Set each position
			let c1 = Int.random(max: Cs.count)
			let c2 = Int.random(max: Cs.count); if c1 == c2 { continue loop }
			let w1 = 	Int.random(max: Ws.count)
			let w2 = Int.random(max: Ws.count); if w2 == w1 { continue loop }
			let w3 = Int.random(max: Ws.count); if w3 == w1 || w3 == w2 { continue loop }
			let d1 = Int.random(max: Ds.count)
			let d2 = Int.random(max: Ds.count);  if d1 == d2 { continue loop }
			let g = Int.random(max: Gs.count)

			// Get salary. If salary is too high, continue, and generate new lineup
			let salary = Cs[c1]!.salary + Cs[c2]!.salary + Ws[w1]!.salary + Ws[w2]!.salary + Ws[w3]!.salary +	Ds[d1]!.salary + Ds[d2]!.salary + Gs[g]!.salary
			if salary > 46_000 { continue loop }
			
			// Get best player available based on salary remaining
			let u = get(UTIL, budget: 50_000 - salary, ids: Cs[c1]!.id, Cs[c2]!.id, Ws[w1]!.id, Ws[w2]!.id, Ws[w3]!.id, Ds[d1]!.id, Ds[d2]!.id)
			if u == -1 { continue loop }
			
			// Make sure lineup has more points than the lineups that are saved
			let points = (Cs[c1]!.points + Cs[c2]!.points + Ws[w1]!.points + Ws[w2]!.points) + (Ws[w3]!.points +	Ds[d1]!.points + Ds[d2]!.points + Gs[g]!.points + UTIL[u].points)
			guard points > minPoints else { continue loop }

			// Make sure lineup has not already been created
			if exists(ids: Cs[c1]!.id, Cs[c2]!.id, Ws[w1]!.id, Ws[w2]!.id, Ws[w3]!.id, Ds[d1]!.id, Ds[d2]!.id, Gs[g]!.id, UTIL[u].id) {	continue loop	}

			// DraftKings require lineups to have players from at least three different teams
			guard threeDifferentTeams(Cs[c1]!.team, Cs[c2]!.team, Ws[w1]!.team, Ws[w2]!.team, Ws[w3]!.team, Ds[d1]!.team, Ds[d2]!.team, UTIL[u].team) else { continue loop }

			// Save lineup
			store(lineup: Cs[c1]!.id, Cs[c2]!.id, Ws[w1]!.id, Ws[w2]!.id, Ws[w3]!.id, Ds[d1]!.id, Ds[d2]!.id, Gs[g]!.id, UTIL[u].id, points: lineupKey(points))
		}
		
		Print.lineupsAndPercentages(positions: ["C", "W", "D" ,"G"])
	}
	
	
}

