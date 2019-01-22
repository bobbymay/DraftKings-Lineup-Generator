import Foundation


class NBA: Lineups, Algorithm {
	
	// Positions
	var PGs = [Int: Info]()
	var SGs = [Int: Info]()
	var SFs = [Int: Info]()
	var PFs = [Int: Info]()
	var Cs = [Int: Info]()
	var Gs = [Info]()
	var Fs = [Info]()
	var Us = [Info]()
	var C = [Info]()
	
	
	func loadData() {
		
		// Load players by position
		for v in Player.info.values {
			if v.position.contains("PG") { PGs[Int(PGs.count)] = v }
			if v.position.contains("SG") { SGs[Int(SGs.count)] = v }
			if v.position.contains("SF") { SFs[Int(SFs.count)] = v }
			if v.position.contains("PF") { PFs[Int(PFs.count)] = v }
			if v.position.contains("C") { Cs[Int(Cs.count)] = v }
			if v.position.contains("PG") || v.position.contains("SG") { Gs.append(v) }
			if v.position.contains("SF") || v.position.contains("PF") { Fs.append(v) }
			Us.append(v)
		}
		
		Gs.sort{ $0.salary > $1.salary }
		Fs.sort{ $0.salary > $1.salary }
		Us.sort{ $0.salary > $1.salary }
		
		Print.lineupsAndLoops()
	}
	
	
	func createLineups() {
		loop: for _ in 0...AppDelegate.loops {
			Print.progress()
			
			// Set each position
			let pg = Int.random(max: PGs.count)
			let sg = Int.random(max: SGs.count)
			let sf = Int.random(max: SFs.count)
			let pf = Int.random(max: PFs.count)
			let c = Int.random(max: Cs.count)
			let g = 	Int.random(max: Gs.count)
			let f = 	Int.random(max: Fs.count)
			
			// Make sure lineup are unique
			guard unique(PGs[pg]!.id, SGs[sg]!.id, SFs[sf]!.id, PFs[pf]!.id, Cs[c]!.id,	Gs[g].id, Fs[f].id) else { continue loop }
			
			// Get salary. If salary is too high, continue, and generate new lineup
			let salary = Int(PGs[pg]!.salary + SGs[sg]!.salary + SFs[sf]!.salary + PFs[pf]!.salary) + Int(Cs[c]!.salary +	Gs[g].salary + Fs[f].salary)
			if salary > 46_000 { continue loop }
			
			// Get best player available based on salary remaining
			let u = get(Us, budget: UInt16(50_000 - salary), ids: PGs[pg]!.id, SGs[sg]!.id, SFs[sf]!.id, PFs[pf]!.id, Cs[c]!.id,	Gs[g].id, Fs[f].id)
			if u == -1 { continue loop }
			
			// Make sure lineup has more points than the lineups that are saved
			let points = PGs[pg]!.points + SGs[sg]!.points + SFs[sf]!.points + PFs[pf]!.points + Cs[c]!.points +	Gs[g].points + Fs[f].points + Us[u].points
			guard points > minPoints else { continue loop }
			
			// Make sure lineup has not already been created
			if exists(ids: PGs[pg]!.id, SGs[sg]!.id, SFs[sf]!.id, PFs[pf]!.id, Cs[c]!.id,	Gs[g].id, Fs[f].id, Us[u].id) {	continue loop	}
			
			// DraftKings require lineups to have players from at least two different games
			guard twoGames(PGs[pg]!.game, SGs[sg]!.game, SFs[sf]!.game, PFs[pf]!.game, Cs[c]!.game,	Gs[g].game, Fs[f].game, Us[u].game) else { continue }
			
			// DraftKings require lineups to have players from at least two different teams
			guard twoTeams(PGs[pg]!.team, SGs[sg]!.team, SFs[sf]!.team, PFs[pf]!.team, Cs[c]!.team,	Gs[g].team, Fs[f].team, Us[u].team) else { continue }
			
			// Save lineup
			store(lineup: PGs[pg]!.id, SGs[sg]!.id, SFs[sf]!.id, PFs[pf]!.id, Cs[c]!.id,	Gs[g].id, Fs[f].id, Us[u].id, points: lineupKey(points))
		}
		
		Print.lineupsAndPercentages(positions: ["Players"])
	}
	
	
}






