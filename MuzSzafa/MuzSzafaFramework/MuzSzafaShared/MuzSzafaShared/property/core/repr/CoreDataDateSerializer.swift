//
//  CoreDataDateSerializer.swift
//  MuzSzafaShared
//
//  Created by Alagris on 30/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation

open class CoreDataDateSerializer:CoreDataGenericSerializer{
    public typealias T = Date
	
    private static let formatter = {
        () -> DateFormatter in
        let f = DateFormatter()
		f.setLocalizedDateFormatFromTemplate("dMMyyyyHm")
        return f
    }()
	private static let COMPONENTS = {
		()->[Calendar.Component] in
		guard let mIndex = formatter.dateFormat.firstIndex(of: Character("M")),
			let dIndex = formatter.dateFormat.firstIndex(of: Character("d")),
			let yIndex = formatter.dateFormat.firstIndex(of: Character("y")) else{
			return [.day,.month,.year,.hour,.minute,.second]
		}
		let comps:[Calendar.Component] = [.day,.month,.year]
		return (zip([dIndex,mIndex,yIndex], comps).sorted {$0.0 < $1.0}).map(){$0.1} + [.hour,.minute,.second]
	}()
	private static let preprocessor = try! NSRegularExpression(pattern: "\\p{L}+|[0-9]+", options: [])
	private static func preprocess(_ val:String)->[String]{
		let range = NSMakeRange(0, val.count)
		return CoreDataDateSerializer.preprocessor.matches(in: val, options: [], range: range).map(){
			String(val[Range($0.range, in: val)!])
		}
	}
    public func deserialize(_ val:String)->T?{
		return CoreDataDateSerializer.deserialize(val)
	}
	public static func deserialize(_ val:String)->Date?{
		let preprocessed = preprocess(val)
		if preprocessed.count == 0{
			return nil
		}
		var dict = [Calendar.Component: Int?]()
		
		var compIndex = 0;
		
//		var wasMonthSpecifiedInWords = false
		for word in preprocessed{
			var val = 0
			var comp:Calendar.Component = CoreDataDateSerializer.COMPONENTS[compIndex]
			if let int = Int(word){
				val = int
				if int > 31{
					if comp == .day || comp == .month{
						comp = .year
					}
				}else if int > 12{
					if comp == .month{
						comp = .day
					}
				}
			}else{
				let f = DateFormatter()
				f.dateFormat = "MMM"
				if let d = f.date(from: word){
					val = d.month
					comp = .month
				}else{
					f.dateFormat = "MMMM"
					if let d = f.date(from: word){
						val = d.month
						comp = .month
					}else{
						continue
					}
				}
			}
			
			if dict[comp] == nil{
				dict[comp] = val
			}else if comp == .month{
				if dict[.day] == nil{
					dict[.day] = dict[.month]!!
				}else if dict[.year] == nil{
					dict[.year] = dict[.month]!!
				}
//				wasMonthSpecifiedInWords = true
				dict[.month] = val
			}else{
				var assignedToNil = false
				forLoop:for c in CoreDataDateSerializer.COMPONENTS{
					if dict[c] == nil{
						switch c{
						case .day:
							if val > 31{
								continue forLoop
							}
						case .month:
							if val > 12{
								continue forLoop
							}
						case .year:
							break
						default:
							break forLoop
						}
						dict[c] = val
						assignedToNil = true
						break forLoop
					}
				}
				if !assignedToNil{
					
					if dict[.month] == nil{
						if dict[comp]!! <= 12{
							dict[.month] = dict[comp]
							dict[comp] = val
						}else if comp == .day{
							if dict[.year]!! <= 12{
								dict[.month] = dict[.year]
								dict[.year] = dict[.day]
								dict[.day] = val
							}
						}else if comp == .year{
							if dict[.day]!! <= 12 && dict[.year]!! <= 31{
								dict[.month] = dict[.day]
								dict[.day] = dict[.year]
								dict[.year] = val
							}
						}
					}else if dict[.day] == nil{
						if dict[comp]!! <= 31{
							dict[.day] = dict[comp]
							dict[comp] = val
						}else if comp == .year{
							if dict[.year]!! <= 12{
								dict[.day] = dict[.month]
								dict[.month] = dict[.year]
								dict[.year] = val
							}
						}else if comp == .month{
							if dict[.year]!! <= 31{
								dict[.day] = dict[.year]
								dict[.year] = dict[.month]
								dict[.month] = val
							}
						}
					}
				}
			}
			compIndex += 1
		}
		var date = DateComponents()
		date.calendar = Calendar.current
		if let yearCell = dict[.year], let year = yearCell{
			//normalize year (so 99 becomes 1999 and 20 becomes 2020)
			if year < 100{
				if year > 50{
					dict[.year] = year + 1900
				}else{
					dict[.year] = year + 2000
				}
			}
		}
		for (comp,val) in dict{
			if val != nil{
				date.setValue(val, for: comp)
			}
		}
		
        let out =  date.date
        return out
    }
    public func stringify(_ val:T)->String?{
        return CoreDataDateSerializer.formatter.string(from:val)
    }
}
