import Cocoa


struct Points {
    
    /// Read file in bundle or download from web
    static func read() {
        guard let data = File.read(file: "points") else { return }
        parse(data)
    }
    
    
    /// Parse data
    private static func parse(_ data: String) {
        let rows = data.components(separatedBy: "\n")
        
        for row in rows {
            if let player = parse(row: row) {
                Player.set(player.info)
            }
        }
        
        Player.filter()
    }
    
    
    /// Parse rows
    private static func parse(row: String) -> (info: [String], points: Double)? {
        // Skips empty rows
        if !row.contains(",") { return nil }
        
        // Creates array of strings: [name, salary, team, position, opponent,, points]
        let info = row.components(separatedBy: ",")
        
        // Make sure players team is playing
        if !Team.playing(info) { return nil }
        
        if let points = Double(String.removeSpaces(info[4])) {
            return (info, points)
        }
        
        return nil
    }

    
}
