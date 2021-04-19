//
//  Email.swift
//  MuzSzafaMac
//
//  Created by Alagris on 16/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import MuzSzafaShared
import MuzSzafaMacFramework

class DealTemplateProcessor{
    private let deal:Deal
    init(deal:Deal){
        self.deal = deal
    }
    static let Keys:[String:(Deal)->String?] = [
        "$CLIENT_NAME":{$0.client?.name},
        "$CLIENT_SURNAME":{$0.client?.surname},
        "$CLIENT_TEL":{$0.client?.tel},
        "$CLIENT_EMAIL":{$0.client?.email},
        "$DEAL_DATE":{stringify(maybe:$0.from as Any?)},
        "$DEAL_ID":{$0.id},
        "$DEAL_PRICING":{moneyToString($0.pricing)},
        "$PAYMENT_UNPAID_SUM":{moneyToString($0.unpaidPaymentsSum)}
    ]
	typealias TableKeys<T:NSManagedObject> = [String:(T)->String?]
    static let PaymentKeys:TableKeys<Payment> = [
        "$PAYMENT_UNPAID_FROM":{
            stringify(maybe:$0.term_begin)
        },
        "$PAYMENT_UNPAID_TO":{
            stringify(maybe:$0.term_end)
        },
        "$PAYMENT_UNPAID_PRICE":{
            moneyToString($0.money_amount)
        },
    ]
	static let InstrumentKeys:TableKeys<Instrument> = [
		"$INSTRUMENT_NAME":{$0.instrumentName},
		"$INSTRUMENT_SIZE":{$0.size},
		"$INSTRUMENT_TYPE":{$0.type?.type},
		"$INSTRUMENT_ID":{$0.id}
	]
    subscript(_ key:String)->String{
        return DealTemplateProcessor.Keys[key]?(deal) ?? key
    }
    typealias Mutstr = NSMutableAttributedString
    
    enum Error: Swift.Error {
        case templateError(String)
    }

    
    func generateAttrString(defaultsKey:String = PrefEmailViewController.emailPatternLocationKey)throws ->Mutstr{
        guard let url = UserDefaults.standard.url(forKey: defaultsKey) else{
            throw Error.templateError("invalid_email_pattern")
        }
        do{
            return try generateAttrString(url:url)
        }catch let e{
            throw e
        }
    }
    
    func generateAttrString(url:URL)throws->Mutstr{
        let type = NSAttributedString.DocumentReadingOptionKey.documentType
        let opts = [type:url.documentType]
        guard let content = try? Mutstr(url: url, options: opts, documentAttributes: nil) else{
            throw Error.templateError("email_pattern_failed_to_open")
        }
        return generateAttrString(tempalte: content)
    }
    func generateAttrString(tempalte:Mutstr)->Mutstr{
        ////////////////////
        ///replace keywords
        ////////////////////
        for (key,f) in DealTemplateProcessor.Keys{
            tempalte.replaceOccurrences(of: key, with: f(deal).or())
        }
        ////////////////////
        ///collect tables with keywords
        ////////////////////
        var paymentTables:[MutableTextTable] = []
        for key in DealTemplateProcessor.PaymentKeys.keys{
            for r in tempalte.rangesOf(string: key){
                let index = r.lowerBound.encodedOffset
                if let table:MutableTextTable = tempalte.mutOutterTableRange(at: index){
                    if !paymentTables.contains(element:table){
                        paymentTables.append(table)
                    }
                }
            }
        }
		var instrumentTables:[MutableTextTable] = []
		for key in DealTemplateProcessor.InstrumentKeys.keys{
			for r in tempalte.rangesOf(string: key){
				let index = r.lowerBound.encodedOffset
				if let table:MutableTextTable = tempalte.mutOutterTableRange(at: index){
					if !paymentTables.contains(element:table) &&
						!instrumentTables.contains(element:table){
						instrumentTables.append(table)
					}
				}
			}
		}
        ////////////////////
        ///replace keywords in tables
        ////////////////////
		func rewriteTables<T>(tables:[MutableTextTable],
							  keys:TableKeys<T>,
							  converter:(Deal)->[T]){
			for table in tables.reversed(){
				let builder = TextTableBuilder(table: table)
				var firstRow = -1
				for row in 0..<builder.rows{
					if builder.contains(str: keys.keys, inRow: row){
						firstRow = row
						break
					}
				}
				if firstRow == -1{continue}
				var lastRow = firstRow
				for row in (firstRow+1)..<builder.rows{
					if builder.contains(str: keys.keys, inRow: row){
						lastRow = row
					}
				}
				
				let mos = converter(deal)
				let mosCount = mos.count
				if mosCount > 0{
					builder.duplicate(rowsFrom: firstRow, upto: lastRow, into: lastRow+1,times:mosCount-1)
					for (i,mo) in mos.enumerated(){
						for (key,f) in keys{
							let new = f(mo).or()
							builder.replace(str: key, with: new, inRow: firstRow+i)
						}
					}
				}else{
					builder.remove(rowsFrom: firstRow, upto: lastRow)
				}
				
				
				let str = builder.buildStr
				tempalte.replaceCharacters(in: table.range, with: str)
			}
		}
		
		rewriteTables(tables: paymentTables, keys: DealTemplateProcessor.PaymentKeys) {
			$0.getUnpaidPayments() ?? []
		}
		rewriteTables(tables: instrumentTables, keys: DealTemplateProcessor.InstrumentKeys) {
			$0.instrument?.allObjects as! [Instrument]
		}
		
        return tempalte
    }
    
    
    func sendEmail() {
        guard let e = deal.client?.email else{
            dialogOK(msg: "client_has_no_email")
            return
        }
        
        do{
            let content = try generateAttrString()
            let service = NSSharingService(named: NSSharingService.Name.composeEmail)!
            service.recipients = [e]
            service.subject = getLocalizedString(for: "Payment is due")
            service.perform(withItems: [content])
        }catch Error.templateError(let e){
            dialogOK(msg: e)
        }catch{
            dialogOK(msg: "Error")
        }
    }
    
}


