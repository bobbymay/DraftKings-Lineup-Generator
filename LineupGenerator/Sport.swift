import Foundation


enum Sport {
	
	case None, NFL, NHL, NBA
	
	static var sport = Sport.None
	

	static func set() {
		
		let sport: [String: Sport] = [	"NHL": .NHL,	"NBA": .NBA,	 "NFL": .NFL ]
		
		// search all contests names to match sport
		for contest in DKEntries.contestNames {
			sport.keys.forEach({
				if contest.contains($0) {
					Sport.sport = sport[$0]! }
			})
		}
		
		guard Sport.sport != .None else {
			fatalError("ERROR: Find Sport")
		}
		
		Print.sport()
		Lineups.setDelegate()
	}
	
	
}
