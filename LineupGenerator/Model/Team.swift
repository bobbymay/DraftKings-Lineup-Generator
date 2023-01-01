import Foundation


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
        
        guard !playing.contains(team) else { // team exists
            return true
        }
        
        return false
    }
    
}

