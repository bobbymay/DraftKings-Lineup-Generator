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
    
    
    /// Filter out players with no points, and load data to generate lineups
    static func filter() {
        
        // Delete players with no projected points
        for (key, p) in Player.info {
            if p.points <= 0 { Player.info[key] = nil }
        }
        
        Lineups.loadData()
    }
    
}

