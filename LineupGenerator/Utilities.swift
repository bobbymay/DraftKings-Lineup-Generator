import Foundation


struct File {
	
	static func read(file: String) -> String? {
		
		guard let path = Bundle.main.path(forResource: file, ofType: "csv") else {
			fatalError("\(file) does not exist")
		}
		
		do {
			let data = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
			return data
		} catch {
			fatalError("Failed to read \(file)")
		}
	}
	
}

// MARK: -

extension String {
	
	static func removeSpaces(_ s: String) -> String {
		
		let parentheses = s.replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range:nil)
		let trim = parentheses.trimmingCharacters(in: .whitespacesAndNewlines)
		
		return trim
	}

}

// MARK: -

extension Int {
	
	
	static func random(max: Int) -> Int {
		return Int(arc4random_uniform(UInt32(Int(max))))
	}
	
	
	static func addCommas(_ number: Int) -> String {
		
		let formatter = NumberFormatter()
		formatter.numberStyle = NumberFormatter.Style.decimal
		
		guard let numberWithCommas = formatter.string(for: number) else {
			return String(number)
		}
		
		return numberWithCommas
	}
	
	
}

