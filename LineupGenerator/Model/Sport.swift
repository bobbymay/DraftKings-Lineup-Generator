import Foundation


enum Sport {
	case None, NFL, NHL, NBA

    static var league: Sport {
        let leagues: [String: Sport] = [
            "NHL": .NHL,
            "NBA": .NBA,
            "NFL": .NFL
        ]
        
        // search all contests names to match sport
        for contest in DKEntries.contestNames {
            for l in leagues.keys {
                if contest.contains(l) {
                    return leagues[l] ?? .None
                }
            }
        }
        
        guard Sport.league != .None else {
            fatalError("ERROR: Can't find sport")
        }
        
        return .None
    }
	
	
}
 
