import Foundation


struct Player {
    static var info = [Int: Info]()
    static var name = [String: Int]()
    
    
    /// Add players to dictionaries
    static func add(_ info: Info) {
        Player.info[info.id] = info // store player
        let key = String.removeSpaces(info.name) // get key
        name[key] = info.id // store name
    }
    
    
    static func setPlayer(info: [String]) -> Info {
        // Rows that holds clear info
        var row = [Int]()
        
        // Sets the rows that are needed to get player info. This corresponds to the CSV file downloaded from DraftKings
        switch Sport.league {
            case .NFL, .NHL: row = [17, 16, 19, 21, 20, 14]
            default: row = [16, 15, 18, 20, 19, 13] // NBA
        }
        
        // Set player info
        let player = Info (
            id:  Int(info[row[0]]) ?? 0,
            name:  info[row[1]],
            salary: UInt16(info[row[2]]) ?? 0,
            team: info[row[3]],
            game: info[row[4]],
            position: info[row[5]],
            points: 0.0,
            percentage: 0
        )
        
        Team.set(player.game)
        
        return player
    }
    
    
    /// Assigns points to players
    static func set(_ info: [String]) {
        let name = String.removeSpaces(info[0])
        
        guard let id = Player.name[name] else {
            return
        }
        
        if let points = Double(String.removeSpaces(info[4])) {
            Player.info[id]?.points = points
        }
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

