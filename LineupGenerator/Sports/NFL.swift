import Foundation


class NFL: Lineups, Algorithm {
	
	// Positions
	private var QBs = [Info]()
	private var RBs = [Int: Info]()
	private var WRs = [Int: Info]()
	private var TEs = [Int: Info]()
	private var Ds = [Int: Info]()
	private var FLEXs = [Info]()

	
	func loadData() {

		// Load players by position
		for v in Player.info.values {
			if v.position == "QB" { QBs.append(v) }
			if v.position == "RB" { RBs[Int(RBs.count)] = v }
			if v.position == "WR" { WRs[Int(WRs.count)] = v }
			if v.position == "RB" || v.position == "WR" || v.position == "TE" { FLEXs.append(v) }
			if v.position == "TE" { TEs[Int(TEs.count)] = v; continue }
			if v.position == "DST" || v.position == "D" { Ds[Int(Ds.count)] = v }
		}
		
		FLEXs.sort{ $0.points > $1.points }
		Print.lineupsAndLoops()
	}
	
	
	func createLineups() {
		loop: for _ in 0...AppDelegate.loops {
			Print.progress()

			// Set each position
			let qb = Int.random(max: QBs.count)
			let rb1 = Int.random(max: RBs.count)
			let rb2 = 	Int.random(max: RBs.count); if rb2 == rb1 { continue loop }
			let wr1 = 	Int.random(max: WRs.count)
			let wr2 = Int.random(max: WRs.count); if wr2 == wr1 { continue loop }
			let wr3 = Int.random(max: WRs.count); if wr3 == wr1 || wr3 == wr2 { continue loop }
			let te = Int.random(max: TEs.count)
			let d = Int.random(max: Ds.count)

			// Get salary. If salary is too high, continue, and generate new lineup
			let salary = QBs[qb].salary + RBs[rb1]!.salary + RBs[rb2]!.salary + WRs[wr1]!.salary + WRs[wr2]!.salary + WRs[wr3]!.salary +	TEs[te]!.salary + Ds[d]!.salary
			if salary > 45_000 { continue loop }

			// Get best player available based on salary remaining
			let flex = get(FLEXs, budget: 50_000 - salary, ids: RBs[rb1]!.id, RBs[rb2]!.id, WRs[wr1]!.id, WRs[wr2]!.id, WRs[wr3]!.id,	TEs[te]!.id)
			if flex == -1 { continue loop }
			
			// Switch out defense for better defense
			let salaryLeft = 50_000 - (salary + FLEXs[flex].salary)
			let dst = salaryLeft < 50_000 ? switchDST(current: d, budget: (salaryLeft + Ds[d]!.salary)) : d
			
			// Make sure lineup has more points than the lineups that are saved
			let points = QBs[qb].points + RBs[rb1]!.points + RBs[rb2]!.points + WRs[wr1]!.points + WRs[wr2]!.points + WRs[wr3]!.points +
				TEs[te]!.points + FLEXs[flex].points + Ds[dst]!.points
			if points < minPoints { continue loop }
			
			// Make sure lineup has not already been created
  	if exists(ids: QBs[qb].id, RBs[rb1]!.id, RBs[rb2]!.id, WRs[wr1]!.id, WRs[wr2]!.id, WRs[wr3]!.id, TEs[te]!.id, FLEXs[flex].id, Ds[dst]!.id) {	continue loop	}
			
			// DraftKings require lineups to have players from at least two different games
			if !twoGames(QBs[qb].game, RBs[rb1]!.game, RBs[rb2]!.game, WRs[wr1]!.game, WRs[wr2]!.game, WRs[wr3]!.game, TEs[te]!.game, FLEXs[flex].game, Ds[dst]!.game) { continue loop }

			// Save lineup
			store(lineup: QBs[qb].id, RBs[rb1]!.id, RBs[rb2]!.id, WRs[wr1]!.id, WRs[wr2]!.id, WRs[wr3]!.id, TEs[te]!.id, FLEXs[flex].id, Ds[dst]!.id, points: lineupKey(points))
		}
		
		Print.lineupsAndPercentages(positions: ["QB", "RB", "WR" ,"TE" , "DST"])
	}
	
	
	/// Switch out defense for better defense
	func switchDST(current c: Int, budget: UInt16) -> Int {
  var currentD = Ds[c]!
		var newD = c
		for (index, d) in Ds {
			if d.points > currentD.points && d.salary <= budget {
				newD = index
				currentD = Ds[index]!
			}
		}
		return newD
	}
	
	
}


