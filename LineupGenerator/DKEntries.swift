import Foundation


struct DKEntries {
	
	
	/// Read DKEntries data
	static func read() {
		guard let data = File.read(file: "DKEntries") else { fatalError("Error: Failed reading site file") }
		parse(data)
	}
	
	
	/// Count how many lineups are in contests
	private 	static func countLineups(_ lineups: [String]) {
		if !lineups[0].isEmpty { Lineups.count += 1 }
	}
	
	
	/// Returns contest names
	static var contestNames: [String] {
		
		guard let data = File.read(file: "DKEntries") else { fatalError("Error: Failed reading site file") }
		
		let rows = data.components(separatedBy: "\n")
		var array = [String]()
		
		for row in rows {
			let r = row.components(separatedBy: ",")
			if r.count <= 1 { continue }
			let cr = String.removeSpaces(r[1])
			if cr.isEmpty { continue }
			array.append(cr)
		}
		
		return array
	}
	
	
	/// Parse data
	private 	static func parse(_ data: String) {
		
		let rows = data.components(separatedBy: "\n")
		
		var index = 1
		for row in 8...rows.count - 1 {
			
			if !rows[row].contains(",") { continue } // skips empty rows
			
			let lineups = rows[index].components(separatedBy: ",")
			index += 1
			
			countLineups(lineups)
			
			let info = rows[row].components(separatedBy: ",")
			let	p = Info(info)
			
			Player.add(p)
		}
		
		Print.entriesCount()
	}
	
	
	/// Set up rewriting DKEntries data
	static func edit() -> String? {
		
		guard let path = Bundle.main.path(forResource: "DKEntries", ofType: "csv") else { return nil }
		
		do {
			let data = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
			let editedData = rewrite(data)
			return editedData
		} catch { print("Failed to edit DKEntries files") }
		
		return nil
	}
	
	
	/// Rewrite DKEntries data
	private static func rewrite(_ data: String) -> String {
		
		var lineups = Lineups.getFinal()
		
		func getID(index: Int, _ points: Double) -> Int {
			let ids = lineups[points]!
			return ids[index]
		}
		
		var newData = String()
		let rows = data.components(separatedBy: "\n")
		
		for (index, row) in rows.enumerated() {
			if index >= 1 && index <= Lineups.count {
				
				if let points = lineups.keys.max() { // points is the dictionary key. This will be used later to delete lineup
					
					// Set new info data
					var info = row.components(separatedBy: ",")
					for n in 4...lineups.values.first!.count + 4 - 1 {
						info[n] = "\(Player.info[getID(index: n - 4, points)]!.name) (\(Player.info[getID(index: n - 4, points)]!.id))"
					}
					
					// New row to be saved
					var s = String()
					for i in 0...info.count - 2 { // "2" because the comma should not be at the end
						s.append("\(info[i]),")
					}
					s.append("\(info[info.count - 1])")
					
					// Write row to new file
					newData.append(s)
					
					// Delete lineup once it has been added to the file
					lineups[points] = nil
				}
			} else {
				// Write data to new file
				newData.append(row)
			}
			
		}
		
		return newData
	}


}


