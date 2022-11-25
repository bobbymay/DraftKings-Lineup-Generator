import Foundation


struct Print {
    
    /// Print lineups and percentages
    static func lineupsAndPercentages(positions: [String]) {
        DispatchQueue.main.async {
            Print.lineups()
            Print.percentages(positions: positions)
        }
    }
    
    
    /// Print lineups that were generated
    static func lineups() {
        
        let lineups = Lineups.getFinal()
        var keys = [Double](lineups.keys); keys.sort(by: > )
        var teamCount = 0
        
        for key in keys {
            guard let values = lineups[key] else { return }
            
            // Add up lineup salary
            var salary: UInt16 = 0
            for n in 0...values.count - 1 {
                salary += Player.info[values[n]]?.salary ?? 0
            }
            
            // Print lineup count, points, and salary
            teamCount += 1
            print("_____________ \(teamCount) _____________\nPoints: \(String(format: "%.1f", key)) | Salary: \(salary)")
            
            // Print player information
            for n in 0...values.count - 1 {
                if let p = Player.info[values[n]] {
                    print("\(p.position): (\(p.team)) \(p.name), \(String(format: "%.1f", p.points)), $\(p.salary)")
                }
            }
        }
    }
    
    
    /// Print each player and the percentage of lineups they are in
    static func percentages(positions: [String]) {
        
        let lineups = Lineups.getFinal()
        var allPlayers = Array(repeating: [Info](), count: positions.count)
        
        
        // Loads array
        func setPlayer(values v: Info) {
            for (i, _) in positions.enumerated() {
                let p = Info(
                    id: v.id,
                    name: v.name,
                    salary: v.salary,
                    team: v.team,
                    game: v.game,
                    position: v.position,
                    points: v.points,
                    percentage: addUp(values: v)
                )
                
                allPlayers[i].append(p)
            }
        }
        
        
        // Adds up how many players are in lineups
        func addUp(values v: Info) -> Double {
            var count: Double = 0
            
            for ids in lineups.values {
                for n in 0...ids.count - 1 {
                    if v.id == ids[n] {
                        count += 1
                    }
                }
            }
            
            count = count / Double(lineups.count)
            count *= 100
            
            return count
        }
        
        
        // Display player information
        func display(position: String, players: [Info]) {
            
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
