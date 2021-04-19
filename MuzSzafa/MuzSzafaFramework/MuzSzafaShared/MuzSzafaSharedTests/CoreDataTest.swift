//
//  CoreDataTest.swift
//  MuzSzafaSharedTests
//
//  Created by Alagris on 20/11/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import XCTest
@testable import MuzSzafaShared

class CoreDataTest: XCTestCase {
	
	func testArchive() throws{
		CoreContext.shared.purge()
		try CoreContext.shared.cache.importArchive(str: archive)
		let inst255 = Instrument.ent.fetch("255", limit: 2)! as! [Instrument]
		XCTAssertEqual(inst255.count, 1)
		XCTAssertEqual(inst255[0].instrumentName, "Model podstawowy")
		XCTAssertEqual(inst255[0].type!.type!, "skrzypce")
		XCTAssertEqual(inst255[0].size!, "1/8")
		XCTAssertEqual(inst255[0].available, false)
		XCTAssertEqual(inst255[0].deposit, 15000)
		XCTAssertEqual(inst255[0].price, 70000)
		XCTAssertEqual(inst255[0].fee, 3500)
		XCTAssertEqual(inst255[0].parent_accessory, nil)
		XCTAssertEqual(inst255[0].notes, "futerał=, podpórka=, kalafonia=, pozostałe uwagi:")
		
		let inst151 = Instrument.ent.fetch("151", limit: 2)! as! [Instrument]
		XCTAssertEqual(inst151.count, 1)
		XCTAssertEqual(inst151[0].instrumentName, "Yamaha C40")
		XCTAssertEqual(inst151[0].type!.type!, "gitara")
		XCTAssertEqual(inst151[0].size!, "4/4")
		XCTAssertEqual(inst151[0].available, false)
		XCTAssertEqual(inst151[0].deposit, 20000)
		XCTAssertEqual(inst151[0].price, 75000)
		XCTAssertEqual(inst151[0].fee, 4000)
		XCTAssertEqual(inst151[0].parent_accessory, nil)
		XCTAssertEqual(inst151[0].notes, "Futerał D, podnóżek Mill, tuner Th")
		
		let pay2335659156 = Payment.ent.fetch(1955936282, limit: 2)! as! [Payment]
		XCTAssertEqual(pay2335659156.count, 1)
		XCTAssertEqual(pay2335659156[0].id, 1955936282)
		XCTAssertEqual(pay2335659156[0].paid, true)
		XCTAssertEqual(pay2335659156[0].paid_at, nil)
		XCTAssertEqual(pay2335659156[0].term_begin!, CoreDataDateSerializer().deserialize("27.03.2018, 00:00"))
		XCTAssertEqual(pay2335659156[0].term_end, CoreDataDateSerializer().deserialize("26.04.2018, 23:59"))
		XCTAssertEqual(pay2335659156[0].in_cash, 0)
		XCTAssertEqual(pay2335659156[0].money_amount, 3500)
		XCTAssertEqual(pay2335659156[0].deal!.id!, "20/09/2017")
		
		class MockTable:EntFilteredRecordsTable{
			func reloadData(ent: CoreDataEntity?, pred: SafePredicate?, sort: [NSSortDescriptor]?) {
				
			}
			
			
			var filter: ((NSManagedObject) -> Bool)?
			
			var filteredObjects: [NSManagedObject] = []
			
			var ent: CoreDataEntity?
			
			var sort: [NSSortDescriptor]?
			
			var pred: SafePredicate?
			
			var controller: NSFetchedResultsController<NSManagedObject>?
			
			var tickable: Bool = false
			
			func isTicked(at row: Int) -> Bool {
				return false
			}
			
			func reloadData() {
				self.filteredObjects = ent!.fetch(pred:pred!)!.filter(filter!)
			}
		}
		let mockTable = MockTable()
		mockTable.ent = Payment.ent
		let sum = updatePaymentSummary(mode: 3, date: CoreDataDateSerializer().deserialize("16.10.2018")!, table: mockTable)
		print(mockTable.filteredObjects)
	}
	
	let archive = """
Instrument,135
id,physical_id,instrumentName,type,size,available,deposit,price,fee,parent_accessory,notes
127,,Saksofon altowy Yamaha Yas 280,dęte drewniane,Futerał pasek wazelina szmatka ,false,400.00,3750.00,200.00,,
273,,Model podstawowy,skrzypce,1/4,false,150.00,700.00,35.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:01/06/2017"
285,,Beginner,skrzypce,1,false,250.00,1000.00,50.00,,"futerał=B03, podpórka=Fom, kalafonia=, pozostałe uwagi:"
-,,Thomann SP-5600,pianino,,false,300.00,1700.00,100.00,,wysyłka
279,,Beginner,skrzypce,3/4,false,250.00,1000.00,50.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:"
265,,Beginner,skrzypce,1/4,false,150.00,700.00,40.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:Nowy strunociąg"
287,,Model podstawowy,skrzypce,1/8,true,150.00,700.00,35.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:"
218,,Mapex Q,perkusja,"22, 10, 12, 14, 14, hardware, talerze ",false,300.00,4000.00,150.00,,Wypożyczony z talerzami Sabian XS20 i stopą Pearl Eliminator
257,,Model podstawowy,skrzypce,1/8,false,150.00,700.00,35.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:"
55,,Beginer,skrzypce,1/4,false,150.00,700.00,35.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:"
260,,Model podstawowy,skrzypce,1/8,false,150.00,700.00,35.00,,"futerał=Ebertowski, podpórka=Muco, kalafonia=Kaplan, pozostałe uwagi:"
100,,Thomann SP-5600,pianino,,true,300.00,1700.00,100.00,,
241,,Beginner,skrzypce,1,false,250.00,1000.00,50.00,,"futerał=Bl b03, podpórka=Hidersine, kalafonia=Kaplan, pozostałe uwagi:"
240,,Stasia Ever Play,skrzypce,1/4,false,150.00,700.00,35.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:naprawa"
147,,model podstawowy,wiolonczela,3/4,false,300.00,1600.00,100.00,,
217,,Mapex V,perkusja,"22, 12, 13, 16, 14, hardware futerały, talerze Meinl BCS",false,300.00,3000.00,150.00,,
263,,Begginer,skrzypce,1/4,false,150.00,700.00,35.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:"
247,,Beginner,skrzypce,1,false,250.00,1000.00,50.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:"
277,,Everplay,skrzypce,1/4,false,150.00,700.00,35.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:"
49,,,,,true,0.00,0.00,0.00,,
258,,Model podstawowy,skrzypce,1/4,false,150.00,700.00,35.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:"
353,,Drum Craft Junior,perkusja,"16”, 8”, 10”, 12”, 12”, hardware, siedzenie, dwa talerze, futerały",true,150.00,1000.00,80.00,,Naciągi Evans G2 na tomach
304,,Beginner,skrzypce,1,false,250.00,1000.00,50.00,,"futerał=B03, podpórka=Everest, kalafonia=Kaplan, pozostałe uwagi:"
226,,Model podstawowy,skrzypce,1/8,false,150.00,700.00,35.00,,"futerał=, podpórka=Muco, kalafonia=piranito, pozostałe uwagi:U Szymona "
143,,Yamaha Gigmaker,perkusja,"22”, 12”, 13”, 16”, 14”, hardware, talerze Sabian SBR, futerały",false,300.00,4000.00,150.00,,
128,,beginner,wiolonczela,1,false,350.00,2640.00,100.00,,
352,,Thomann DP-26,pianino,,false,250.00,1300.00,80.00,,
237,,Beginner,skrzypce,1,false,250.00,1000.00,50.00,,"futerał=B03, podpórka=, kalafonia=, pozostałe uwagi:Z WYKUPEM!"
120,,Ludwig Pocket,perkusja,"16”, 10”, 13”, 12”, hardware,     siedzenie, dwa talerze, futerały",true,200.00,1500.00,100.00,,
150,,Yamaha P-45B,pianino,,false,300.00,1800.00,110.00,,
286,,Beginner,skrzypce,1/2,false,250.00,1000.00,50.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:"
54,,Model podstawowy,skrzypce,1/8,true,150.00,700.00,35.00,,
317,,Model podstawowy,skrzypce,1/8,false,150.00,700.00,35.00,,"futerał=Prostokątny , podpórka=Muco, kalafonia=Kaplan, pozostałe uwagi:"
162,,Yamaha CS40,gitara,3/4,false,200.00,750.00,40.00,,"futeral Rock, podnozek War, tuner Gewa"
133,,Gewa Classic Natura,gitara,4/4,false,200.00,750.00,50.00,," podnóżek, tuner"
227,,Model podstawowy,skrzypce,1/8,false,150.00,700.00,35.00,,"futerał=Oliwia, podpórka=Muco, kalafonia=Kaplan, pozostałe uwagi:"
149,,Tama RM czerwony,perkusja,"20, 10, 12, 14, 14, hardware, talerze Meinl BCS, futerały",false,300.00,2500.00,150.00,,
199,,ProNatura Silver Maple,gitara,3/4,false,200.00,750.00,50.00,,"futerał, podnóżek, tuner"
161,,Model podstawowiy,wiolonczela,1,true,300.00,1680.00,100.00,,08/09/2018 rezerw od 11.11 508736732
238,,Beginner,skrzypce,1,false,250.00,1000.00,50.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:"
242,,Beginner,skrzypce,3/4,false,250.00,1000.00,50.00,,"futerał=, podpórka=FOM ala Wolf, kalafonia=Kaplan, pozostałe uwagi:"
253,,Beginner,skrzypce,1,true,0.00,1000.00,40.00,,"futerał=Tryjanowska, podpórka=Hidersine, kalafonia=Kaplan, pozostałe uwagi:"
148,,Model podstawowy ,wiolonczela,1,false,300.00,1680.00,100.00,,25/08/2018 + lepszy smyczek ok80zl
53,,Model podstawowy,skrzypce,1/8,false,150.00,700.00,35.00,,
131,,Gewa Classic,gitara,4/4,false,200.00,750.00,40.00,,"futerał, podnóżek, tuner"
60,,STENTOR,skrzypce,1/4,false,150.00,700.00,35.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:21/09/2018 THOMANN"
251,,Beginner,skrzypce,1/2,false,250.00,1000.00,50.00,,"futerał=Set, podpórka=Dadi, kalafonia=Hidersine, pozostałe uwagi:"
305,,Flet Yamaha 21S,dęte drewniane,"futerał,wycior",true,300.00,2000.00,120.00,,
246,,Begginer,skrzypce,1,false,250.00,1000.00,50.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:"
73,,Yamaha P-45B,pianino,,false,300.00,1800.00,100.00,,
266,,Beginner,skrzypce,1,false,250.00,1000.00,50.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:"
164,,Yamaha CS40,gitara,3/4,false,200.00,750.00,50.00,,futerał Eco
309,,Model podstawowy,skrzypce,1/8,false,150.00,700.00,35.00,,
292,,Beginner,skrzypce,1,false,250.00,1000.00,50.00,,"futerał=B03, podpórka=Muco, kalafonia=, pozostałe uwagi:"
235,,Beginner,skrzypce,1,false,250.00,1000.00,50.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:"
130,,Gewa Classic,gitara,4/4,false,0.00,750.00,40.00,,"futerał, podnóżek, tuner"
74,,Yamaha P-45B,pianino,,false,300.00,0.00,100.00,,
295,,Beginner,skrzypce,1,false,250.00,1000.00,50.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:SPRZEDANO 14.06"
52,,Model podstawowy,skrzypce,1/8,false,150.00,700.00,35.00,,
272,,Model podstawowy,skrzypce,1/4,false,150.00,700.00,35.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:"
197,,Yamaha c30m,gitara,4/4,false,200.00,750.00,40.00,,"Futerał Yaro, podnózek Nomad"
351,,Thomann SP-5600,pianino,,false,300.00,1700.00,100.00,,
297,,Padva od Darii ?,skrzypce,1,false,0.00,1000.00,40.00,,"futerał=Julia Sz, podpórka=, kalafonia=, pozostałe uwagi:Sprzedano"
262,,Beginner,skrzypce,1,false,0.00,1000.00,40.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:"
141,,Thomann Classic S,gitara,4/4,true,200.00,750.00,40.00,,"Futerał Deluxe, podnóżek Millenium"
203,,Saksofon alt Trevor James Classic 2,dęte drewniane,"Futerał, pasek, wazelina, szmatka",false,300.00,3000.00,150.00,,
146,,Mapex Tornado,perkusja,"18”, 10”, 12”, 14”, 14”, hardware, siedzenie, dwa talerze, futerały",false,300.00,1400.00,150.00,,
316,,Beginner,skrzypce,1,false,250.00,1000.00,50.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:"
283,,Beginner,skrzypce,1/2,true,250.00,1000.00,50.00,,"futerał=Set, podpórka=Muco, kalafonia=Piranito, pozostałe uwagi:KLEJONE!"
315,,Beginner,skrzypce,1,false,250.00,1000.00,50.00,,"futerał=, podpórka=Hox, kalafonia=Kaplan, pozostałe uwagi:"
134,,Hengle made in Europe,gitara,1/2,false,200.00,700.00,40.00,,Futeral
271,,Model podstawowy,skrzypce,1/8,false,150.00,700.00,35.00,,"futerał=, podpórka=Muco, kalafonia=Kaplan, pozostałe uwagi:"
168,,Yamaha Cs40,gitara,3/4,true,200.00,750.00,40.00,,"Futerał Thomann niebieski, Millenium, tuner Thomann"
157,,SAKSOFON TENOROWY AMATI,dęte drewniane,"futerał, pasek, smar, sciereczka",false,250.00,2500.00,140.00,,
314,,Salvatini olx,skrzypce,1,false,250.00,1000.00,50.00,,"futerał=, podpórka=FOM ala Wolf, kalafonia=Kaplan, pozostałe uwagi:"
123,,Tama RM bialy 2,perkusja,"20, 10, 12, 14, 14, hardware, talerze Meinl BCS, futerały",false,300.00,2500.00,150.00,,
71,,Thomann SP-5600,pianino,,false,300.00,1700.00,100.00,,
202,,Gewa Classic,gitara,4/4,false,200.00,750.00,50.00,,"futerał Delux, podnóżek Mill, tuner Th"
299,,Model podstawowy,skrzypce,1/8,false,150.00,700.00,35.00,,"futerał=Prostokątny , podpórka=Muco, kalafonia=piranito, pozostałe uwagi:"
189,,Saksofon altowy  Trevor James,dęte drewniane,"Futeral, pasek, ustnik, stroiki",false,400.00,3700.00,150.00,,
99,,Trąbka Yamaha 2,dęte drewniane,futerał,false,200.00,2000.00,80.00,,
267,,Allegro,skrzypce,1,false,250.00,1000.00,50.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:"
166,,Begginer,skrzypce,1/4,true,150.00,700.00,35.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:"
129,,Yamaha CGS102A,gitara,1/2,false,200.00,750.00,40.00,,"futerał D, podnóżek Mill, tuner Th"
264,,Thomann DP-26,pianino,,false,250.00,1300.00,80.00,,
219,,Gewa Classic Natura,gitara,1/2,false,200.00,750.00,40.00,,"futerał, podnóżek, tuner"
270,,Model podstawowy,skrzypce,1/8,false,150.00,700.00,35.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:"
245,,STAR,skrzypce,1,true,250.00,1000.00,50.00,,"futerał=B03, podpórka=Sinomusic, kalafonia=Kaplan, pozostałe uwagi:"
51,,Model podstawowy,skrzypce,1/8,false,150.00,700.00,35.00,,
57,,Thomann DP-26,pianino,,false,250.00,1300.00,80.00,,
222,,set heban,skrzypce,1/2,false,250.00,1000.00,50.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:"
300,,Model podstawowy ,skrzypce,1/4,false,0.00,700.00,0.00,,"futerał=Prostokątny , podpórka=Muco, kalafonia=Piranito, pozostałe uwagi:"
261,,Beginner,skrzypce,1,false,250.00,1000.00,50.00,,"futerał=B03, podpórka=Hidersine, kalafonia=Kaplan, pozostałe uwagi:"
230,,Beginner,skrzypce,1,false,250.00,1000.00,50.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:"
225,,Beginner,skrzypce,1,false,250.00,1000.00,50.00,,"futerał=, podpórka=hidersine D, kalafonia=Kaplan, pozostałe uwagi:"
301,,Nadia,skrzypce,1/2,false,0.00,1000.00,40.00,,"futerał=Blackstone w ksz.skrz., podpórka=, kalafonia=, pozostałe uwagi:Naprawa"
250,,Saksofon alt Trevor James Classic 2,dęte drewniane,"Futerał, pasek, wazelina, szmatka",false,300.00,3000.00,150.00,,
223,,Begginer,skrzypce,1/4,false,150.00,700.00,35.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:"
135,,Saksofon alt Trevor James Classic 2,dęte drewniane,Futerał pasek wycior smar ustnik,false,300.00,3700.00,150.00,,
255,,Model podstawowy,skrzypce,1/8,false,150.00,700.00,35.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:"
163,,Gewa Classic Natura,gitara,3/4,false,200.00,0.00,50.00,,"Zginęła ,futerał, podnóżek, tuner"
318,,Begginer,skrzypce,1/4,false,150.00,700.00,35.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:"
296,,Beginner,skrzypce,1/4,false,150.00,700.00,35.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:"
138,,Tama Rhythm Mate biały,perkusja,"20”, 10”, 12”, 14”, 14”, hardware, siedzenie, trzy talerze Meinl BCS, futerały",false,300.00,2500.00,150.00,,wypożyczony z naciągami silent stroke i talerzami low volume
259,,Beginner,skrzypce,1,false,250.00,1000.00,50.00,,"futerał=B03, podpórka=, kalafonia=, pozostałe uwagi:"
256,,Model podstawowy,skrzypce,1/8,false,150.00,700.00,35.00,,"futerał=Prostokątny , podpórka=Muco, kalafonia=Piranito, pozostałe uwagi:"
142,,Pearl Vision,perkusja,"20”, 10”, 12”, 14”, 14”, hardware, talerze paiste 201",false,300.00,4000.00,150.00,,"Wypożyczony z opcją wykupu, 11/07/2017"
254,,Beginner,skrzypce,3/4,false,250.00,1000.00,50.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:"
140,,Thomann Classic S,gitara,4/4,true,200.00,750.00,40.00,,"Futerał Deluxe, podnóżek Millenium"
239,,Beginner,skrzypce,1/2,false,250.00,1000.00,50.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:"
220,,Flet Philipp Hammig,dęte drewniane,"Futrał, wycior",true,350.00,3000.00,150.00,,
284,,Model podstawowy,skrzypce,1/8,true,150.00,700.00,35.00,,"futerał=Prostokatny, podpórka=Muco, kalafonia=Piranito, pozostałe uwagi:"
274,,Beginner,skrzypce,1/2,false,250.00,1000.00,50.00,,"futerał=Alex, podpórka=, kalafonia=, pozostałe uwagi:Naprawa odprysku"
158,,saksofon altowy B&S,dęte drewniane,"Futerał, 2 ustniki , pasek",false,250.00,2000.00,120.00,,"ustniki: B&S, BERG LARSEN"
124,,YAMAHA C30M,gitara,4/4,true,200.00,750.00,40.00,,
291,,Sprzedane Stasiowi ,skrzypce,1/2,false,250.00,1000.00,50.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:"
320,,Beginner,skrzypce,1,false,250.00,1000.00,50.00,,"futerał=Blackstone w ksz.skrz., podpórka=Hidersine, kalafonia=Kaplan, pozostałe uwagi:"
144,,Bas ibsnez ,gitara,,true,250.00,500.00,70.00,,Futeral pasek
193,,congi Remo 10” i 11”,perkusja,"Remo Crown ze statywem, futerały",true,200.00,1000.00,100.00,,futerał w zestawie
249,,Model podstawowy,skrzypce,1/4,false,150.00,700.00,35.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:klejone "
122,,Drumcraft 8 Maple,perkusja,"Bd: 18,20,22 tt: 10,12,13 ft: 14,16,18,20, sd 10, 14, 14, 14",false,300.00,11000.00,500.00,,"Na doby, hardware w zestawie, cena bez talerzy, transport i ustawienie – do 20 km od Poznania 100PLN, powyżej + 1zł / km"
185,,Saksofon alt Trevor James Classic 2,dęte drewniane,"futerał, smar, ściereczka, pasek",false,300.00,3000.00,150.00,,
211,,ProNatura Silver Maple,gitara,1/2,false,200.00,750.00,40.00,,"U Adwenta , futerał, podnóżek War"
151,,Yamaha C40,gitara,4/4,false,200.00,750.00,40.00,,"Futerał D, podnóżek Mill, tuner Th"
50,,Model podstawowy ,skrzypce,1/8,false,150.00,700.00,35.00,,19/09/2018  HENGLEWSCY
145,,Saksofon alt Trevor James Classic 2,dęte drewniane,Futerał pasek wazelina szmatka ,false,300.00,0.00,150.00,,
280,,Model podstawowy,skrzypce,1/4,false,150.00,700.00,35.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:"
350,,Ludwig Breakbeats,perkusja,,true,0.00,0.00,0.00,,
62,,Werbel Millenium,perkusja,"13”, statyw, pałki, pad i torba",false,100.00,400.00,30.00,,
132,,Gewa Classic,gitara,4/4,false,200.00,750.00,50.00,,"futerał, podnóżek, tuner"
276,,Primavera,skrzypce,3/4,false,250.00,1000.00,50.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:"
125,,YAMAHA C30M,gitara,4/4,true,200.00,750.00,40.00,,
56,,Begginer,skrzypce,1,false,250.00,1000.00,50.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:"
275,,Artino,skrzypce,1,false,250.00,1000.00,50.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:"
269,,Heban?,skrzypce,1/4,false,150.00,700.00,35.00,,"futerał=, podpórka=, kalafonia=, pozostałe uwagi:"
Client,227
id,name,surname,tel,email,notes
92,MONIKA ,LUDWICZAK,662048830,monika.ludwiczak@hotmail.com,
225,Jolanta ,Szambelan,509749222,jolazwm@gmail.com,
195,Józef ,Mackiewicz,509 273 548,am@dantom.pl,
183,Daniel ,Twork,733041937,tworasky@gmail.com,
175,Witold ,Białczyk,722097391,nika.bialczyk2000@gmail.com,
20,ANNA ,LIDIA MIETLIŃSKA,601914746,ANNA.MIETLINSKA@LIVE.COM,
114,Natalia ,Stawińska,606 715 278,nstawin@wp.pl,
218,Julia ,Bartoszak,506072815,julkaszafranska@vp.pl,
201,Agata ,Tobys,796452438,szymcio1234@wp.pl,
84,Svietlana ,"Safronova

",533506526,atevssafr@mail.ru,
98,Leszek ,Krajniak ,697971330,natalia.krajniak@wp.pl,
196,Maria ,Kardasz,601700138,mariakardzasz@gmail.com,
232,MARTA ,WACHOWSKA - WASYŁYK,665 049 114,martenzytek@gmail.com,
4,Wioletta ,Wituchowska,515 129 955,violetta.wituchowska@interia.pl,
174,Witold ,Krzysztof Basista,506 661 888,aivvia@o2.pl,
61,Dariusz ,Świdurski,"728359044, 504967999",d.swidurski@wp.pl,
106,Alicja ,STACHOWIAK,793 653 965,alicjaa.stachowiak@gmail.com,
6,Oh ,Jieun,795341851,lovemeet1003@gmail.com,
161,Olga ,Królik,507 765 242,atraktorletka@wp.pl,
55,Joanna ,Rogowska,504399890,joannarogowska@o2.pl,
29,Beata ,Okaj-Ziółkowska,+48 781 809 228,beata.okaj@gazeta.pl,
72,Paweł ,Janus,500159809,psunaj@gmail.com,
139,Patryk ,Belak,792906358,,
17,Dorota ,Leonhard,695758850,dleonhard@interia.pl,
109,AGNIESZKA ,MOŻDŻYŃSKA,662 469 943,a.mozdzynska@icloud.com,
82,ANNA ,MROWIŃSKA,509 131 357,a.mrowinska@interia.pl,
158,Ewa ,Stabno-Strzeszyńska,606105455,ewastabno@gmail.com,
94,JOANNA ,BIENIASZ,502 088 905,jbieniasz@interia.eu,
166,Magdalena ,Wegner,693905272,piotrwegner@onet.eu,
207,Maciej ,Jasiecki,604639481,maciejjasiecki@op.pl,
30,Leszek ,Salzman,500661555,salz@wp.pl,
24,Katarzyna,Maciejewska,726 159 534,katmac@wp.pl,
138,Ewelina ,Nawrocka,792575522,info@piudime.com,
119,,,BRAK,,
86,MAGDALENA , RATAJCZAK,600095590,m.ratajczak@post.pl,
5,Tomasz ,Cyna,607661914,wojzu@tlen.pl,
200,MAGDALENA ,JAKUBOWICZ,602406448,madzia.jakubowicz@gmail.com,
15,Michał ,Matuszczak,,michal.matuszczak@udt.gov.pl,
131,ALBERT ,JAGODZIŃSKI,578280233,ALBERTJAGODZINSKI@GMAIL.COM,
87,Michał ,Tuszyński,793 353 759,mictuszynski@gmail.com,
59,NORBERT ,JĘDRZEJEWSKI,537742777,norbert.jedrzejewski@wp.pl,
179,SYLWIA ,SZENK,602757865,syliza@wp.pl,
134,Kamil ,Szczepański,537600813,kamilszczepanski94@gmail.com,
8,Marta ,Kuźmiak,500 149 500,marta.kuzmiak@gmail.com,
22,ANDRZEJ ,BOROWCZYK,609097705,andprojekt@gmail.com,
197,Maria ,Kardasz,601700138,mariakardzasz@gmail.com,
112,Tomasz ,Makieła,501 533 609,tomek.makiela@gmail.com,
95,IZABELA ,KWAŚNIEWSKA,783 710 345,izabela.kwasniewska@gmail.com,
120,Kamila ,Krawczyk,692343342,kamila.krawczyk@gmail.com,
229,Anna ,Lubarska,515079638,annalubarska@gmail.com,
143,Agnieszka ,Lewandowska,791 108 670,agnieszka.marta.lewandowska@gmail.com,
68,JOANNA ,SKABURSKA,724015489,joan.skra@gmail.com,
226,Paweł ,Piętowski ,+48 603 655 434,pawelbox@wp.pl,
199,Tomasz ,Regiec,+48 796 665 655,regiectomasz@gmail.com,
170,Renata ,Kaczmarek,509687502,renata.kaczmarek11@gmail.com,
32,Bartosz ,Kurczych,606 221 900,kurczych@icloud.com,
34,Przemysław ,Kulczak,+48 530 099 011,przemyslaw.kulczak@gmail.com,
211,Karolina ,Rogalska - Niemczal,501020175,k.rogalska.niemczal@gmail.com,
217,Klaudia ,Jońska,,klaudiask8@gmail.com,
121,Sławomir ,Piotr Garbatowski,668278718,bemol@tlen.pl,
45,Jakub ,Piotr Jankowiak,605085838,jankowiak.jakub@wp.pl,
52,Łukasz ,Bartoszek,884190599,l.bartooszek@o2.pl,
194,Joanna ,Rogowska,504399890,joannarogowska@o2.pl,
36,Karolina ,Mazurek,519434440,margo222@wp.pl,
136,Konrad ,Olejnik,510043562,konrad.olejnik@interia.pl,
7,Sylwia ,Matysiak – Knapczyk,601161049,t.knapczyk@poczta.onet.pl,
39,Tomasz ,Schmidt,69671469,biuro@stevens.pl,
118,Maciej ,Stodolski,604629287,wikikalisz@wp.pl,
60,Katarzyna ,Chełminiak,691266831,katche@amu.edu.pl,
81,Agata ,Kurlapska,727529207,agatakurlapska@gmail.com,
193,Anna ,Mrowińska,509131357,a.mrowinska@interia.pl,
233,HUBERT,KULIKOWSKI,530 668 605,huberto@me.com,
70,IZABELA ,CIESIELCZYK,608250978,izabela.ciesielczyk@edpauto.com,
187,JakUb ,JASICZAK,,jjasiczak@gmail.com,
40,Mateusz ,Misior,666552888,matt@massivemaker.com,
190,Tamasz ,Stasiński,502438085,1971tomunia@gmail.com,
66,Katarzyna ,Rogalska,602793933,anita_dabrowska@interia.eu,
144,Monika ,Domagalska,500275993,domagalskamonika@gmail.com,
58,SOPHIA ,WURKER,698145755,sophia.wurker@gmail.com,
184,Aleksandra ,Hryhor,574539836,hryhor.oleksandra@gmail.com,
147,Michał ,Wesołowski ,+48 604 161 138,m13.wesolowski@gmail.com,
9,Paulina ,Kuczyńska- Siwka,698149146,paulinaksiwka@interia.pl,
64,Małgorzata ,Stefanowska ,500292462,malste1977@gmail.com,
162,Agnieszka ,Dudziak,506845911,agnesdds@gmail.com,
206,Kacper ,Kornel Wolski,731631010,contact@cbd-polska.pl,
105,Katarzyna ,Osiadło,798 678 840,katarzyna.osiadlo@gmail.com,
212,IZABELA ,MIECHOWICZ,664906861,WMIECHOWICZ@O2.PL,
148,Sylwia ,Hofman,668 848 596,zbigniewhofman@outlook.com,
122,Małgorzata ,Brzezińska,696497707,malgorzatabrzezinska@interia.pl,
37,Konrad ,Łukaszyk,530164785,lukaszyk.konrad98@gmail.com,
50,Konrad ,Kubzdela,+48 516 166 644,kubzdel@gmail.com,
213,TOMASZ ,SOBOL,607350090,TOMSOBOL.S@GMAIL.COM,
191,JOANNA ,DRZEWIECKA,513078947,J.DRZEWIECKA@WP.PL,
222,WIOLETTA ,KONDELA,664671502,konluk@wp.pl,
83,Agnieszka ,Raszyńska,502288185,a.wyduba@gmail.com,
10,Agnieszka ,Busza-Nowaczyk,721044313,aga.busza@gmail.com,
53,Natalia ,Handkiewicz,512104007,natalia300179@wp.pl,
14,Agnieszka ,Kamińska,503169219,agnieszkakam@op.pl,
28,Justyna ,Drag,+48 781 334 608,justynadrag3@gmail.com,
85,Jaros ,-Nuckowska,601774624,clio304@wp.pl,
146,Bartosz ,Lampkowski,+48 509 710 789,b.lampkowski@gmail.com,
117,Jagoda ,Jankowiak,517025058,jagodajankowiak99@gmail.com,
182,AGNIESZKA ,SZCZEPANIAK,600415423,,
101,Dawid ,Napierała,510 374 962,dawusnapus@interia.pl,
48,Przemysław ,Dzięgielewski ,606127549,przemysław.dziegielewski@gmail.com,
215,,,,,
49,Wiesław ,Dariusz Medycki,+48 788 904 812,medycki@vp.pl,
54,Krystian ,Szczepankiewicz,+48 881 609 602,szczepankiewiczkrystian@gmail.com,
65,Agnieszka ,Osuch,+48 604 890 559,osuch.agnieszka@wp.pl,
33,Agata ,Walkiewicz,+48 603 236 507,mailto:agatka.walkiewicz@gmail.com,
3,Anna ,Monika Stanek,604 537 298,anna-stanek@o2.pl,
51,Wojciech ,Wiśniewski,798699253,wisniewskiwf@gmail.com,
151,Piotr ,Wiścicki,+48 794 555 794,,
204,Anna ,Leśniewska,692436784,anufka.lesniewska@gmail.com,
91,MARTYNA ,GIBES,507 184 770,martynagibes@gmail.com,
159,Marcin ,Jankowski,695 796 819,marcinjankowski1990@gmail.com,
13,Agnieszka ,Wojtczak,512815460,gerasim2@poczta.fm,
69,Jakub ,Zając,690575815,jakoub.zajac@gmail.com,
21,MARLENA ,GULEWICZ,604486956,marlena.gulewicz@estetyczne.pl,
205,Kacper ,Kornel Wolski,731631010,contact@cbd-polska.pl,
42,Daniel ,Chromiński,603787520,chrominskidaniel@gmail.com,
128,Agnieszka ,Stawicka,501 278 733,agnieszka.stawicka@prawo.onet.pl,
57,ŁUKASZ ,Wańko,516190780,lukaszwanko@gmail.com,
140,Tomasz ,Strzelczyk,660670617,tomasz.strzelczyk@hotmail.com,
186,Agata ,Piotrowska,784452996,gata.piotrowska@opoczta.pl,
216,ANTONINA ,PEDRYCZ,665825909,tosiach@poczta.onet.pl,
63,Gniezno ,Daria  Walczak,508395104,d.wlaczak85@wp.pl,
178,Maciej ,Mazurek,607247835,maciek@zuchrysuje.pl,
19,MACIEJ ,JASKÓŁKA,511319586,,
25,Joanna ,Leszczyńska,512284941,asia.leszczyńska-kos@wp.pl,
150,Anna ,Drożdżyńska,+48 690 582 912,dranna@wp.pl,
231,OLGA ,ŻULIŃSKA,516 053 094,olgazulinska@gmail.com,
153,Grzegorz ,Bednarczyk,+33 6 16 31 57 50,gbedna@gmail.com,
27,Monika ,Radomska,502 587 603,monikaradomakapl@gmail.com,
23,Tomasz ,Dziergas,605943503,biuro.stprodukt@gmail.com,
165,Izabela ,Kozłowska,+48 504 186 752,ijaro2@o2.pl,
125,Yesi ,Kim,695379133,kimyeji318@hanmail.net,
223,Izabela ,Malinowska ,694 493 636,izabela.malinowska@vw-poznan.pl,
11,Sylwia ,Durlik-Klicka,505877386,sylwiaklicka@gmail.com,
79,Karolina ,Zabłocka,793908408,karolinazablocka.93@gmail.com,
35,Ada ,Prętka,606933361,prada27@gmail.com,
126,Justyna ,Klikowicz,600 062 099,jukrz@wp.pl,
192,Piotr ,Nieużyła,,nieuzyla@op.pl,
133,Tomasz ,Przyślewicz,603676787,tprzyslewicz@poczta.onet.pl,
227,Natalia ,Anna Stępczyńska,602122697,natalia.s96@wpl.pl,
152,PATRYCJA ,WITOŃ,666580227,PATRYCJAW512@GMAIL.COM,
67,Ewa ,Szczukiewicz ,+48 660 484 507,emarf@tlen.pl,
141,Sławomir ,Kaniewski,788559992,skaniewski@wp.pl,
224,EMILIA ,MAKOWIECKA,794758904,makowieckaemilia@wp.pl,
44,Magdalena ,Stęchlicka,601 190 342,m.stechlicka@interia.eu,
203,Szymon ,Mielcarek,536381212,szymon.mielcarek@gmail.com,
176,Anna ,Sierpińska,600277339,annasobala@gmail.com,
145,ALEKSANDER ,MENDOZA – DROSIK,781640902,ALEMEN1@WMI.AMU.EDU.PL,
102,Jolanta ,Siwek,728 961 905,jola.siwek@gmail.com,
16,Anita ,Nadstazik,609546695,aninad1@wp.pl,
130,RYSZARD ,ŚMIDOWICZ,606241096,SMIDOWICZ@OP.PL,
97,KAROLINA ,KWIATKOWSKA,509 099 603,kwiatkowska.karolina01@gmail.com,
135,Michal ,Wachowiak,668606892,klaudiaw41@wp.pl,
1,Anna ,Góral,609 117 456,poznaniasy@gmail.com,
221,KINGA ,CZYŻEWSKA,512 184 014,czyzewska.kadr@gmail.com,
93,Krzysztof ,Stysiak,601092043,stysiu@stysiu.com,
18,JUSTYNA ,GŁOWACKA,609480509,JUSTYNA.WLODEK@WP.PL,
76,Aleksandra ,Przybyła Kajda,509917219,oliksandra@wp.pl,
75,Anna ,Sierpińska,600 277 339,annasobala@gmail.com,
172,Lewandowski ,Wojciech,607134721,karo360@wp.pl,
129,Marta ,Kuźmiak,500 149 500,marta.kuzmiak@gmail.com,
164,Angelika ,Madalinska,796229807,angelika.madalinska@gmail.com,
115,Bartosz ,Kuczyński,690522669,kontakt@luderis.pl,
208,Agnieszka ,Doda- Wyszyńska,+48 509 159 948,adod@wp.pl,
214,JOANNA ,TRYJANOWSKA,603239195,,
142,Sebastian ,Filipiak,725851942,filipiak.sebastian@gmail.com,
156,Dariusz ,Marciniec,793243863,saxer@mail.com,
177,Anna ,Sierpińska,600277339,annasobala@gmail.com,
47,Michał ,Wesolowski,604 161 138,m13.wesolowski@gmail.com,
56,ALICJA ,WIERZBOWSKA,609831160,alicja.wierzbowska@poczta.onet.pl,
167,Magdalena ,RAtajczak,692266541,magdalenaratajczak1980@gmail.com,
88,AGNIESZKA ,DĘBCZYŃSKA - GŁUSZAK,512 114 227,aga.dg@wp.pl,
209,Tomasz ,Nowak,661966810,tomasz_nowak@onet.pl,
198,JOANNA ,DIPIETRO ,737668983,joanna.dipietro@gmail.com,
77,Joanna ,Rybacka - Mossakowska,506 059 157,joannarybacka@gmail.com,
210,Mateusz ,Wesolowski,604 161 138,m13.wesolowski@gmail.com,
160,Michalina ,Baczyńska - Stefaniak,503635556,michalina.baczynska@wp.pl,
202,Agnieszka ,Małgorzata Kołodzińska,607464725,akolodzinska@poczta.onet.pl,
168,Wojciech ,Tarnowski,532595579,tarwoj@o2.pl,
124,Marcin ,Jankowski,695796819,marcinjankowski1990@gmail.com,
103,Paulina ,Mania,603 495 922,paulinamania@gmail.com,
100,SZYMON ,Mielcarek,536 381 212,szymon.mielcarek@gmail.com,
12,Kamila ,Hyziak,504918844,kamila.hyziak@wp.pl,
149,Fabryka ,Sztuki,,,
189,Bartosz ,Nowak ,661925647,baxino@gmail.com,
43,Piotr ,Wróblewski ,513045816,piotr.wroblewski@post.pl,
228,Maciej ,Sawicki,696022099,saw.maciej@gmail.com,
155,Mariusz ,Borowczak,784672099,maraga@interia.pl,
181,JOANNA ,JAROS-NUCKOWSKA,601774624,CLIO304@WP.PL,
104,Paulina ,Bień,695899889,paulabien@gmail.com,
90,ALINA ,GAZDA,608 615 050,alina_g@poczta.onet.pl,
157,Edyta ,Nowak ,693527532,nowak.edyta@onet.pl,
2,Eliza ,Kołaczyńska,791 999 797,elizamagda.m@gmail.com,
230,ELŻBIETA ,KOCZOROWSKA,609 902 790,BRAKMAILA@BLE.BLE,
180,AGATA ,ŻUK,696083858,AGATAZUK3@WP.PL,
169,DOMINIKA ,PIĄTEK,607316112,dominika.piatek@interia.pl,
71,JOANNA ,PSZONKA,606124830,sweda@wp.pl,
154,4save ,sp zoo,,,
185,Aneta ,Chabora,533824073,aneta.chabora@gmail.com,
188,Jolanta ,Szambelan,,jolazwm@gmail.com,
78,Piotr ,Nieużyła,502626173,nieuzyla@op.pl,
171,Anna ,Urszula Halamska,604789763,a-halamska@o2.pl,
31,Józef ,Napierała,+48 732 339 115,napierala.jozef@gmail.com,
137,Arkadiusz , Namyślak,+48 667 773 804,arkadiusz.namyslak@gmail.com,
163,Szymon ,Tobys,+48 783773442,szymcio1234@gmail.com,
116,Patryk ,Belak,,,
123,MONIKA ,JASIŃSKA,505987131,vitem@poznan.home.pl,
111,Radosław ,Theus,,,
26,Agnieszka ,Fiebig,696438784,agnieszka.fiebig@gmail.com,
80,Korydon ,Marcin Michalczak ,608018089,marcin_benzine@icloud.com,
110,Michał ,Grześkowiak,605 601 979,michalgrzeskowiak86@gmail.com,
127,Joanna ,Bekas-Luks,505 477 822,joannabekasluks@o2.pl,
96,Tomasz ,Olszak,887080146,svauy@poczta.onet.pl,
132,Hanna ,Pordąb,+48 692 002 044,hpordab@gmail.com,
41,Krzysztof ,Kinstler,600036306,k.kinstler@wp.pl,
107,ZUZANNA ,ADAMCZYK,601 570 930,woltyzerka.lajkonik@gmail.com,
38,ALICJA ,SZWABE,695232225,SZWABE.ALICJA@GMAIL.COM,
173,Bogumił ,Reinisch,784 153 366,bogumil.reinisch@gmail.com,
74,KINGA ,KOBIAŁOWSKA-PAWLAK,660 457 986,k.kobialowska@vp.pl,
99,WOJCIECH ,KUCHARSKI,607 888 690,wojciech.kucharski@yahoo.com,
220,,SZYMANOWSKI,502 360 848,lightsport93@gmail.com,
89,Eliza ,Halaba,501798658,ehalaba@o2.pl,
Deal,234
id,status,keeps_asset,pricing,from,client,instrument,deposit,deposit_return_date,notes
09/09/2018,1,,150.00,"13.09.2018, 00:00",64,185,0,,Klejenie korka
02/05/2017,3,,0.00,"19.05.2017, 00:00",58,147,0,,Wiolonczela 3/4
2/09/2017,3,,50.00,"10.09.2017, 00:00",141,129,0,,Gitara 1/2
7/09/2017,0,,0.00,,,,0,,
07/06/2018,3,,100.00,"16.06.2018, 00:00",225,193,0,,"Congi, werbel"
02/08/2017,3,,50.00,"8.08.2017, 00:00",172,304,0,,Skrzypce 4/4 nr 304
04/08/2017,3,,0.00,"15.08.2017, 00:00",116,122,0,,Drumcraft 8 pożyczył i oddał
02/07/2018,3,,100.00,"19.07.2018, 00:00",210,71,0,,Pianino Thomann
03/11/2017,1,,150.00,"4.11.2017, 00:00",24,218,0,,"Zmieniono datę z powodu błędnego wpisu w daty i kwoty, Przez wakacje 50%"
02/07/2017,1,,50.00,"2.07.2017, 00:00",4,238,0,,
08/06/2018,1,,40.00,"19.06.2018, 00:00",44,197,0,,
07/12/3017,3,,80.00,"9.12.2017, 00:00",163,146,0,,Mapex Tornado
18/09/2017,1,,50.00,"20.09.2017, 00:00",10,314,0,,
06/12/2017,1,,50.00,"9.12.2017, 00:00",31,220,0,,
05/06/2018,1,,30.00,"11.06.2018, 00:00",43,62,0,,wklej
03/05/2018,1,,150.00,"22.05.2018, 00:00",42,143,0,,"Od 24.06 do 23.08 50%, wklej"
02/04/2018,1,,50.00,"20.04.2018, 00:00",38,225,0,,ANDRZEJ.SZWABE@GMAIL.COM 608695324 TATA
02/05/2018,1,,120.00,"20.05.2018, 00:00",41,142,0,,wklej
12/01/2018,1,,50.00,"17.01.2018, 00:00",34,246,0,,
10/06/2018,3,,150.00,"25.06.2018, 00:00",209,123,0,,TAMA RHYTHM MATE
04/01/2018,3,,100.00,"4.01.2018, 00:00",147,193,0,,Congi
02/06/2018,3,,40.00,"5.06.2018, 00:00",217,133,0,,Gitara 4/4
20/10/2018,1,,35.00,"25.10.2018, 00:00",102,55,0,,
23/09/2018,1,,35.00,"20.09.2018, 00:00",76,277,0,,
09/11/2018,1,,50.00,"19.11.2018, 00:00",232,253,0,,
02/02/2018,3,,150.00,"9.02.2018, 00:00",155,149,0,,Tama Rhythm Mate + Meinl
01/03/2017,3,,0.00,"9.03.0001, 00:00",111,261,0,,Skrzypce 4/4 261
09/10/2018,1,,150.00,"10.10.2018, 00:00",91,135,0,,
08/10/2017,2,,40.00,"5.11.2017, 00:00",18,131,0,,"Wyp. Zgłoszone 26.06 smsowo, Ma oddać do 5.08"
05/01/2018,3,,50.00,"4.01.2018, 00:00",148,285,0,,Skrzypce 4/4
23/10/2018,1,,150.00,"30.10.2018, 00:00",105,138,0,,
08/08/2018,1,,100.00,"27.08.2018, 00:00",56,148,0,,
26/09/2018,1,,50.00,"25.09.2018, 00:00",79,316,0,,
03/02/2018,1,,35.00,"12.02.2018, 00:00",36,223,0,,Będą wpłacać 17 dnia miesiąca
04/12/2017,3,,35.00,"5.12.2017, 00:00",208,255,0,,Skrzypce 1/8
05/02/2018,3,,70.00,"13.02.2018, 00:00",156,220,0,,Philipp Hammig flet
2/02/2018,0,,0.00,,,,0,,
11/01/2018,1,,50.00,"17.01.2018, 00:00",33,247,0,,
03/11/2018,1,,120.00,"7.11.2018, 00:00",109,305,0,,
03/07/2017,3,,150.00,"4.07.2017, 00:00",128,128,0,,Wiolonczela 4/4; płatność z dołu
21/09/2018,3,,35.00,"19.09.2018, 00:00",223,166,0,,Skrzypce 1/4
12/11/2017,1,,50.00,"16.11.2017, 00:00",28,267,0,,
16/11/2017,3,,150.00,"29.11.2017, 00:00",134,135,0,,Sax alt Trevor  James Classic II
18/09/2018,1,,140.00,"18.09.2018, 00:00",72,157,0,,W październiku płatność. TYLKO  40zl SERWIS
03/01/2018,3,,35.00,"4.01.2018, 00:00",161,273,0,,Skrzypce 1/4 Gniezno
06/06/2018,3,,50.00,"16.06.2018, 00:00",194,304,0,,Skrzypce 4/4
09/08/2018,1,,150.00,"27.08.2018, 00:00",57,203,0,,
04/03/2018,3,,150.00,"16.03.0001, 00:00",150,189,0,,Saksofon Trevor James
01/07/2018,3,,50.00,"4.07.2018, 00:00",227,297,0,,Skrzypce STAR 4/4
19/09/2017,3,,50.00,"26.09.2017, 00:00",201,199,0,,Gitara 3/4
07/08/2017,3,,50.00,"28.08.2017, 00:00",140,241,0,,Skrzypce 4/4 241
03/06/2018,3,,150.00,"8.06.2018, 00:00",190,217,0,,Mapex V
13/10/2107,3,,50.00,"7.10.2017, 00:00",131,237,0,,SKRZYPCE 4/4
01/01/2018,3,,120.00,"3.01.2018, 00:00",164,305,0,,Flet Yamaha 21s
01/04/2018,3,,150.00,"10.04.2018, 00:00",186,220,0,,Flet Philipp Hammig
08/09/2017,3,,50.00,"12.09.2017, 00:00",202,254,0,,Skrzypce 3/4
15/11/2017,3,,120.00,"28.11.2018, 00:00",133,305,0,,Flet Yamaha 21s
14/10/2018,2,,50.00,"15.10.2018, 00:00",96,56,0,,
17/10/2017,3,,50.00,"12.10.2017, 00:00",200,266,0,,Skrzypce 4/4
3/09/2017,3,,35.00,"8.09.2017, 00:00",142,287,0,,Skrzypce 1/8 nr 287
8/12/2017,3,,50.00,"29.12.2017, 00:00",138,235,0,,Skrz 4/4
12/10/2017,3,,30.00,"10.10.2017, 00:00",181,265,0,,SKRZYPCE 1/4
01/11/2017,2,,50.00,"3.11.2017, 00:00",23,261,0,,"Chce kupić , Brak wpłat sierpień - listopad = 150 pln"
07/10/2018,1,,40.00,"9.10.2018, 00:00",89,129,0,,
01/03/2018,1,,100.00,"3.03.2018, 00:00",37,128,0,,wklej
14/11/2017,1,,50.00,"21.11.2017, 00:00",29,230,0,,"Wydano zastępcze 15.12.17 , Pęknięcie główki "
11/10/2018,1,,40.00,"11.10.2018, 00:00",93,50,0,,
18/01/2018,3,,40.00,"27.01.2018, 00:00",184,151,0,,Gitara 4/4
07/11/2017,1,,35.00,"9.11.2017, 00:00",26,318,0,,
01/06/2018,3,,70.00,"4.06.2018, 00:00",189,353,0,,DrumCraft junior
19/01/2018,1,,80.00,"29.01.2018, 00:00",35,99,0,,"wklej, Gwóźdź dostał 80zł , Gwóźdź dostał jeszcze 250zl "
05/10/2017,3,,40.00,"4.10.2017, 00:00",130,151,0,,GITARA 4/4
11/09/2018,1,,200.00,"14.09.2018, 00:00",66,127,0,,Wykup po 4 miesiącach
06/02/2018,3,,50.00,"15.02.2018, 00:00",185,315,0,,Skrzypce 4/4
06/11/2017,1,,50.00,"9.11.2017, 00:00",25,222,0,,
08/10/2018,2,,40.00,"10.10.2018, 00:00",90,133,0,,ODDA PO 2MIESIACACH
10/10/2018,1,,80.00,"10.10.2018, 00:00",92,264,0,,
1/04/2017,0,,0.00,,,,0,,
15/09/2018,3,,40.00,"18.09.2018, 00:00",220,141,0,,GITARA 4/4
01/07/2017,1,,35.00,"2.07.2017, 00:00",3,257,0,,
21/10/2018,1,,40.00,"26.10.2018, 00:00",103,211,0,,Możliwy zwrot po miesiącu
11/10/2017,1,,30.00,"13.10.2017, 00:00",19,262,0,,"Zaległe opłaty za pół ceny do czerwca, Wakacje obiecane gratis"
07/10/2017,3,,35.00,"5.10.2017, 00:00",191,277,0,,SKRZYPCE 1/4
08/09/2018,1,,35.00,"12.09.2018, 00:00",63,249,0,,210 zł wpłaty z góry za 6mcy
01/10/2017,1,,35.00,"1.10.2017, 00:00",15,309,0,,
14/09/2017,3,,35.00,"15.09.2017, 00:00",129,258,0,,Skrzypce 1/4
22/10/2018,1,,100.00,"29.10.2018, 00:00",104,74,0,,
03/05/2017,1,,50.00,"20.05.2017, 00:00",2,132,0,,
04/11/2018,1,,100.00,"9.11.2018, 00:00",110,100,0,,
13/01/2018,3,,50.00,"19.01.2018, 00:00",157,245,0,,Gniezno
20/10/2017,1,,120.00,"14.10.2017, 00:00",21,158,0,,
09/11/2017,3,,150.00,"13.11.2017, 00:00",211,189,0,,Saksofon altowy Trevor James
02/11/2017,3,,40.00,"4.11.2017, 00:00",167,211,0,,Gitara 1/2
05/03/2018,3,,30.00,"20.03.0001, 00:00",151,62,0,,Werbel Millenium
07/03/2018,3,,120.00,"28.03.2018, 00:00",197,305,0,,Flet Yamaha 21s
14/01/2018,3,,750.00,"23.01.2018, 00:00",149,49,0,,Zestaw instrumentów 007
17/11/2017,3,,50.00,"29.11.2017, 00:00",135,285,0,,Skrzypce 4/4
09/10/2017,3,,40.00,"5.11.2017, 00:00",214,253,0,,SKRZYPCE 4/4
06/03/2018,3,,100.00,"28.03.2018, 00:00",196,147,0,,Wiolonczela 3/4
06/04/2018,3,,50.00,"30.04.0001, 00:00",153,242,0,,Skrzypce 3/4
04/07/2018,1,,50.00,"19.07.2018, 00:00",48,292,0,,
27/09/2018,2,,40.00,"26.09.2018, 00:00",80,162,0,,Odd po 26.12
17/09/2018,1,,35.00,"18.09.2018, 00:00",71,255,0,,
03/09/2018,1,,40.00,"8.09.2018, 00:00",60,164,0,,
16/10/2018,1,,35.00,"17.10.2018, 00:00",98,53,0,,
06/09/2018,3,,40.00,"10.09.2018, 00:00",226,151,0,,Gitara 4/4
20/09/2018,1,,35.00,"19.09.2018, 00:00",74,317,0,,
02/03/2018,3,,130.00,"10.03.2018, 00:00",192,350,0,,Ludwig Breakbeats
21/09/2017,3,,50.00,"27.09.2017, 00:00",175,292,0,,Skrzypce 4/4
06/08/2018,1,,150.00,"18.08.2018, 00:00",54,250,0,,
04/06/2018,3,,50.00,"11.06.2018, 00:00",224,320,0,,Skrzypce 4/4
04/04/2018,3,,20.00,"26.04.2018, 00:00",152,133,0,,GITARA 4/4
12/10/2018,2,,40.00,"11.08.2018, 00:00",94,134,0,,"Mozliwy zwrot po miesiacu, U niej 11"
10/09/2017,1,,35.00,"14.09.2017, 00:00",7,272,0,,
05/11/2018,1,,50.00,"8.11.2018, 00:00",111,241,0,,
03/03/2018,3,,35.00,"14.03.2018, 00:00",193,273,0,,Skrzypce 1/4
17/01/2018,3,,40.00,"27.01.2018, 00:00",183,202,0,,Gitara 4/4
08/01/2018,3,,50.00,"10.01.2018, 00:00",203,230,0,,Skrzypce 4/4
30/09/2018,1,,35.00,"28.09.2018, 00:00",83,52,0,,
06/07/2018,1,,50.00,"23.07.2018, 00:00",50,285,0,,
10/09/2018,1,,35.00,"13.09.2018, 00:00",65,265,0,,
01/09/2017,1,,35.00,"8.09.2017, 00:00",5,271,0,,
07/09/2017,3,,50.00,"12.09.2017, 00:00",170,315,0,,Skrzypce 4/4 nr 315
08/11/2017,3,,35.00,"10.11.2017, 00:00",165,256,0,,Skrzypce 1/8
15/10/2017,3,,40.00,"12.10.2017, 00:00",212,130,0,,GITARA 4/4
02/11/2018,1,,50.00,"6.11.2018, 00:00",107,251,0,,
10/08/2018,3,,50.00,"31.08.2018, 00:00",221,266,0,,SKRZYPCE 4/4
05/04/2018,1,,50.00,"27.04.2018, 00:00",40,259,0,,"Spr papier nie zgadza się o 1 miesiąc, WCZESNIEJ 235"
15/10/2018,1,,40.00,"15.10.2018, 00:00",97,251,0,,U niej 14
21/10/2017,3,,40.00,"16.10.2017, 00:00",179,162,0,,GITARA 3/4
15/01/2018,3,,35.00,"27.01.2018, 00:00",176,300,0,,Skrzypce  1/8
5/09/2017,0,,0.00,,,,0,,
4/09/2017,3,,50.00,"9.09.2017, 00:00",118,285,0,,Skrzypce 4/4 nr 285
13/09/2017,1,,50.00,"15.09.2017, 00:00",8,276,0,,"Wydani zastępcze 16.12 (wcześniej miała  242) , Primavera, Za dużo zapłacił o 35."
04/09/2018,3,,50.00,"10.09.2018, 00:00",222,242,0,,SKRZYPCE 3/4 GNIEZNO
05/11/2017,3,,35.00,"7.11.2017, 00:00",166,226,0,,Skrzypce 1/8
01/12/2017,3,,100.00,"1.12.2017, 00:00",178,120,0,,Ludwig Pocket Kit
02/10/2017,1,,35.00,"2.10.2017, 00:00",16,299,0,,
14/10/2017,1,,35.00,"10.10.2017, 00:00",20,227,0,,
23b/10/2017,3,,150.00,"30.10.0001, 00:00",124,350,0,,Ludwig breakbeats
10/10/2017,3,,40.00,"5.11.2017, 00:00",182,297,0,,SKRZYPCE 4/4
16/09/2017,1,,50.00,"22.09.2017, 00:00",9,279,0,,
23/09/2017,3,,0.00,"28.09.2017, 00:00",121,276,0,,Skrzypce 3/4
09/01/2018,3,,50.00,"10.01.2018, 00:00",204,291,0,,Skrzypce 1/2
01/02/2018,3,,50.00,"6.02.2018, 00:00",177,283,0,,Skrzypce 1/2
22/10/2017,3,,0.00,"16.10.2017, 00:00",123,141,0,,GITARA 4/4
03/07/2018,1,,150.00,"19.07.2018, 00:00",47,217,0,,wklej
04/11/2017,3,,0.00,"6.11.2017, 00:00",125,230,0,,Skrzypce 4/4
24/09/2018,1,,35.00,"20.09.2018, 00:00",77,299,0,,
04/10/2017,3,,0.00,"4.10.2017, 00:00",122,226,0,,Skrzypce 1/8
02/01/2018,2,,35.00,"9.01.2018, 00:00",32,258,0,,Wypowiedzenie sms 7.11.2018
16/01/2018,3,,180.00,"27.01.2018, 00:00",159,350,0,,Perkusja Ludwig
03/08/2018,3,,150.00,"11.08.2018, 00:00",205,350,0,,Perkusja Ludwig Breakbeats
01/04/2017,3,,0.00,"6.04.2017, 00:00",112,245,0,,"instrument bez numeru, niższa cena wypożyczenia i kaucji – nie było jeszcze cennika"
09/07/2018,1,,50.00,"29.07.2018, 00:00",52,241,0,,wandelewska
27/09/2017,1,,50.00,"30.09.2017, 00:00",14,239,0,,
16/09/2018,1,,35.00,"18.09.2018, 00:00",70,264,0,,
06/01/2018,3,,50.00,"6.01.2018, 00:00",162,235,0,,Skrzypce4/4
10/01/2018,3,,150.00,"13.01.0001, 00:00",160,135,0,,Saksofon altowy Trevor James
13/11/2017,3,,40.00,"18.11.2017, 00:00",132,135,0,,Gitara 1/2
20/09/2017,1,,35.00,"27.09.2017, 00:00",11,296,0,,
07/08/2018,1,,50.00,"20.08.2018, 00:00",55,304,0,,
03/12/2017,1,,35.00,"2.12.2017, 00:00",30,269,0,,
06/09/2017,1,,50.00,"9.09.2017, 00:00",6,286,0,,
06/08/2017,3,,0.00,"23.08.2017, 00:00",117,237,0,,SKRZYPCE 4/4 237
11/06/2018,3,,150.00,"25.06.2018, 00:00",216,135,0,,SAKSOFON ALTOWY
24/09/2017,1,,35.00,"29.09.2017, 00:00",12,260,0,,
13/10/2018,1,,50.00,"13.10.2018, 00:00",95,230,0,,
08/11/2018,1,,100.00,"17.11.2018, 00:00",225,193,0,,+WERBEL LUDWIG
03/04/2018,1,,150.00,"23.04.2018, 00:00",39,138,0,,Wklej
02/09/2018,1,,35.00,"4.09.2018, 00:00",59,256,0,,
02/08/2018,1,,100.00,"6.08.2018, 00:00",53,71,0,,"wklej, Możliwa chęć zakupu po roku - za 1100zl - odliczamy polowe wpłat "
05/08/2017,3,,200.00,"15.08.2017, 00:00",174,143,0,,"Yamaha Gigmaker z zestawem 6 talerzy i siedzeniem. Siedzenie gratis przy wypożyczeniu na 3 m-ce. Jeśli krócej, dopłata 20 PLN"
01/05/2017,1,,35.00,"8.05.2017, 00:00",1,60,0,,"Spr. Papierowa, WCZEŚNIEJ 1/8 287 - USZKODZENIE GUZIKA - WYMIANA NA 270"
26/09/2017,1,,50.00,"30.09.2017, 00:00",13,275,0,,Sprawdzić w papierowej umowie!
06/10/2018,3,,40.00,"8.10.2018, 00:00",88,168,0,,"Wypowiedzenie tel 25.10 , Odda do 8.12"
16/10/2017,3,,50.00,"11.10.2017, 00:00",180,274,0,,SKRZYPCE 1/2
19/10/2018,1,,35.00,"24.10.2018, 00:00",101,51,0,,
04/10/2108,1,,40.00,"4.10.2018, 00:00",86,254,0,,
02/12/17,3,,200.00,"2.12.2017, 00:00",136,350,0,,Ludwig BreakBeats + Sabian SBR
01/10/2018,3,,100.00,"1.10.2018, 00:00",225,193,0,,"Congi Remo, werbel Ludwig"
23/10/2017,1,,40.00,"16.10.2017, 00:00",22,163,0,,
03/10/2018,1,,40.00,"4.10.2018, 00:00",85,274,0,,200zl gotówka w dniu wypożyczeni
04/08/2018,3,,140.00,"11.08.2018, 00:00",206,157,0,,Saksofon tenorowy Amati
29/09/2018,1,,35.00,"27.09.2018, 00:00",82,300,0,,
13/09/2018,1,,40.00,"17.09.0001, 00:00",68,202,0,,
28/09/2018,1,,110.00,"27.09.2018, 00:00",81,150,0,,
10/11/2018,1,,100.00,"19.11.2018, 00:00",233,161,0,,
06/11/2018,1,,50.00,"14.11.2018, 00:00",112,301,0,,GNIEZNO
02/10/2018,1,,80.00,"1.10.2018, 00:00",84,352,0,,
05/12/2017,3,,20.00,"7.12.2017, 00:00",137,133,0,,Git 4/4
22/09/2018,1,,50.00,"20.09.2018, 00:00",75,251,0,,"W gotowce za 3mce, 15zl nadpłaty na styczeń"
24/10/2017,3,,150.00,"30.10.0001, 00:00",168,142,0,,Pearl vision
16B/10/2017,3,,35.00,"12.10.2017, 00:00",213,249,0,,SKRZYPCE 1/4
07/11/2018,1,,80.00,"15.11.2018, 00:00",89,57,0,,
11/09/2017,3,,50.00,"14.09.2017, 00:00",207,242,0,,Skrzypce 3/4
18/10/2017,3,,50.00,"13.10.2017, 00:00",169,316,0,,SKRZYPCE 4/4
19/09/2018,3,,100.00,"18.09.2018, 00:00",229,100,0,,Pianino cyfrowe Thomann
05/10/2018,1,,100.00,"5.10.2018, 00:00",87,351,0,,
06/10/2017,3,,50.00,"4.11.2017, 00:00",145,320,0,,SKRZYPCE 4/4
05/08/2018,3,,35.00,"17.08.2018, 00:00",218,273,0,,Skrzypce 1/4
13/06/2018,1,,100.00,"29.06.2018, 00:00",45,146,0,,Wklej
15/09/2017,3,,50.00,"16.09.2017, 00:00",126,202,0,,Gitara 4/4
13b/01/2018,3,,40.00,"23.01.2018, 00:00",158,164,0,,Gitara 3/4
25/09/2018,1,,150.00,"20.09.2018, 00:00",78,149,0,,Wklej naklejkę
01/08/2017,3,,0.00,"1.08.2017, 00:00",115,120,0,,ludwig Pocket Kit
14/09/2018,1,,140.00,"17.09.0001, 00:00",69,131,0,,
05/07/2018,1,,150.00,"20.07.2018, 00:00",49,145,0,,
10/11/2017,3,,70.00,"13.11.2017, 00:00",146,144,0,,Bas  Ibanez
5/02,0,,0.00,,,,0,,
03/10/2017,1,,40.00,"2.10.2017, 00:00",17,242,0,,"Wpisane w daty i kwoty 11. Dzień, Wcześniej 1/2 301, Skrzypce wymienione na 3/4 nr 242"
01/06/2017,3,,35.00,"2.06.2017, 00:00",127,273,0,,Skrzypce 1/4 nr 273
9/12/2017,3,,150.00,"29.12.2017, 00:00",139,122,0,,Perkusja DrumCraft 8
01/05/2018,3,,250.00,"11.05.0001, 00:00",154,142,0,,"Perkusja Pearl Vision, rozliczono tylko 100 pln z kaucji, reszta po zwrocie maszynki do hh."
22/09/2017,3,,0.00,"27.09.2017, 00:00",120,305,0,,Flat Yamaha 215
01/08/2018,3,,50.00,"6.08.2018, 00:00",153,274,0,,Skrzypce 1/2
08/07/2018,1,,50.00,"29.07.2018, 00:00",51,315,0,,
04/05/2018,3,,150.00,"30.05.2018, 00:00",195,138,0,,Perkusja Tama RHYTHM mate
01/09/2018,1,,100.00,"3.09.2018, 00:00",58,147,0,,wklej
25/09/2017,3,,50.00,"29.09.2017, 00:00",144,164,0,,Gitara 3/4
12/09/2018,1,,40.00,"14.09.2018, 00:00",67,199,0,,
9/09/2017,3,,150.00,"12.09.2017, 00:00",143,138,0,,"perkusja Tama RhythmMate biała, uczeń Piotrasa"
07/07/2018,3,,40.00,"24.07.2018, 00:00",199,162,0,,Gitara 3/4
03/08/2017,3,,50.00,"8.08.2017, 00:00",173,259,0,,Skrzypce 4/4 nr 259
04/07/2017,3,,0.00,"11.07.2017, 00:00",114,142,0,,Perkusja Pearl Vision oraz talerze Sabian XS20
05/09/2017,3,,50.00,"9.09.2017, 00:00",171,225,0,,"Skrzypce 4/4 nr 225, skrzypce nowe z używanym smyczkiem, bez podpórki"
01/11/2018,1,,35.00,"6.11.2018, 00:00",107,270,0,,
07/09/2018,3,,100.00,"11.09.2019, 00:00",228,161,0,,Wiolonczela 4/4
12/06/2018,3,,50.00,"26.06.2018, 00:00",198,283,0,,SKRZYPCE 1/2
17/10/2018,1,,100.00,"18.10.2018, 00:00",99,73,0,,
09/06/2018,3,,80.00,"21.06.2018, 00:00",187,140,0,,2x GITARA THOMANN CLASSIC S
18/10/2018,1,,50.00,"23.10.2018, 00:00",100,266,0,,
11/11/2017,1,,40.00,"13.11.2017, 00:00",27,219,0,,
24/10/2018,1,,35.00,"30.10.2018, 00:00",106,273,0,,
InstrumentType,6
type
skrzypce
perkusja
gitara
dęte drewniane
wiolonczela
pianino
Payment,1490
id,paid,paid_at,term_begin,term_end,in_cash,money_amount,deal
2341075834,true,,"16.06.2018, 00:00","15.07.2018, 23:59",,40.00,23/10/2017
3050411229,true,,"2.08.2018, 00:00","1.09.2018, 23:59",,50.00,02/07/2017
1342857719,true,,"1.11.2017, 00:00","30.11.2017, 23:59",,35.00,01/10/2017
1501167999,,"20.11.2018, 21:34","16.05.2018, 23:59","17.06.2018, 00:00",,40.00,13/09/2018
1126587096,true,,"13.03.2018, 00:00","12.04.2018, 23:59",,40.00,11/11/2017
4259309509,true,,"9.12.2017, 00:00","8.01.2018, 23:59",,50.00,5/09/2017
82823718,true,,"11.01.2018, 00:00","10.02.2018, 23:59",,50.00,16/10/2017
194522875,true,,"3.07.2018, 00:00","2.08.2018, 23:59",,50.00,01/11/2017
2254281339,true,,"18.03.2018, 00:00","17.04.2018, 23:59",,100.00,19/09/2018
1028301061,true,,"1.06.2018, 00:00","30.06.2018, 23:59",,100.00,01/12/2017
3505415786,true,,"3.02.2018, 00:00","2.03.2018, 23:59",,100.00,01/03/2018
3851671711,true,,"20.03.2018, 00:00","19.04.2018, 23:59",,120.00,02/05/2018
2084026764,true,,"30.11.2017, 00:00","29.12.2017, 23:59",,150.00,23b/10/2017
3153973398,true,,"10.11.2017, 00:00","9.12.2017, 23:59",,50.00,2/09/2017
3062364473,true,,"5.04.2018, 00:00","4.05.2018, 23:59",,40.00,09/10/2017
2695084282,true,,"25.06.2018, 00:00","24.07.2018, 23:59",,150.00,11/06/2018
914658414,true,,"3.11.2017, 00:00","2.12.2017, 23:59",,50.00,01/11/2017
3828203221,true,,"9.04.2018, 00:00","8.05.2018, 23:59",,50.00,06/11/2017
1428761806,,"20.11.2018, 21:34","17.05.2018, 23:59","18.06.2018, 00:00",,35.00,17/09/2018
3812042291,true,,"29.06.2018, 00:00","28.07.2018, 23:59",,50.00,09/07/2018
3699679095,true,,"13.04.2018, 00:00","12.05.2018, 23:59",,40.00,11/11/2017
923127400,true,,"11.03.2018, 00:00","10.04.2018, 23:59",,30.00,05/06/2018
1678409645,true,,"19.04.2018, 00:00","18.05.2018, 23:59",,35.00,20/09/2018
2815274667,true,,"20.05.2018, 00:00","19.06.2018, 23:59",,50.00,07/08/2018
2072672003,,"20.11.2018, 21:34","5.05.2018, 23:59","6.06.2018, 00:00",,50.00,02/11/2018
371654682,true,,"5.04.2018, 00:00","4.05.2018, 23:59",,40.00,02/06/2018
689540100,true,,"4.06.2018, 00:00","3.07.2018, 23:59",,40.00,03/10/2018
3767941407,true,,"5.05.2018, 00:00","4.06.2018, 23:59",,150.00,03/11/2017
1781026546,true,,"11.05.2018, 00:00","10.06.2018, 23:59",,30.00,05/06/2018
3615309500,true,,"14.09.2018, 00:00","13.10.2018, 23:59",,120.00,20/10/2017
1990061602,true,,"4.06.2018, 00:00","3.07.2018, 23:59",,50.00,01/07/2018
3619709868,true,,"16.02.2018, 00:00","15.03.2018, 23:59",,40.00,23/10/2017
2063216382,true,,"10.04.2018, 00:00","9.05.2018, 23:59",,50.00,05/09/2017
2278398022,true,,"12.10.2018, 00:00","11.11.2018, 23:59",,40.00,15/10/2017
2918749515,true,,"23.06.2018, 00:00","22.07.2018, 23:59",,150.00,03/05/2018
3259838092,,"20.11.2018, 21:34","17.11.2018, 00:00","17.12.2018, 00:00",,100.00,08/11/2018
2556428117,true,,"26.10.2017, 00:00","25.11.2017, 23:59",,50.00,19/09/2017
3545560583,true,,"15.11.2017, 00:00","14.12.2017, 23:59",,50.00,13/09/2017
1280061476,true,,"4.12.2017, 00:00","3.01.2018, 23:59",,150.00,03/07/2017
3813019182,true,,"12.05.2018, 00:00","11.06.2018, 23:59",,35.00,08/09/2018
2280634307,true,,"9.01.2018, 00:00","8.02.2018, 23:59",,50.00,5/09/2017
1010233216,true,,"20.03.2018, 00:00","19.04.2018, 23:59",,50.00,02/04/2018
2815220223,true,,"27.04.2018, 00:00","26.05.2018, 23:59",,50.00,05/04/2018
516522659,true,,"27.02.2018, 00:00","26.03.2018, 23:59",,50.00,05/04/2018
2041294819,true,,"16.03.2018, 00:00","15.04.2018, 23:59",,50.00,06/06/2018
4286460450,true,,"12.11.2017, 00:00","11.12.2017, 23:59",,35.00,16B/10/2017
1011759746,true,,"13.01.2018, 00:00","12.02.2018, 23:59",,30.00,11/10/2017
1279805345,true,,"9.12.2017, 00:00","8.01.2018, 23:59",,50.00,06/09/2017
1725089440,true,,"10.02.2018, 00:00","9.03.2018, 23:59",,30.00,12/10/2017
7113189,true,,"10.01.2018, 00:00","9.02.2018, 23:59",,50.00,2/09/2017
2402006539,true,,"12.09.2018, 00:00","11.10.2018, 23:59",,35.00,16B/10/2017
1354672115,true,,"16.05.2018, 00:00","15.06.2018, 23:59",,50.00,12/11/2017
2598942281,true,,"20.01.2018, 00:00","19.02.2018, 23:59",,50.00,18/09/2017
106073823,true,,"10.12.2017, 00:00","9.01.2018, 23:59",,35.00,14/10/2017
3965771941,true,,"9.05.2018, 00:00","8.06.2018, 23:59",,50.00,06/11/2017
2353477641,,"20.11.2018, 21:34","28.08.2018, 23:59","29.09.2018, 00:00",,100.00,13/06/2018
1501546454,true,,"3.10.2018, 00:00","2.11.2018, 23:59",,50.00,01/11/2017
3653638047,true,,"13.07.2018, 00:00","12.08.2018, 23:59",,30.00,11/10/2017
2300416181,true,,"9.10.2018, 00:00","8.11.2018, 23:59",,50.00,06/11/2017
2616008624,true,,"14.08.2018, 00:00","13.09.2018, 23:59",,35.00,10/09/2017
185579431,,"20.11.2018, 21:34","12.06.2018, 23:59","13.07.2018, 00:00",,150.00,09/09/2018
4284054803,true,,"4.06.2018, 00:00","3.07.2018, 23:59",,40.00,04/10/2108
3927300386,true,,"21.12.2017, 00:00","20.01.2018, 23:59",,50.00,14/11/2017
1610510368,true,,"18.03.2018, 00:00","17.04.2018, 23:59",,140.00,18/09/2018
1615130998,true,,"12.02.2018, 00:00","11.03.2018, 23:59",,150.00,9/09/2017
1145405387,true,,"11.09.2017, 00:00","10.10.2017, 23:59",,0.00,04/07/2017
3444519424,true,,"8.08.2018, 00:00","7.09.2018, 23:59",,35.00,01/05/2017
65962825,true,,"28.02.2018, 00:00","29.03.2018, 23:59",,150.00,24/10/2017
3902051140,true,,"12.09.2018, 00:00","11.10.2018, 23:59",,35.00,03/02/2018
3603113329,true,,"16.04.2018, 00:00","15.05.2018, 23:59",,50.00,12/11/2017
2509011340,true,,"29.05.2018, 00:00","28.06.2018, 23:59",,50.00,08/07/2018
2918709393,true,,"10.04.2018, 00:00","9.05.2018, 23:59",,40.00,08/10/2018
1162540876,true,,"14.02.2018, 00:00","13.03.2018, 23:59",,120.00,20/10/2017
2377465209,true,,"17.09.2018, 00:00","16.10.2018, 23:59",,50.00,11/01/2018
2240925836,true,,"3.03.2018, 00:00","2.04.2018, 23:59",,100.00,01/03/2018
2639501337,true,,"8.05.2018, 00:00","7.06.2018, 23:59",,35.00,01/05/2017
3166049103,true,,"27.04.2018, 00:00","26.05.2018, 23:59",,50.00,21/09/2017
3627528460,true,,"3.10.2018, 00:00","2.11.2018, 23:59",,100.00,01/03/2018
1139165840,true,,"27.06.2018, 00:00","26.07.2018, 23:59",,35.00,20/09/2017
1792209389,true,,"3.05.2018, 00:00","2.06.2018, 23:59",,100.00,01/03/2018
1861787973,true,,"12.11.2017, 00:00","11.12.2017, 23:59",,150.00,9/09/2017
1121440066,true,,"30.01.2018, 00:00","27.02.2018, 23:59",,50.00,27/09/2017
1883967527,true,,"13.03.2018, 00:00","12.04.2018, 23:59",,35.00,10/09/2018
2658303624,true,,"4.08.2017, 00:00","3.09.2017, 23:59",,150.00,03/07/2017
1728814557,true,,"23.05.2018, 00:00","22.06.2018, 23:59",,50.00,06/07/2018
2899337699,true,,"13.11.2017, 00:00","12.12.2017, 23:59",,40.00,11/11/2017
2655908961,true,,"11.04.2018, 00:00","10.05.2018, 23:59",,40.00,11/10/2018
4239488640,true,,"14.10.2018, 00:00","13.11.2018, 23:59",,35.00,10/09/2017
2578324754,true,,"30.08.2018, 00:00","29.09.2018, 23:59",,50.00,26/09/2017
4023479979,true,,"11.11.2017, 00:00","10.12.2017, 23:59",,50.00,16/10/2017
3700423031,true,,"22.09.2018, 00:00","21.10.2018, 23:59",,50.00,16/09/2017
1528758460,,"20.11.2018, 21:34","15.08.2018, 23:59","16.09.2018, 00:00",,40.00,23/10/2017
2421818198,true,,"20.10.2017, 00:00","19.11.2017, 23:59",,50.00,18/09/2017
655172806,true,,"11.03.2018, 00:00","10.04.2018, 23:59",,40.00,03/10/2017
140329312,true,,"4.11.2017, 00:00","3.12.2017, 23:59",,40.00,05/10/2017
4055818977,true,,"14.10.2017, 00:00","13.11.2017, 23:59",,35.00,10/09/2017
677108305,true,,"4.04.2018, 00:00","3.05.2018, 23:59",,40.00,03/10/2018
604304791,true,,"13.06.2018, 00:00","12.07.2018, 23:59",,50.00,18/10/2017
3844685211,true,,"14.12.2017, 00:00","13.01.2018, 23:59",,35.00,10/09/2017
4139971234,true,,"11.05.2018, 00:00","10.06.2018, 23:59",,50.00,16/10/2017
2109006424,true,,"10.09.2018, 00:00","9.10.2018, 23:59",,35.00,14/10/2017
99116106,,"20.11.2018, 21:34","16.11.2018, 23:59","17.12.2018, 00:00",,50.00,12/01/2018
4171711264,true,,"21.08.2018, 00:00","20.09.2018, 23:59",,50.00,14/11/2017
3522115057,true,,"20.07.2018, 00:00","19.08.2018, 23:59",,50.00,02/04/2018
717855745,true,,"30.10.2017, 00:00","29.11.2017, 23:59",,50.00,27/09/2017
3823599394,true,,"6.03.2018, 00:00","5.04.2018, 23:59",,50.00,01/02/2018
3797202782,true,,"29.11.2017, 00:00","28.12.2017, 23:59",,50.00,25/09/2017
535788356,true,,"17.10.2018, 00:00","16.11.2018, 23:59",,50.00,11/01/2018
3913840658,true,,"6.06.2018, 00:00","5.07.2018, 23:59",,100.00,02/08/2018
3197849781,true,,"2.02.2018, 00:00","1.03.2018, 23:59",,50.00,02/07/2017
4089525948,true,,"22.08.2018, 00:00","21.09.2018, 23:59",,50.00,16/09/2017
1276511676,true,,"13.04.2018, 00:00","12.05.2018, 23:59",,150.00,09/09/2018
2921045792,true,,"4.05.2018, 00:00","3.06.2018, 23:59",,40.00,04/10/2108
2264468322,true,,"5.08.2018, 00:00","4.09.2018, 23:59",,40.00,09/10/2017
1495468035,true,,"2.10.2018, 00:00","1.11.2018, 23:59",,50.00,02/07/2017
4149326554,true,,"9.02.2018, 00:00","8.03.2018, 23:59",,50.00,5/09/2017
2111974016,true,,"4.05.2018, 00:00","3.06.2018, 23:59",,40.00,03/10/2018
1170837584,true,,"2.06.2018, 00:00","1.07.2018, 23:59",,35.00,02/10/2017
950599832,true,,"20.07.2018, 00:00","19.08.2018, 23:59",,50.00,03/05/2017
1381965339,true,,"28.07.2018, 00:00","27.08.2018, 23:59",,100.00,08/08/2018
2532274090,true,,"12.07.2018, 00:00","11.08.2018, 23:59",,35.00,08/09/2018
2655027668,true,,"4.05.2018, 00:00","3.06.2018, 23:59",,50.00,01/07/2018
539966689,true,,"27.02.2018, 00:00","26.03.2018, 23:59",,40.00,17/01/2018
470259659,true,,"5.05.2018, 00:00","4.06.2018, 23:59",,40.00,10/10/2017
748756960,true,,"15.10.2018, 00:00","14.11.2018, 23:59",,50.00,13/09/2017
888067955,true,,"12.06.2018, 00:00","11.07.2018, 23:59",,50.00,17/10/2017
1289984453,true,,"2.09.2018, 00:00","1.10.2018, 23:59",,35.00,02/10/2017
3742050040,true,,"25.03.2018, 00:00","24.04.2018, 23:59",,150.00,11/06/2018
2291703505,true,,"26.06.2018, 00:00","25.07.2018, 23:59",,50.00,19/09/2017
2158912996,true,,"8.11.2017, 00:00","7.12.2017, 23:59",,50.00,02/08/2017
329523674,true,,"14.03.2018, 00:00","13.04.2018, 23:59",,120.00,20/10/2017
3712008282,true,,"12.11.2017, 00:00","11.12.2017, 23:59",,50.00,17/10/2017
2333492329,true,,"27.04.2018, 00:00","26.05.2018, 23:59",,40.00,18/01/2018
3415589721,true,,"22.01.2018, 00:00","21.02.2018, 23:59",,50.00,16/09/2017
2155489329,true,,"28.04.2018, 00:00","27.05.2018, 23:59",,100.00,08/08/2018
1273625602,true,,"14.12.2017, 00:00","13.01.2018, 23:59",,50.00,11/09/2017
1776176240,,"20.11.2018, 21:34","5.05.2018, 23:59","6.06.2018, 00:00",,35.00,01/11/2018
3366741429,true,,"1.02.2018, 00:00","28.02.2018, 23:59",,35.00,01/10/2017
603115957,true,,"9.06.2018, 00:00","8.07.2018, 23:59",,50.00,06/09/2017
3202580153,true,,"10.02.2018, 00:00","9.03.2018, 23:59",,150.00,01/04/2018
726980386,true,,"16.07.2018, 00:00","15.08.2018, 23:59",,40.00,23/10/2017
2685903600,true,,"19.03.2018, 00:00","18.04.2018, 23:59",,50.00,04/07/2018
2852537469,true,,"10.11.2018, 00:00","9.12.2018, 23:59",,35.00,14/10/2017
1982566849,true,,"12.10.2017, 00:00","11.11.2017, 23:59",,150.00,9/09/2017
1238694370,,"20.11.2018, 21:34","18.05.2018, 23:59","19.06.2018, 00:00",,35.00,20/09/2018
557703788,true,,"1.12.2017, 00:00","31.12.2017, 23:59",,35.00,01/10/2017
1082380765,true,,"8.07.2018, 00:00","7.08.2018, 23:59",,35.00,01/05/2017
3501813341,true,,"4.12.2017, 00:00","3.01.2018, 23:59",,50.00,06/10/2017
2377358831,true,,"4.10.2017, 00:00","3.11.2017, 23:59",,150.00,03/07/2017
2444348481,true,,"19.05.2018, 00:00","18.06.2018, 23:59",,40.00,08/06/2018
517733967,true,,"17.07.2018, 00:00","16.08.2018, 23:59",,50.00,12/01/2018
3265503365,true,,"13.09.2018, 00:00","12.10.2018, 23:59",,40.00,11/11/2017
351696175,true,,"20.03.2018, 00:00","19.04.2018, 23:59",,50.00,03/05/2017
2178296470,true,,"11.05.2018, 00:00","10.06.2018, 23:59",,50.00,04/06/2018
2249919721,,"20.11.2018, 21:34","13.05.2018, 23:59","14.06.2018, 00:00",,200.00,11/09/2018
1944073360,true,,"8.10.2018, 00:00","7.11.2018, 23:59",,35.00,01/09/2017
3494370631,,"20.11.2018, 21:34","19.09.2018, 23:59","20.10.2018, 00:00",,50.00,03/05/2017
3580828418,,"20.11.2018, 21:34","28.07.2018, 23:59","29.08.2018, 00:00",,50.00,08/07/2018
4199642287,true,,"16.03.2018, 00:00","15.04.2018, 23:59",,40.00,23/10/2017
2033783374,true,,"8.10.2017, 00:00","7.11.2017, 23:59",,35.00,01/09/2017
2827686240,true,,"12.03.2018, 00:00","11.04.2018, 23:59",,40.00,15/10/2017
2986013850,true,,"12.02.2018, 00:00","11.03.2018, 23:59",,50.00,17/10/2017
1401535136,true,,"16.03.2018, 00:00","15.04.2018, 23:59",,50.00,12/11/2017
4264333893,true,,"29.04.2018, 00:00","28.05.2018, 23:59",,50.00,09/07/2018
3388172661,true,,"12.11.2017, 00:00","11.12.2017, 23:59",,50.00,08/09/2017
2448206160,,"20.11.2018, 21:34","24.05.2018, 23:59","25.06.2018, 00:00",,35.00,20/10/2018
3094703575,true,,"18.05.2018, 00:00","17.06.2018, 23:59",,150.00,06/08/2018
3533622806,true,,"13.12.2017, 00:00","12.01.2018, 23:59",,30.00,11/10/2017
2395113562,true,,"12.09.2018, 00:00","11.10.2018, 23:59",,40.00,15/10/2017
3590815826,true,,"26.03.2018, 00:00","25.04.2018, 23:59",,50.00,19/09/2017
821108729,true,,"21.03.2018, 00:00","20.04.2018, 23:59",,50.00,14/11/2017
2636548926,,"20.11.2018, 21:34","12.11.2018, 23:59","13.12.2018, 00:00",,40.00,11/11/2017
1062110415,true,,"20.10.2018, 00:00","19.11.2018, 23:59",,50.00,02/04/2018
246259065,true,,"14.01.2018, 00:00","13.02.2018, 23:59",,50.00,11/09/2017
2493143668,,"20.11.2018, 21:34","22.09.2018, 23:59","23.10.2018, 00:00",,150.00,03/04/2018
4055794055,true,,"27.11.2017, 00:00","26.12.2017, 23:59",,50.00,21/09/2017
3992874966,true,,"15.10.2017, 00:00","14.11.2017, 23:59",,50.00,13/09/2017
2173710113,true,,"12.12.2017, 00:00","11.01.2018, 23:59",,50.00,7/09/2017
3402585505,true,,"29.05.2018, 00:00","28.06.2018, 23:59",,100.00,13/06/2018
4144704180,,"20.11.2018, 21:34","14.06.2018, 23:59","15.07.2018, 00:00",,40.00,15/10/2018
3042943151,true,,"15.08.2018, 00:00","14.09.2018, 23:59",,50.00,13/09/2017
1398381162,true,,"30.04.2018, 00:00","29.05.2018, 23:59",,150.00,04/05/2018
2636858227,true,,"10.12.2017, 00:00","9.01.2018, 23:59",,35.00,08/11/2017
698894812,true,,"20.02.2018, 00:00","19.03.2018, 23:59",,30.00,05/03/2018
3272972683,,"20.11.2018, 21:34","16.05.2018, 23:59","17.06.2018, 00:00",,140.00,14/09/2018
3423125072,true,,"16.04.2018, 00:00","15.05.2018, 23:59",,40.00,21/10/2017
3742692678,true,,"2.12.2017, 00:00","1.01.2018, 23:59",,35.00,01/07/2017
3254874442,true,,"29.03.2018, 00:00","28.04.2018, 23:59",,35.00,24/09/2017
3298188232,true,,"10.03.2018, 00:00","9.04.2018, 23:59",,50.00,05/09/2017
1083078462,true,,"27.05.2018, 00:00","26.06.2018, 23:59",,50.00,21/09/2017
2095801235,,"20.11.2018, 21:34","29.10.2018, 23:59","30.11.2018, 00:00",,50.00,26/09/2017
169278835,true,,"4.01.2018, 00:00","3.02.2018, 23:59",,40.00,05/10/2017
2724654519,true,,"20.01.2018, 00:00","19.02.2018, 23:59",,50.00,03/05/2017
223325883,true,,"2.05.2018, 00:00","1.06.2018, 23:59",,35.00,02/10/2017
3937825796,true,,"6.04.2018, 00:00","5.05.2018, 23:59",,50.00,01/02/2018
3202704265,true,,"8.06.2018, 00:00","7.07.2018, 23:59",,35.00,01/09/2017
2828145657,true,,"29.10.2017, 00:00","28.11.2017, 23:59",,50.00,25/09/2017
456447278,true,,"2.11.2017, 00:00","1.12.2017, 23:59",,35.00,01/07/2017
3698557849,true,,"2.09.2018, 00:00","1.10.2018, 23:59",,35.00,03/12/2017
998526848,true,,"14.05.2018, 00:00","13.06.2018, 23:59",,50.00,11/09/2017
136095872,true,,"29.03.2018, 00:00","28.04.2018, 23:59",,50.00,09/07/2018
2519138200,true,,"2.07.2018, 00:00","1.08.2018, 23:59",,50.00,02/07/2017
3296791618,true,,"9.02.2018, 00:00","8.03.2018, 23:59",,150.00,2/02/2018
809175006,true,,"8.04.2018, 00:00","7.05.2018, 23:59",,50.00,02/08/2017
513296469,true,,"11.01.2018, 00:00","10.02.2018, 23:59",,40.00,03/10/2017
2809289855,true,,"4.04.2018, 00:00","3.05.2018, 23:59",,35.00,02/09/2018
2837137726,true,,"14.05.2018, 00:00","13.06.2018, 23:59",,35.00,03/03/2018
3385707385,true,,"27.03.2018, 00:00","26.04.2018, 23:59",,40.00,18/01/2018
2870450645,true,,"5.12.2017, 00:00","4.01.2018, 23:59",,40.00,08/10/2017
3647436990,true,,"20.03.2018, 00:00","19.04.2018, 23:59",,150.00,25/09/2018
540877394,true,,"25.04.2018, 00:00","24.05.2018, 23:59",,150.00,10/06/2018
1707691967,true,,"30.04.2018, 00:00","29.05.2018, 23:59",,35.00,24/10/2018
15627898,,"20.11.2018, 21:34","17.05.2018, 23:59","18.06.2018, 00:00",,100.00,17/10/2018
475079647,true,,"30.10.2018, 00:00","29.11.2018, 23:59",,50.00,27/09/2017
1332116691,true,,"15.10.2017, 00:00","14.11.2017, 23:59",,200.00,05/08/2017
2937131074,true,,"9.07.2018, 00:00","8.08.2018, 23:59",,50.00,06/11/2017
205354346,true,,"17.02.2018, 00:00","16.03.2018, 23:59",,50.00,11/01/2018
4032230805,true,,"20.10.2017, 00:00","19.11.2017, 23:59",,50.00,03/05/2017
485428979,true,,"16.11.2017, 00:00","15.12.2017, 23:59",,40.00,23/10/2017
695873083,true,,"12.06.2018, 00:00","11.07.2018, 23:59",,50.00,08/09/2017
1024358828,true,,"16.11.2017, 00:00","15.12.2017, 23:59",,40.00,21/10/2017
2274425972,true,,"5.04.2018, 00:00","4.05.2018, 23:59",,40.00,10/10/2017
740111,true,,"20.06.2018, 00:00","19.07.2018, 23:59",,50.00,02/04/2018
2331218037,true,,"20.09.2017, 00:00","19.10.2017, 23:59",,50.00,03/05/2017
640948792,true,,"28.10.2017, 00:00","27.11.2017, 23:59",,0.00,23/09/2017
4084743941,true,,"12.04.2018, 00:00","11.05.2018, 23:59",,35.00,03/02/2018
1922754788,true,,"27.04.2018, 00:00","26.05.2018, 23:59",,40.00,17/01/2018
1743707404,true,,"23.03.2018, 00:00","22.04.2018, 23:59",,50.00,06/07/2018
2393580216,true,,"26.05.2018, 00:00","25.06.2018, 23:59",,50.00,19/09/2017
1936654035,true,,"16.01.2018, 00:00","15.02.2018, 23:59",,40.00,23/10/2017
2927173513,true,,"9.08.2018, 00:00","8.09.2018, 23:59",,50.00,06/12/2017
255625926,true,,"9.11.2017, 00:00","8.12.2017, 23:59",,50.00,4/09/2017
1741020703,true,,"2.09.2018, 00:00","1.10.2018, 23:59",,50.00,02/07/2017
4155084967,true,,"12.07.2018, 00:00","11.08.2018, 23:59",,35.00,03/02/2018
730185458,true,,"10.06.2018, 00:00","9.07.2018, 23:59",,30.00,12/10/2017
3323424019,true,,"21.10.2018, 00:00","20.11.2018, 23:59",,50.00,14/11/2017
3441572712,true,,"7.11.2017, 00:00","6.12.2017, 23:59",,35.00,05/11/2017
2288716137,true,,"5.06.2018, 00:00","4.07.2018, 23:59",,40.00,09/10/2017
3790108830,true,,"13.03.2018, 00:00","12.04.2018, 23:59",,70.00,5/02
475885197,true,,"15.01.2018, 00:00","14.02.2018, 23:59",,50.00,13/09/2017
3682472678,true,,"19.02.2018, 00:00","18.03.2018, 23:59",,50.00,13/01/2018
3933433527,true,,"17.05.2018, 00:00","16.06.2018, 23:59",,50.00,12/01/2018
536372861,true,,"12.02.2018, 00:00","11.03.2018, 23:59",,35.00,03/02/2018
3463526594,true,,"1.02.2018, 00:00","28.02.2018, 23:59",,100.00,01/12/2017
1953641623,true,,"27.12.2017, 00:00","26.01.2018, 23:59",,50.00,21/09/2017
4044343084,true,,"8.06.2017, 00:00","7.07.2017, 23:59",,35.00,01/05/2017
673170789,true,,"13.01.2018, 00:00","12.02.2018, 23:59",,150.00,09/11/2017
21355426,true,,"30.09.2018, 00:00","29.10.2018, 23:59",,50.00,26/09/2017
2908922690,true,,"20.05.2018, 00:00","19.06.2018, 23:59",,150.00,05/07/2018
4093040318,true,,"17.04.2018, 00:00","16.05.2018, 23:59",,50.00,11/01/2018
233002018,true,,"12.10.2018, 00:00","11.11.2018, 23:59",,35.00,03/02/2018
3521668713,true,,"16.06.2018, 00:00","15.07.2018, 23:59",,50.00,12/11/2017
2903914736,true,,"28.12.2018, 00:00","27.01.2019, 23:59",,80.00,19/01/2018
2647846090,true,,"5.05.2018, 00:00","4.06.2018, 23:59",,40.00,09/10/2017
2934828975,true,,"5.04.2018, 00:00","4.05.2018, 23:59",,35.00,07/10/2017
2684347698,,"20.11.2018, 21:34","26.06.2018, 23:59","27.07.2018, 00:00",,150.00,09/08/2018
1685726658,true,,"23.05.2018, 00:00","22.06.2018, 23:59",,150.00,03/05/2018
2394470301,true,,"25.04.2018, 00:00","24.05.2018, 23:59",,50.00,26/09/2018
130884045,true,,"10.01.2018, 00:00","9.02.2018, 23:59",,30.00,12/10/2017
2036141384,true,,"27.02.2018, 00:00","26.03.2018, 23:59",,40.00,18/01/2018
2371063972,true,,"8.01.2018, 00:00","7.02.2018, 23:59",,50.00,03/08/2017
4175744489,,"20.11.2018, 21:34","19.09.2018, 23:59","20.10.2018, 00:00",,120.00,02/05/2018
2623221302,true,,"2.11.2017, 00:00","1.12.2017, 23:59",,35.00,01/06/2017
2277043577,true,,"19.06.2017, 00:00","18.07.2017, 23:59",,0.00,02/05/2017
4115527983,true,,"9.02.2018, 00:00","8.03.2018, 23:59",,50.00,06/09/2017
2170219168,true,,"28.03.2018, 00:00","27.04.2018, 23:59",,100.00,06/03/2018
1570324199,true,,"4.01.2018, 00:00","3.02.2018, 23:59",,150.00,03/07/2017
3356041152,true,,"2.11.2018, 00:00","1.12.2018, 23:59",,50.00,02/07/2017
2242084755,true,,"27.01.2018, 00:00","26.02.2018, 23:59",,50.00,21/09/2017
1808668179,true,,"19.04.2018, 00:00","18.05.2018, 23:59",,50.00,04/07/2018
1407729190,true,,"2.08.2018, 00:00","1.09.2018, 23:59",,35.00,03/12/2017
2015589974,,"20.11.2018, 21:34","16.11.2018, 23:59","17.12.2018, 00:00",,50.00,11/01/2018
2288322611,true,,"3.09.2018, 00:00","2.10.2018, 23:59",,100.00,01/03/2018
1122283355,true,,"20.08.2018, 00:00","19.09.2018, 23:59",,50.00,03/05/2017
437479451,true,,"9.12.2017, 00:00","8.01.2018, 23:59",,80.00,07/12/3017
470862893,true,,"5.04.2018, 00:00","4.05.2018, 23:59",,35.00,04/12/2017
2392492752,true,,"5.02.2018, 00:00","4.03.2018, 23:59",,40.00,09/10/2017
3547181942,true,,"10.01.2018, 00:00","9.02.2018, 23:59",,35.00,14/10/2017
3861117682,true,,"5.03.2018, 00:00","4.04.2018, 23:59",,150.00,03/11/2017
2245270077,true,,"10.05.2018, 00:00","9.06.2018, 23:59",,40.00,08/10/2018
3105768194,true,,"2.08.2018, 00:00","1.09.2018, 23:59",,35.00,02/10/2017
2151164258,true,,"10.10.2018, 00:00","9.11.2018, 23:59",,35.00,14/10/2017
2310741599,true,,"9.03.2018, 00:00","8.04.2018, 23:59",,50.00,5/09/2017
797695045,true,,"1.05.2018, 00:00","31.05.2018, 23:59",,80.00,02/10/2018
2546354872,true,,"20.04.2018, 00:00","19.05.2018, 23:59",,50.00,03/05/2017
4233392088,true,,"28.02.2018, 00:00","27.03.2018, 23:59",,80.00,19/01/2018
3667762738,true,,"5.12.2017, 00:00","4.01.2018, 23:59",,40.00,10/10/2017
35911776,true,,"16.04.2018, 00:00","15.05.2018, 23:59",,40.00,23/10/2017
3092243641,true,,"5.02.2018, 00:00","4.03.2018, 23:59",,35.00,07/10/2017
2166972642,true,,"15.11.2017, 00:00","14.12.2017, 23:59",,200.00,05/08/2017
1608928014,true,,"9.05.2017, 00:00","8.06.2017, 23:59",,0.00,01/03/2017
3190373478,true,,"16.10.2018, 00:00","15.11.2018, 23:59",,50.00,12/11/2017
112560697,true,,"27.05.2018, 00:00","26.06.2018, 23:59",,40.00,17/01/2018
2513438182,true,,"17.01.2018, 00:00","16.02.2018, 23:59",,50.00,11/01/2018
2571020206,true,,"11.06.2018, 00:00","10.07.2018, 23:59",,50.00,04/06/2018
523459248,true,,"2.04.2018, 00:00","1.05.2018, 23:59",,50.00,02/07/2017
1774386092,true,,"10.08.2018, 00:00","9.09.2018, 23:59",,35.00,14/10/2017
1788423038,true,,"10.12.2017, 00:00","9.01.2018, 23:59",,30.00,12/10/2017
2207012235,true,,"2.01.2018, 00:00","1.02.2018, 23:59",,35.00,01/06/2017
483686394,true,,"13.04.2018, 00:00","12.05.2018, 23:59",,35.00,10/09/2018
115024472,true,,"16.08.2018, 00:00","15.09.2018, 23:59",,50.00,12/11/2017
2037823344,true,,"13.06.2018, 00:00","12.07.2018, 23:59",,40.00,11/11/2017
2296088061,true,,"27.03.2018, 00:00","26.04.2018, 23:59",,110.00,28/09/2018
2102916287,true,,"9.06.2018, 00:00","8.07.2018, 23:59",,35.00,07/11/2017
2136707152,true,,"10.04.2018, 00:00","9.05.2018, 23:59",,130.00,02/03/2018
1857780533,true,,"22.07.2018, 00:00","21.08.2018, 23:59",,50.00,16/09/2017
3986441826,true,,"6.12.2017, 00:00","5.01.2018, 23:59",,50.00,06/01/2018
2240362902,true,,"8.12.2017, 00:00","7.01.2018, 23:59",,50.00,03/08/2017
815539333,true,,"4.07.2017, 00:00","3.08.2017, 23:59",,150.00,03/07/2017
3647282981,true,,"10.06.2018, 00:00","9.07.2018, 23:59",,50.00,09/01/2018
520256700,true,,"5.10.2018, 00:00","4.11.2018, 23:59",,40.00,09/10/2017
3527433515,true,,"15.04.2017, 00:00","14.05.2017, 23:59",,0.00,04/08/2017
915574802,true,,"25.03.2018, 00:00","24.04.2018, 23:59",,150.00,10/06/2018
738729150,true,,"10.11.2017, 00:00","9.12.2017, 23:59",,30.00,12/10/2017
438985522,true,,"4.07.2018, 00:00","3.08.2018, 23:59",,40.00,04/10/2108
922172280,true,,"12.04.2018, 00:00","11.05.2018, 23:59",,35.00,08/09/2018
372097511,true,,"14.01.2018, 00:00","13.02.2018, 23:59",,120.00,20/10/2017
3780976618,true,,"12.08.2018, 00:00","11.09.2018, 23:59",,50.00,08/09/2017
2314714789,true,,"2.08.2018, 00:00","1.09.2018, 23:59",,35.00,01/07/2017
1579761093,,"20.11.2018, 21:34","4.07.2018, 23:59","4.08.2018, 23:59",,150.00,03/11/2017
3292376458,true,,"27.04.2018, 00:00","26.05.2018, 23:59",,110.00,28/09/2018
583686985,true,,"9.07.2018, 00:00","8.08.2018, 23:59",,35.00,07/11/2017
1103276768,true,,"30.03.2018, 00:00","29.04.2018, 23:59",,50.00,27/09/2017
1931191804,true,,"28.02.2018, 00:00","29.03.2018, 23:59",,50.00,27/09/2017
1167141238,true,,"9.06.2018, 00:00","8.07.2018, 23:59",,50.00,06/11/2017
3939206179,true,,"30.07.2018, 00:00","29.08.2018, 23:59",,50.00,26/09/2017
3584592064,true,,"20.11.2017, 00:00","19.12.2017, 23:59",,50.00,03/05/2017
1467063481,,"20.11.2018, 21:34","19.06.2018, 23:59","20.07.2018, 00:00",,50.00,07/08/2018
3819462082,true,,"3.03.2018, 00:00","2.04.2018, 23:59",,100.00,01/09/2018
3413123369,true,,"28.02.2018, 00:00","29.03.2018, 23:59",,50.00,26/09/2017
13879299,true,,"12.03.2018, 00:00","11.04.2018, 23:59",,35.00,08/09/2018
728567908,true,,"20.03.2018, 00:00","19.04.2018, 23:59",,150.00,05/07/2018
915471685,true,,"10.02.2018, 00:00","9.03.2018, 23:59",,35.00,08/11/2017
2600095415,true,,"10.02.2018, 00:00","9.03.2018, 23:59",,50.00,09/01/2018
337768823,true,,"2.07.2018, 00:00","1.08.2018, 23:59",,35.00,02/10/2017
2384552218,,"20.11.2018, 21:34","25.04.2018, 23:59","26.05.2018, 00:00",,40.00,27/09/2018
3655413801,true,,"4.07.2018, 00:00","3.08.2018, 23:59",,40.00,03/10/2018
1264011700,true,,"14.05.2018, 00:00","13.06.2018, 23:59",,120.00,20/10/2017
3950873512,true,,"7.11.2017, 00:00","6.12.2017, 23:59",,50.00,13/10/2107
88607742,,"20.11.2018, 21:34","19.11.2018, 00:00","19.12.2018, 00:00",,100.00,10/11/2018
3402189675,true,,"16.02.2018, 00:00","15.03.2018, 23:59",,150.00,04/03/2018
4273109907,true,,"9.11.2018, 00:00","8.12.2018, 23:59",,50.00,06/11/2017
3680027932,true,,"8.03.2018, 00:00","7.04.2018, 23:59",,50.00,02/08/2017
2525135292,,"20.11.2018, 21:34","26.05.2018, 23:59","27.06.2018, 00:00",,35.00,29/09/2018
129849379,true,,"5.12.2017, 00:00","4.01.2018, 23:59",,35.00,07/10/2017
1914377486,true,,"12.08.2018, 00:00","11.09.2018, 23:59",,35.00,03/02/2018
4226068686,true,,"17.04.2018, 00:00","16.05.2018, 23:59",,50.00,12/01/2018
1466112656,true,,"5.05.2018, 00:00","4.06.2018, 23:59",,40.00,02/06/2018
2950253213,true,,"18.04.2018, 00:00","17.05.2018, 23:59",,100.00,19/09/2018
2554606468,true,,"15.04.2018, 00:00","14.05.2018, 23:59",,50.00,13/09/2017
3973694524,,"20.11.2018, 21:34","10.07.2018, 23:59","2.09.2018, 00:00",,40.00,03/10/2017
1933529482,true,,"20.09.2018, 00:00","19.10.2018, 23:59",,50.00,02/04/2018
2297674380,true,,"16.05.2018, 00:00","15.06.2018, 23:59",,40.00,21/10/2017
1240802278,true,,"11.12.2017, 00:00","10.01.2018, 23:59",,50.00,16/10/2017
3686673111,true,,"9.08.2017, 00:00","8.09.2017, 23:59",,0.00,01/03/2017
1140816048,true,,"9.01.2018, 00:00","8.02.2018, 23:59",,50.00,06/12/2017
274327947,true,,"4.03.2018, 00:00","3.04.2018, 23:59",,35.00,02/09/2018
2337882689,true,,"14.01.2019, 00:00","13.02.2019, 23:59",,120.00,20/10/2017
543396958,true,,"26.04.2018, 00:00","25.05.2018, 23:59",,40.00,21/10/2018
1923157798,true,,"27.04.2018, 00:00","26.05.2018, 23:59",,150.00,09/08/2018
2215538582,,"20.11.2018, 21:34","10.05.2018, 23:59","11.06.2018, 00:00",,40.00,12/10/2018
3154891529,true,,"5.03.2018, 00:00","4.04.2018, 23:59",,40.00,08/10/2017
3520000605,true,,"15.03.2018, 00:00","14.04.2018, 23:59",,50.00,13/09/2017
2701889675,true,,"8.12.2017, 00:00","7.01.2018, 23:59",,35.00,01/09/2017
3612834786,true,,"3.08.2018, 00:00","2.09.2018, 23:59",,50.00,01/11/2017
3111023592,true,,"19.03.2018, 00:00","18.04.2018, 23:59",,35.00,21/09/2018
3691254931,true,,"5.03.2018, 00:00","4.04.2018, 23:59",,35.00,07/10/2017
1616350687,true,,"4.08.2018, 00:00","3.09.2018, 23:59",,40.00,03/10/2018
135971896,true,,"13.01.2018, 00:00","12.02.2018, 23:59",,50.00,18/10/2017
1022503057,true,,"3.03.2018, 00:00","2.04.2018, 23:59",,50.00,01/11/2017
1223977319,true,,"17.09.2018, 00:00","16.10.2018, 23:59",,50.00,12/01/2018
2436234068,true,,"22.11.2017, 00:00","21.12.2017, 23:59",,50.00,16/09/2017
3490881966,true,,"4.12.2017, 00:00","3.01.2018, 23:59",,100.00,04/01/2018
2103000072,true,,"14.11.2017, 00:00","13.12.2017, 23:59",,35.00,10/09/2017
1370963982,true,,"11.04.2018, 00:00","10.05.2018, 23:59",,50.00,04/06/2018
930226664,true,,"19.06.2018, 00:00","18.07.2018, 23:59",,50.00,04/07/2018
1711126553,true,,"2.04.2018, 00:00","1.05.2018, 23:59",,35.00,02/10/2017
354540279,true,,"5.01.2018, 00:00","4.02.2018, 23:59",,40.00,10/10/2017
1323683389,true,,"9.10.2017, 00:00","8.11.2017, 23:59",,50.00,4/09/2017
268786331,true,,"18.03.2018, 00:00","17.04.2018, 23:59",,35.00,17/09/2018
1441181145,true,,"9.09.2018, 00:00","8.10.2018, 23:59",,50.00,06/12/2017
2082624478,true,,"15.01.2018, 00:00","14.02.2018, 23:59",,35.00,14/09/2017
2683496528,,"20.11.2018, 21:34","6.05.2018, 23:59","7.06.2018, 00:00",,120.00,03/11/2018
2300709417,true,,"12.07.2018, 00:00","11.08.2018, 23:59",,50.00,17/10/2017
2022986550,true,,"14.05.2018, 00:00","13.06.2018, 23:59",,35.00,10/09/2017
3502629388,true,,"4.01.2018, 00:00","3.02.2018, 23:59",,40.00,02/11/2017
3647849012,true,,"14.02.2018, 00:00","13.03.2018, 23:59",,35.00,10/09/2017
3674483598,,"20.11.2018, 21:34","7.06.2018, 23:59","8.07.2018, 00:00",,40.00,03/09/2018
1478593783,true,,"1.05.2018, 00:00","31.05.2018, 23:59",,35.00,01/10/2017
103489038,true,,"12.05.2018, 00:00","11.06.2018, 23:59",,40.00,15/10/2017
923057973,true,,"2.03.2018, 00:00","1.04.2018, 23:59",,35.00,01/07/2017
1541317065,true,,"10.01.2018, 00:00","9.02.2018, 23:59",,35.00,08/11/2017
3418131722,true,,"28.03.2018, 00:00","27.04.2018, 23:59",,80.00,19/01/2018
3843156515,true,,"2.12.2017, 00:00","1.01.2018, 23:59",,200.00,02/12/17
1955936282,true,,"27.03.2018, 00:00","26.04.2018, 23:59",,35.00,20/09/2017
3607924343,true,,"9.03.2018, 00:00","8.04.2018, 23:59",,50.00,06/12/2017
3702414006,true,,"9.10.2017, 00:00","8.11.2017, 23:59",,50.00,5/09/2017
1035064387,true,,"19.03.2018, 00:00","18.04.2018, 23:59",,100.00,02/07/2018
787619256,true,,"9.12.2017, 00:00","8.01.2018, 23:59",,50.00,06/11/2017
2720617549,true,,"18.03.2018, 00:00","17.04.2018, 23:59",,40.00,15/09/2018
3348885023,true,,"2.01.2018, 00:00","1.02.2018, 23:59",,35.00,03/12/2017
3189685820,,"20.11.2018, 21:34","15.11.2018, 23:59","16.12.2018, 00:00",,50.00,12/11/2017
3973775948,true,,"7.02.2018, 00:00","6.03.2018, 23:59",,35.00,05/11/2017
2785800914,true,,"30.09.2018, 00:00","29.10.2018, 23:59",,50.00,27/09/2017
234743922,true,,"9.09.2017, 00:00","8.10.2017, 23:59",,0.00,01/03/2017
3540768485,true,,"9.06.2017, 00:00","8.07.2017, 23:59",,0.00,01/03/2017
836630570,true,,"2.03.2018, 00:00","1.04.2018, 23:59",,35.00,02/10/2017
3313106321,true,,"16.09.2018, 00:00","15.10.2018, 23:59",,50.00,12/11/2017
1704173940,true,,"8.02.2018, 00:00","7.03.2018, 23:59",,50.00,03/08/2017
1505215172,true,,"3.08.2018, 00:00","2.09.2018, 23:59",,100.00,01/03/2018
4133656773,true,,"2.08.2017, 00:00","1.09.2017, 23:59",,50.00,02/07/2017
1954819033,true,,"8.04.2018, 00:00","7.05.2018, 23:59",,40.00,03/09/2018
3683610546,true,,"18.04.2018, 00:00","17.05.2018, 23:59",,35.00,16/09/2018
3726642886,true,,"20.04.2018, 00:00","19.05.2018, 23:59",,35.00,24/09/2018
3070580139,true,,"3.01.2018, 00:00","2.02.2018, 23:59",,120.00,01/01/2018
2793551822,true,,"5.05.2018, 00:00","4.06.2018, 23:59",,35.00,07/10/2017
1813010768,true,,"8.02.2018, 00:00","7.03.2018, 23:59",,35.00,3/09/2017
490684981,true,,"9.01.2018, 00:00","8.02.2018, 23:59",,50.00,06/09/2017
3818885414,true,,"2.11.2017, 00:00","1.12.2017, 23:59",,50.00,02/07/2017
2739731746,true,,"30.03.2018, 00:00","29.04.2018, 23:59",,50.00,26/09/2017
1253285449,true,,"10.05.2018, 00:00","9.06.2018, 23:59",,50.00,09/01/2018
2592053169,true,,"17.04.2018, 00:00","16.05.2018, 23:59",,40.00,13/09/2018
3085442527,true,,"12.05.2018, 00:00","11.06.2018, 23:59",,35.00,03/02/2018
132846671,true,,"11.03.2018, 00:00","10.04.2018, 23:59",,150.00,03/08/2018
2008658854,,"20.11.2018, 21:34","19.07.2018, 23:59","20.08.2018, 00:00",,150.00,05/07/2018
719996050,true,,"13.08.2018, 00:00","12.09.2018, 23:59",,150.00,09/11/2017
3060791559,true,,"17.04.2018, 00:00","16.05.2018, 23:59",,140.00,14/09/2018
2213720131,true,,"4.11.2017, 00:00","3.12.2017, 23:59",,0.00,04/10/2017
3821372672,true,,"7.12.2017, 00:00","6.01.2018, 23:59",,35.00,05/11/2017
1605072671,true,,"30.05.2018, 00:00","29.06.2018, 23:59",,50.00,26/09/2017
1898502870,true,,"27.01.2018, 00:00","26.02.2018, 23:59",,35.00,20/09/2017
2770989416,true,,"20.02.2018, 00:00","19.03.2018, 23:59",,50.00,18/09/2017
1518861041,true,,"2.12.2018, 00:00","1.01.2019, 23:59",,35.00,01/07/2017
3724674743,true,,"9.04.2018, 00:00","8.05.2018, 23:59",,35.00,07/11/2017
3986196613,,"20.11.2018, 21:34","24.05.2018, 23:59","25.06.2018, 00:00",,50.00,26/09/2018
2588163486,true,,"28.10.2018, 00:00","27.11.2018, 23:59",,80.00,19/01/2018
883138324,true,,"13.02.2018, 00:00","12.03.2018, 23:59",,150.00,10/01/2018
3467038492,true,,"16.12.2017, 00:00","15.01.2018, 23:59",,40.00,21/10/2017
3547021202,,"20.11.2018, 21:34","25.05.2018, 23:59","26.06.2018, 00:00",,40.00,21/10/2018
756604495,true,,"16.03.2018, 00:00","15.04.2018, 23:59",,150.00,04/03/2018
2676264650,true,,"8.05.2018, 00:00","7.06.2018, 23:59",,40.00,06/10/2018
601365283,true,,"11.04.2018, 00:00","10.05.2018, 23:59",,100.00,07/09/2018
1694769947,true,,"20.03.2018, 00:00","19.04.2018, 23:59",,50.00,22/09/2018
871197481,true,,"2.09.2017, 00:00","1.10.2017, 23:59",,50.00,02/07/2017
3139833895,,"20.11.2018, 21:34","2.11.2018, 23:59","3.12.2018, 00:00",,100.00,01/03/2018
1838425636,true,,"6.04.2018, 00:00","5.05.2018, 23:59",,100.00,02/08/2018
2061517976,true,,"24.04.2018, 00:00","23.05.2018, 23:59",,35.00,19/10/2018
2138904225,true,,"20.12.2017, 00:00","19.01.2018, 23:59",,50.00,03/05/2017
3117469349,true,,"15.10.2017, 00:00","14.11.2017, 23:59",,35.00,14/09/2017
2287855667,,"20.11.2018, 21:34","11.09.2018, 23:59","12.10.2018, 00:00",,35.00,08/09/2018
3665771978,true,,"8.10.2017, 00:00","7.11.2017, 23:59",,35.00,3/09/2017
616716211,true,,"13.12.2017, 00:00","12.01.2018, 23:59",,40.00,11/11/2017
4052720849,true,,"12.10.2017, 00:00","11.11.2017, 23:59",,50.00,08/09/2017
439167649,true,,"13.02.2018, 00:00","12.03.2018, 23:59",,50.00,18/10/2017
2423941413,true,,"12.12.2017, 00:00","11.01.2018, 23:59",,40.00,15/10/2017
446030796,true,,"2.02.2018, 00:00","1.03.2018, 23:59",,35.00,03/12/2017
1997974856,true,,"10.11.2017, 00:00","9.12.2017, 23:59",,35.00,08/11/2017
3893027577,true,,"12.06.2018, 00:00","11.07.2018, 23:59",,35.00,16B/10/2017
2383695565,true,,"11.08.2017, 00:00","10.09.2017, 23:59",,0.00,04/07/2017
633140259,true,,"9.12.2017, 00:00","8.01.2018, 23:59",,50.00,06/12/2017
2817020714,true,,"27.11.2017, 00:00","26.12.2017, 23:59",,35.00,20/09/2017
953861994,true,,"12.12.2017, 00:00","11.01.2018, 23:59",,35.00,16B/10/2017
2662268267,true,,"28.03.2018, 00:00","27.04.2018, 23:59",,100.00,08/08/2018
2839903851,true,,"28.02.2018, 00:00","27.03.2018, 23:59",,100.00,06/03/2018
2796447724,true,,"5.05.2018, 00:00","4.06.2018, 23:59",,100.00,05/10/2018
3341343151,true,,"2.05.2018, 00:00","1.06.2018, 23:59",,50.00,02/07/2017
3688885358,true,,"22.10.2018, 00:00","21.11.2018, 23:59",,50.00,16/09/2017
203932422,true,,"15.12.2017, 00:00","14.01.2018, 23:59",,50.00,13/09/2017
1249749046,true,,"27.04.2018, 00:00","26.05.2018, 23:59",,35.00,15/01/2018
403558687,true,,"13.07.2018, 00:00","12.08.2018, 23:59",,150.00,09/11/2017
411949273,true,,"12.03.2018, 00:00","11.04.2018, 23:59",,35.00,16B/10/2017
4012511959,true,,"6.06.2017, 00:00","5.07.2017, 23:59",,0.00,1/04/2017
1864542333,true,,"12.08.2018, 00:00","11.09.2018, 23:59",,50.00,17/10/2017
272901731,true,,"4.11.2017, 00:00","3.12.2017, 23:59",,40.00,02/11/2017
1790400958,true,,"27.05.2018, 00:00","26.06.2018, 23:59",,35.00,20/09/2017
1016242463,true,,"27.03.2018, 00:00","26.04.2018, 23:59",,40.00,17/01/2018
3070675098,true,,"12.06.2018, 00:00","11.07.2018, 23:59",,35.00,03/02/2018
3890469404,true,,"15.04.2018, 00:00","14.05.2018, 23:59",,50.00,14/10/2018
2933553304,true,,"6.05.2017, 00:00","5.06.2017, 23:59",,0.00,1/04/2017
3199953341,true,,"10.02.2018, 00:00","9.03.2018, 23:59",,130.00,02/03/2018
20862594,true,,"30.11.2017, 00:00","29.12.2017, 23:59",,50.00,27/09/2017
867521996,true,,"22.10.2017, 00:00","21.11.2017, 23:59",,50.00,16/09/2017
2636942819,true,,"1.06.2018, 00:00","30.06.2018, 23:59",,35.00,01/10/2017
1097581294,true,,"1.04.2018, 00:00","30.04.2018, 23:59",,80.00,02/10/2018
3113576380,true,,"8.03.2018, 00:00","7.04.2018, 23:59",,150.00,03/06/2018
1592287588,true,,"2.10.2017, 00:00","1.11.2017, 23:59",,35.00,01/06/2017
1728216425,true,,"2.04.2018, 00:00","1.05.2018, 23:59",,35.00,01/07/2017
1002665537,true,,"11.03.2018, 00:00","10.04.2018, 23:59",,140.00,04/08/2018
2493499950,true,,"3.06.2018, 00:00","2.07.2018, 23:59",,50.00,01/11/2017
2053553338,true,,"5.11.2017, 00:00","4.12.2017, 23:59",,40.00,09/10/2017
1852348094,true,,"27.01.2018, 00:00","26.02.2018, 23:59",,180.00,15/01/2018
3033664552,true,,"16.12.2017, 00:00","15.01.2018, 23:59",,50.00,12/11/2017
3134293185,true,,"17.08.2018, 00:00","16.09.2018, 23:59",,50.00,11/01/2018
1498663532,true,,"28.01.2018, 00:00","27.02.2018, 23:59",,50.00,07/08/2017
1578489775,,"20.11.2018, 21:34","9.05.2018, 23:59","10.06.2018, 00:00",,150.00,09/10/2018
1617221530,true,,"28.05.2018, 00:00","27.06.2018, 23:59",,120.00,07/03/2018
3951781801,true,,"2.07.2017, 00:00","1.08.2017, 23:59",,35.00,01/06/2017
1081584791,true,,"9.03.2018, 00:00","8.04.2018, 23:59",,35.00,02/01/2018
2702264589,true,,"23.04.2018, 00:00","22.05.2018, 23:59",,150.00,03/05/2018
3794011720,true,,"28.04.2018, 00:00","27.05.2018, 23:59",,120.00,07/03/2018
3691097373,true,,"22.05.2018, 00:00","21.06.2018, 23:59",,50.00,16/09/2017
3716674732,true,,"12.02.2018, 00:00","11.03.2018, 23:59",,50.00,7/09/2017
1907472906,true,,"9.05.2018, 00:00","8.06.2018, 23:59",,35.00,07/11/2017
2875454833,true,,"8.12.2017, 00:00","7.01.2018, 23:59",,35.00,01/05/2017
1361574404,true,,"20.06.2018, 00:00","19.07.2018, 23:59",,120.00,02/05/2018
2796941512,true,,"17.01.2018, 00:00","16.02.2018, 23:59",,50.00,12/01/2018
1659942616,true,,"20.04.2018, 00:00","19.05.2018, 23:59",,150.00,25/09/2018
1792009307,true,,"7.04.2018, 00:00","6.05.2018, 23:59",,120.00,03/11/2018
1925268602,true,,"11.03.2018, 00:00","10.04.2018, 23:59",,50.00,16/10/2017
153980286,true,,"20.03.2018, 00:00","19.04.2018, 23:59",,50.00,18/09/2017
2114933941,true,,"16.10.2017, 00:00","15.11.2017, 23:59",,50.00,15/09/2017
1017288836,true,,"21.09.2018, 00:00","20.10.2018, 23:59",,50.00,14/11/2017
1546387594,true,,"27.10.2017, 00:00","26.11.2017, 23:59",,50.00,21/09/2017
2234025873,true,,"4.11.2017, 00:00","3.12.2017, 23:59",,50.00,06/10/2017
1584300748,true,,"14.09.2018, 00:00","13.10.2018, 23:59",,35.00,10/09/2017
1633345831,true,,"5.07.2018, 00:00","4.08.2018, 23:59",,40.00,09/10/2017
1629340242,true,,"15.07.2018, 00:00","14.08.2018, 23:59",,50.00,13/09/2017
3915887623,true,,"8.01.2018, 00:00","7.02.2018, 23:59",,35.00,3/09/2017
2640717653,,"20.11.2018, 21:34","22.05.2018, 23:59","23.06.2018, 00:00",,50.00,18/10/2018
1608213149,true,,"9.11.2017, 00:00","8.12.2017, 23:59",,35.00,07/11/2017
1870627193,true,,"8.04.2018, 00:00","7.05.2018, 23:59",,35.00,01/05/2017
3884703420,true,,"10.04.2018, 00:00","9.05.2018, 23:59",,30.00,12/10/2017
2642773989,true,,"8.02.2018, 00:00","7.03.2018, 23:59",,35.00,01/05/2017
3115952350,true,,"13.01.2018, 00:00","12.02.2018, 23:59",,150.00,10/01/2018
3648416094,true,,"2.10.2018, 00:00","1.11.2018, 23:59",,35.00,03/12/2017
2340292157,true,,"27.02.2018, 00:00","26.03.2018, 23:59",,35.00,20/09/2017
1739907170,true,,"14.12.2017, 00:00","13.01.2018, 23:59",,120.00,20/10/2017
2546133420,true,,"16.06.2018, 00:00","15.07.2018, 23:59",,40.00,21/10/2017
1444259452,true,,"16.03.2018, 00:00","15.04.2018, 23:59",,100.00,07/06/2018
1165817472,true,,"10.01.2018, 00:00","9.02.2018, 23:59",,50.00,09/01/2018
4269196272,true,,"5.06.2018, 00:00","4.07.2018, 23:59",,40.00,08/10/2017
2956250379,true,,"10.03.2018, 00:00","9.04.2018, 23:59",,130.00,02/03/2018
1401076413,true,,"28.05.2018, 00:00","27.06.2018, 23:59",,100.00,08/08/2018
1349924349,true,,"15.11.2018, 00:00","14.12.2018, 23:59",,50.00,13/09/2017
431418201,true,,"30.04.2018, 00:00","29.05.2018, 23:59",,150.00,23/10/2018
3677470500,true,,"15.02.2018, 00:00","14.03.2018, 23:59",,50.00,13/09/2017
2496713763,true,,"9.08.2018, 00:00","8.09.2018, 23:59",,35.00,02/01/2018
1066080824,true,,"25.04.2018, 00:00","24.05.2018, 23:59",,150.00,11/06/2018
363076889,true,,"19.04.2018, 00:00","18.05.2018, 23:59",,100.00,02/07/2018
2188851097,true,,"12.01.2018, 00:00","11.02.2018, 23:59",,50.00,7/09/2017
1596148828,true,,"5.06.2018, 00:00","4.07.2018, 23:59",,35.00,04/12/2017
4176036884,true,,"14.02.2018, 00:00","13.03.2018, 23:59",,50.00,11/09/2017
2086553529,true,,"3.07.2018, 00:00","2.08.2018, 23:59",,100.00,01/03/2018
4222448181,true,,"9.03.2018, 00:00","8.04.2018, 23:59",,35.00,07/11/2017
3854326702,true,,"2.12.2017, 00:00","1.01.2018, 23:59",,35.00,02/10/2017
2435631540,true,,"2.07.2018, 00:00","1.08.2018, 23:59",,35.00,03/12/2017
3472391871,,"20.11.2018, 21:34","10.05.2018, 23:59","11.06.2018, 00:00",,40.00,11/10/2018
3237659110,true,,"17.07.2018, 00:00","16.08.2018, 23:59",,50.00,11/01/2018
757832325,true,,"9.10.2018, 00:00","8.11.2018, 23:59",,35.00,07/11/2017
1796962482,true,,"5.01.2018, 00:00","4.02.2018, 23:59",,40.00,09/10/2017
3866289258,true,,"5.07.2018, 00:00","4.08.2018, 23:59",,35.00,04/12/2017
3054685910,true,,"27.12.2017, 00:00","26.01.2018, 23:59",,35.00,20/09/2017
820421901,true,,"19.03.2018, 00:00","18.04.2018, 23:59",,35.00,20/09/2018
1803448805,true,,"8.04.2018, 00:00","7.05.2018, 23:59",,40.00,06/10/2018
1767556283,true,,"2.09.2018, 00:00","1.10.2018, 23:59",,35.00,01/07/2017
2884228915,true,,"11.04.2018, 00:00","10.05.2018, 23:59",,50.00,16/10/2017
2173505578,true,,"5.04.2018, 00:00","4.05.2018, 23:59",,40.00,08/10/2017
3387564987,true,,"3.05.2018, 00:00","2.06.2018, 23:59",,50.00,01/11/2017
3641622456,true,,"8.11.2017, 00:00","7.12.2017, 23:59",,50.00,03/08/2017
2499063859,true,,"3.11.2018, 00:00","2.12.2018, 23:59",,50.00,01/11/2017
920207908,true,,"21.02.2018, 00:00","20.03.2018, 23:59",,50.00,14/11/2017
1851215689,,"20.11.2018, 21:34","27.08.2018, 23:59","27.09.2018, 23:59",,100.00,08/08/2018
1715718489,true,,"10.04.2018, 00:00","9.05.2018, 23:59",,50.00,09/01/2018
451590314,true,,"5.06.2018, 00:00","4.07.2018, 23:59",,40.00,10/10/2017
1510244609,true,,"30.08.2018, 00:00","29.09.2018, 23:59",,50.00,27/09/2017
1070467607,true,,"12.04.2018, 00:00","11.05.2018, 23:59",,35.00,16B/10/2017
2751931128,true,,"18.11.2017, 00:00","17.12.2017, 23:59",,40.00,13/11/2017
289080672,true,,"8.10.2017, 00:00","7.11.2017, 23:59",,35.00,01/05/2017
874054948,true,,"11.07.2018, 00:00","10.08.2018, 23:59",,30.00,05/06/2018
1467359457,true,,"14.11.2017, 00:00","13.12.2017, 23:59",,120.00,20/10/2017
357459729,true,,"18.03.2018, 00:00","17.04.2018, 23:59",,35.00,16/09/2018
2831344360,true,,"13.12.2017, 00:00","12.01.2018, 23:59",,50.00,18/10/2017
3623664434,true,,"10.10.2017, 00:00","9.11.2017, 23:59",,50.00,2/09/2017
2558911614,true,,"10.03.2018, 00:00","9.04.2018, 23:59",,150.00,01/04/2018
635053011,true,,"2.09.2017, 00:00","1.10.2017, 23:59",,35.00,01/07/2017
1344398600,true,,"9.11.2018, 00:00","8.12.2018, 23:59",,35.00,07/11/2017
479530236,true,,"30.03.2018, 00:00","29.04.2018, 23:59",,150.00,04/05/2018
2460114842,,"20.11.2018, 21:34","26.05.2018, 23:59","27.06.2018, 00:00",,110.00,28/09/2018
3255907672,true,,"9.11.2017, 00:00","8.12.2017, 23:59",,50.00,06/11/2017
1622337623,true,,"23.04.2018, 00:00","22.05.2018, 23:59",,50.00,06/07/2018
1098687843,true,,"2.12.2018, 00:00","1.01.2019, 23:59",,35.00,02/10/2017
558292726,true,,"29.06.2018, 00:00","28.07.2018, 23:59",,50.00,08/07/2018
2581317022,true,,"1.09.2017, 00:00","30.09.2017, 23:59",,0.00,01/08/2017
1635518085,,"20.11.2018, 21:34","17.05.2018, 23:59","18.06.2018, 00:00",,140.00,18/09/2018
3921409692,,"20.11.2018, 21:34","29.05.2018, 23:59","30.06.2018, 00:00",,150.00,23/10/2018
1718061863,,"20.11.2018, 21:34","15.11.2018, 00:00","15.12.2018, 00:00",,80.00,07/11/2018
1356478786,true,,"26.02.2018, 00:00","25.03.2018, 23:59",,50.00,19/09/2017
1185967147,true,,"27.04.2018, 00:00","26.05.2018, 23:59",,35.00,20/09/2017
3174359887,true,,"12.07.2018, 00:00","11.08.2018, 23:59",,35.00,16B/10/2017
3052512112,true,,"14.04.2018, 00:00","13.05.2018, 23:59",,35.00,10/09/2017
3852554020,true,,"26.01.2018, 00:00","25.02.2018, 23:59",,50.00,19/09/2017
3330960077,true,,"30.01.2018, 00:00","27.02.2018, 23:59",,150.00,24/10/2017
1388748213,true,,"20.02.2018, 00:00","19.03.2018, 23:59",,50.00,02/04/2018
1627506533,true,,"11.12.2017, 00:00","10.01.2018, 23:59",,40.00,03/10/2017
434048245,true,,"8.11.2017, 00:00","7.12.2017, 23:59",,35.00,3/09/2017
731929025,true,,"19.04.2018, 00:00","18.05.2018, 23:59",,35.00,21/09/2018
3567611443,true,,"28.11.2018, 00:00","27.12.2018, 23:59",,80.00,19/01/2018
3024951098,,"20.11.2018, 21:34","9.11.2018, 00:00","9.12.2018, 00:00",,100.00,04/11/2018
116019203,true,,"9.07.2018, 00:00","8.08.2018, 23:59",,35.00,02/01/2018
2977324423,,"20.11.2018, 21:34","8.11.2018, 00:00","8.12.2018, 00:00",,50.00,05/11/2018
1879126795,true,,"3.04.2018, 00:00","2.05.2018, 23:59",,100.00,01/03/2018
3658617242,true,,"11.02.2018, 00:00","10.03.2018, 23:59",,50.00,16/10/2017
999006581,true,,"27.09.2018, 00:00","26.10.2018, 23:59",,35.00,20/09/2017
3186818779,true,,"8.10.2017, 00:00","7.11.2017, 23:59",,50.00,03/08/2017
1356572064,true,,"30.11.2018, 00:00","29.12.2018, 23:59",,50.00,27/09/2017
3949612418,true,,"14.06.2018, 00:00","13.07.2018, 23:59",,35.00,10/09/2017
2278134809,,"20.11.2018, 21:34","28.10.2018, 23:59","29.11.2018, 00:00",,35.00,24/09/2017
3810719054,true,,"29.01.2018, 00:00","27.02.2018, 23:59",,35.00,24/09/2017
3514171797,true,,"10.03.2018, 00:00","9.04.2018, 23:59",,40.00,06/09/2018
26565901,true,,"13.11.2017, 00:00","12.12.2017, 23:59",,70.00,10/11/2017
3826120206,true,,"8.08.2017, 00:00","7.09.2017, 23:59",,35.00,01/05/2017
1451478784,true,,"14.07.2018, 00:00","13.08.2018, 23:59",,50.00,11/09/2017
2815903423,true,,"5.06.2018, 00:00","4.07.2018, 23:59",,150.00,03/11/2017
4078281840,true,,"27.07.2018, 00:00","26.08.2018, 23:59",,35.00,20/09/2017
59399375,true,,"4.12.2017, 00:00","3.01.2018, 23:59",,50.00,05/01/2018
2470120388,true,,"30.12.2017, 00:00","29.01.2018, 23:59",,50.00,27/09/2017
2448292026,true,,"18.04.2018, 00:00","17.05.2018, 23:59",,35.00,17/09/2018
2124024418,true,,"23.06.2018, 00:00","22.07.2018, 23:59",,150.00,03/04/2018
2398932913,true,,"20.04.2018, 00:00","19.05.2018, 23:59",,50.00,07/08/2018
1976386307,true,,"20.12.2017, 00:00","19.01.2018, 23:59",,50.00,18/09/2017
340798658,true,,"15.06.2018, 00:00","14.07.2018, 23:59",,50.00,13/09/2017
607455896,true,,"10.12.2017, 00:00","9.01.2018, 23:59",,50.00,2/09/2017
2524023707,true,,"4.01.2018, 00:00","3.02.2018, 23:59",,35.00,03/01/2018
1889480020,true,,"4.01.2018, 00:00","3.02.2018, 23:59",,70.00,01/06/2018
350489330,true,,"6.04.2018, 00:00","5.05.2018, 23:59",,35.00,01/11/2018
3812616287,true,,"12.01.2018, 00:00","11.02.2018, 23:59",,35.00,16B/10/2017
2577164548,true,,"29.12.2017, 00:00","28.01.2018, 23:59",,35.00,24/09/2017
2959885773,,"20.11.2018, 21:34","14.11.2018, 00:00","14.12.2018, 00:00",,50.00,06/11/2018
4237922287,true,,"9.04.2018, 00:00","8.05.2018, 23:59",,35.00,02/01/2018
2489568972,true,,"26.07.2018, 00:00","25.08.2018, 23:59",,50.00,19/09/2017
1181002162,true,,"17.06.2018, 00:00","16.07.2018, 23:59",,50.00,11/01/2018
2323984416,,"20.11.2018, 21:34","14.05.2018, 23:59","15.06.2018, 00:00",,50.00,14/10/2018
1176065301,true,,"19.01.2018, 00:00","18.02.2018, 23:59",,50.00,13/01/2018
3644913623,true,,"30.06.2018, 00:00","29.07.2018, 23:59",,50.00,26/09/2017
576679821,true,,"29.06.2018, 00:00","28.07.2018, 23:59",,35.00,24/09/2017
3830801899,true,,"8.04.2018, 00:00","7.05.2018, 23:59",,35.00,01/09/2017
1259680682,true,,"10.05.2018, 00:00","9.06.2018, 23:59",,50.00,08/01/2018
2642568500,true,,"30.03.2018, 00:00","29.04.2018, 23:59",,150.00,24/10/2017
119170153,true,,"9.11.2017, 00:00","8.12.2017, 23:59",,50.00,06/09/2017
3230842227,true,,"14.04.2018, 00:00","13.05.2018, 23:59",,120.00,20/10/2017
2020029674,true,,"8.01.2018, 00:00","7.02.2018, 23:59",,50.00,02/08/2017
3747150342,true,,"10.05.2018, 00:00","9.06.2018, 23:59",,30.00,12/10/2017
4016542585,true,,"9.02.2018, 00:00","8.03.2018, 23:59",,80.00,07/12/3017
229433176,true,,"27.11.2018, 00:00","26.12.2018, 23:59",,35.00,20/09/2017
3267090181,true,,"15.05.2018, 00:00","14.06.2018, 23:59",,50.00,06/02/2018
148588326,true,,"9.09.2018, 00:00","8.10.2018, 23:59",,50.00,06/11/2017
1294448337,true,,"20.05.2018, 00:00","19.06.2018, 23:59",,50.00,02/04/2018
3781804411,true,,"30.12.2017, 00:00","29.01.2018, 23:59",,150.00,24/10/2017
3129650816,true,,"13.11.2017, 00:00","12.12.2017, 23:59",,30.00,11/10/2017
4270690265,true,,"14.03.2018, 00:00","13.04.2018, 23:59",,50.00,11/09/2017
187996506,true,,"30.04.2018, 00:00","29.05.2018, 23:59",,50.00,26/09/2017
1152882270,true,,"3.01.2018, 00:00","2.02.2018, 23:59",,50.00,01/11/2017
1717390941,true,,"11.03.2018, 00:00","10.04.2018, 23:59",,100.00,07/09/2018
1105994596,true,,"28.09.2017, 00:00","27.10.2017, 23:59",,50.00,07/08/2017
3514296283,true,,"13.07.2018, 00:00","12.08.2018, 23:59",,40.00,11/11/2017
11254112,true,,"8.07.2018, 00:00","7.08.2018, 23:59",,35.00,01/09/2017
3963147206,true,,"29.07.2018, 00:00","28.08.2018, 23:59",,35.00,24/09/2017
1220723060,true,,"8.03.2018, 00:00","7.04.2018, 23:59",,35.00,01/05/2017
2665896952,true,,"2.10.2017, 00:00","1.11.2017, 23:59",,35.00,01/07/2017
1595610489,true,,"20.05.2018, 00:00","19.06.2018, 23:59",,35.00,24/09/2018
1733371138,true,,"27.05.2018, 00:00","26.06.2018, 23:59",,50.00,05/04/2018
4291097079,true,,"5.02.2018, 00:00","4.03.2018, 23:59",,150.00,03/11/2017
941705452,true,,"13.11.2017, 00:00","12.12.2017, 23:59",,50.00,18/10/2017
3635639786,true,,"8.10.2017, 00:00","7.11.2017, 23:59",,50.00,02/08/2017
526843897,true,,"16.02.2018, 00:00","15.03.2018, 23:59",,40.00,21/10/2017
611716820,true,,"16.03.2018, 00:00","15.04.2018, 23:59",,40.00,21/10/2017
1189009253,,"20.11.2018, 21:34","17.06.2018, 23:59","18.07.2018, 00:00",,150.00,06/08/2018
1902701430,true,,"29.05.2018, 00:00","28.06.2018, 23:59",,50.00,09/07/2018
314898096,,"20.11.2018, 21:34","8.10.2018, 23:59","9.11.2018, 00:00",,35.00,02/01/2018
974176312,true,,"4.04.2018, 00:00","3.05.2018, 23:59",,70.00,01/06/2018
1404440174,true,,"16.07.2018, 00:00","15.08.2018, 23:59",,50.00,12/11/2017
512252236,true,,"3.02.2018, 00:00","2.03.2018, 23:59",,120.00,01/01/2018
1542610385,true,,"22.02.2018, 00:00","21.03.2018, 23:59",,50.00,16/09/2017
600225877,true,,"23.08.2018, 00:00","22.09.2018, 23:59",,150.00,03/04/2018
4079486870,true,,"26.08.2018, 00:00","25.09.2018, 23:59",,50.00,19/09/2017
3811319592,true,,"27.04.2018, 00:00","26.05.2018, 23:59",,35.00,29/09/2018
1221671873,true,,"10.03.2018, 00:00","9.04.2018, 23:59",,50.00,09/01/2018
1970607015,true,,"3.02.2018, 00:00","2.03.2018, 23:59",,50.00,01/11/2017
1347516320,,"20.11.2018, 21:34","18.07.2018, 23:59","19.08.2018, 00:00",,150.00,03/07/2018
1953524196,true,,"5.11.2017, 00:00","4.12.2017, 23:59",,40.00,08/10/2017
2774787275,true,,"20.11.2018, 00:00","19.12.2018, 23:59",,50.00,18/09/2017
1640757857,true,,"5.01.2018, 00:00","4.02.2018, 23:59",,150.00,03/11/2017
3958471742,true,,"13.05.2018, 00:00","12.06.2018, 23:59",,50.00,18/10/2017
1459191601,true,,"20.06.2018, 00:00","19.07.2018, 23:59",,50.00,03/05/2017
2853297962,true,,"5.02.2018, 00:00","4.03.2018, 23:59",,40.00,08/10/2017
1794986478,true,,"17.03.2018, 00:00","16.04.2018, 23:59",,140.00,14/09/2018
2095939391,true,,"19.03.2018, 00:00","18.04.2018, 23:59",,150.00,03/07/2018
2438251217,true,,"29.09.2018, 00:00","28.10.2018, 23:59",,35.00,24/09/2017
1265855694,true,,"26.03.2018, 00:00","25.04.2018, 23:59",,40.00,27/09/2018
2965943654,true,,"21.06.2018, 00:00","20.07.2018, 23:59",,50.00,14/11/2017
335550117,,"20.11.2018, 21:34","13.05.2018, 23:59","14.06.2018, 00:00",,40.00,12/09/2018
3177144738,true,,"23.07.2018, 00:00","22.08.2018, 23:59",,150.00,03/04/2018
4241371184,true,,"5.07.2018, 00:00","4.08.2018, 23:59",,40.00,08/10/2017
2823406725,true,,"14.10.2017, 00:00","13.11.2017, 23:59",,50.00,11/09/2017
1983124653,true,,"12.03.2018, 00:00","11.04.2018, 23:59",,35.00,03/02/2018
71983380,true,,"27.08.2018, 00:00","26.09.2018, 23:59",,35.00,20/09/2017
2978441596,,"20.11.2018, 21:34","28.07.2018, 23:59","29.08.2018, 00:00",,50.00,09/07/2018
2570557198,true,,"12.11.2017, 00:00","11.12.2017, 23:59",,50.00,7/09/2017
3498541415,true,,"4.04.2018, 00:00","3.05.2018, 23:59",,50.00,01/07/2018
457355122,,"20.11.2018, 21:34","2.06.2018, 23:59","3.07.2018, 00:00",,100.00,01/09/2018
3135241375,true,,"8.06.2018, 00:00","7.07.2018, 23:59",,35.00,01/05/2017
2957076934,true,,"11.06.2018, 00:00","10.07.2018, 23:59",,50.00,16/10/2017
3215605369,true,,"2.01.2018, 00:00","1.02.2018, 23:59",,35.00,01/07/2017
2496267879,true,,"27.02.2018, 00:00","26.03.2018, 23:59",,35.00,15/01/2018
3881746123,true,,"27.02.2018, 00:00","26.03.2018, 23:59",,50.00,21/09/2017
1838864894,true,,"8.02.2018, 00:00","7.03.2018, 23:59",,50.00,02/08/2017
2137312342,true,,"13.01.2018, 00:00","12.02.2018, 23:59",,70.00,10/11/2017
715908643,true,,"12.09.2018, 00:00","11.10.2018, 23:59",,50.00,17/10/2017
1108773843,true,,"13.12.2017, 00:00","12.01.2018, 23:59",,150.00,09/11/2017
4109997944,true,,"12.02.2018, 00:00","11.03.2018, 23:59",,35.00,16B/10/2017
952212012,true,,"3.12.2017, 00:00","2.01.2018, 23:59",,50.00,01/11/2017
3192983898,true,,"14.08.2018, 00:00","13.09.2018, 23:59",,50.00,11/09/2017
2408012103,true,,"5.07.2018, 00:00","4.08.2018, 23:59",,40.00,02/06/2018
2894902499,true,,"12.05.2018, 00:00","11.06.2018, 23:59",,35.00,16B/10/2017
3469567276,true,,"4.06.2018, 00:00","3.07.2018, 23:59",,35.00,02/09/2018
1871088122,true,,"14.04.2018, 00:00","13.05.2018, 23:59",,50.00,11/09/2017
3353405497,true,,"9.09.2018, 00:00","8.10.2018, 23:59",,35.00,07/11/2017
1413781794,true,,"8.11.2018, 00:00","7.12.2018, 23:59",,35.00,01/05/2017
1276312819,true,,"10.05.2018, 00:00","9.06.2018, 23:59",,130.00,02/03/2018
683369016,true,,"29.11.2017, 00:00","28.12.2017, 23:59",,150.00,16/11/2017
3457481946,true,,"8.03.2018, 00:00","7.04.2018, 23:59",,40.00,03/09/2018
3533483929,true,,"20.08.2018, 00:00","19.09.2018, 23:59",,50.00,02/04/2018
2807594120,true,,"9.07.2018, 00:00","8.08.2018, 23:59",,50.00,06/12/2017
3631801842,true,,"11.05.2018, 00:00","10.06.2018, 23:59",,40.00,03/10/2017
3222907006,true,,"30.11.2017, 00:00","29.12.2017, 23:59",,150.00,24/10/2017
889066468,,"20.11.2018, 21:34","9.06.2018, 23:59","10.07.2018, 00:00",,40.00,08/10/2018
1098625840,,"20.11.2018, 21:34","27.04.2018, 23:59","28.05.2018, 00:00",,35.00,30/09/2018
2133627863,true,,"13.04.2018, 00:00","12.05.2018, 23:59",,50.00,18/10/2017
2991381670,true,,"2.10.2018, 00:00","1.11.2018, 23:59",,35.00,02/10/2017
883574733,true,,"8.09.2017, 00:00","7.10.2017, 23:59",,50.00,03/08/2017
3572772025,true,,"5.12.2017, 00:00","4.01.2018, 23:59",,35.00,04/12/2017
135704346,,"20.11.2018, 21:34","18.07.2018, 23:59","19.08.2018, 00:00",,50.00,04/07/2018
3738214789,,"20.11.2018, 21:34","9.05.2018, 23:59","10.06.2018, 00:00",,80.00,10/10/2018
1597218420,true,,"23.04.2018, 00:00","22.05.2018, 23:59",,150.00,03/04/2018
3816684037,true,,"6.03.2018, 00:00","5.04.2018, 23:59",,100.00,02/08/2018
3321753963,true,,"9.02.2018, 00:00","8.03.2018, 23:59",,35.00,02/01/2018
2022461032,true,,"13.10.2018, 00:00","12.11.2018, 23:59",,40.00,11/11/2017
2266976381,true,,"23.06.2018, 00:00","22.07.2018, 23:59",,50.00,06/07/2018
3274719215,true,,"10.01.2018, 00:00","9.02.2018, 23:59",,50.00,08/01/2018
2355438254,true,,"28.05.2018, 00:00","27.06.2018, 23:59",,100.00,06/03/2018
1982985303,true,,"5.01.2018, 00:00","4.02.2018, 23:59",,35.00,04/12/2017
1182292652,true,,"28.04.2018, 00:00","27.05.2018, 23:59",,80.00,19/01/2018
1590425020,true,,"5.04.2018, 00:00","4.05.2018, 23:59",,100.00,05/10/2018
1899333032,true,,"10.03.2018, 00:00","9.04.2018, 23:59",,35.00,14/10/2017
1990531471,true,,"12.02.2018, 00:00","11.03.2018, 23:59",,50.00,08/09/2017
1257039597,true,,"21.07.2018, 00:00","20.08.2018, 23:59",,50.00,14/11/2017
2543590623,true,,"15.12.2017, 00:00","14.01.2018, 23:59",,35.00,14/09/2017
1196623508,true,,"18.03.2018, 00:00","17.04.2018, 23:59",,150.00,06/08/2018
3172838232,true,,"2.02.2018, 00:00","1.03.2018, 23:59",,35.00,01/07/2017
1404552335,true,,"5.11.2017, 00:00","4.12.2017, 23:59",,40.00,10/10/2017
986767786,true,,"14.08.2018, 00:00","13.09.2018, 23:59",,120.00,20/10/2017
3424626029,true,,"6.05.2018, 00:00","5.06.2018, 23:59",,100.00,02/08/2018
494956883,true,,"2.01.2018, 00:00","1.02.2018, 23:59",,35.00,02/10/2017
246131766,true,,"5.11.2017, 00:00","4.12.2017, 23:59",,150.00,03/11/2017
172140213,true,,"20.06.2017, 00:00","19.07.2017, 23:59",,50.00,03/05/2017
191678967,true,,"2.03.2018, 00:00","1.04.2018, 23:59",,50.00,02/07/2017
3477296739,true,,"12.10.2017, 00:00","11.11.2017, 23:59",,50.00,7/09/2017
3650158215,true,,"20.07.2017, 00:00","19.08.2017, 23:59",,50.00,03/05/2017
3238667570,true,,"2.08.2017, 00:00","1.09.2017, 23:59",,35.00,01/07/2017
4212668472,true,,"9.08.2018, 00:00","8.09.2018, 23:59",,35.00,07/11/2017
4049090459,true,,"18.04.2018, 00:00","17.05.2018, 23:59",,150.00,06/08/2018
521402793,true,,"11.06.2018, 00:00","10.07.2018, 23:59",,30.00,05/06/2018
159268538,true,,"28.04.2018, 00:00","27.05.2018, 23:59",,100.00,06/03/2018
1353401370,true,,"9.01.2018, 00:00","8.02.2018, 23:59",,35.00,02/01/2018
2263822882,true,,"9.03.2018, 00:00","8.04.2018, 23:59",,80.00,07/12/3017
4126539615,true,,"13.05.2018, 00:00","12.06.2018, 23:59",,150.00,09/11/2017
1382383357,true,,"29.04.2018, 00:00","28.05.2018, 23:59",,35.00,24/09/2017
242611650,true,,"17.08.2018, 00:00","16.09.2018, 23:59",,50.00,12/01/2018
2122836089,true,,"5.03.2018, 00:00","4.04.2018, 23:59",,40.00,09/10/2017
3302809192,,"20.11.2018, 21:34","4.06.2018, 23:59","5.07.2018, 00:00",,100.00,05/10/2018
2344242955,true,,"13.01.2018, 00:00","12.02.2018, 23:59",,40.00,11/11/2017
1848530207,true,,"14.07.2018, 00:00","13.08.2018, 23:59",,120.00,20/10/2017
780861377,true,,"23.02.2018, 00:00","22.03.2018, 23:59",,150.00,03/04/2018
1006002405,true,,"9.06.2018, 00:00","8.07.2018, 23:59",,35.00,02/01/2018
2869182861,,"20.11.2018, 21:34","8.05.2018, 23:59","9.06.2018, 00:00",,40.00,07/10/2018
1734891993,true,,"12.08.2018, 00:00","11.09.2018, 23:59",,35.00,08/09/2018
1549259790,true,,"12.12.2017, 00:00","11.01.2018, 23:59",,150.00,9/09/2017
666201478,true,,"10.05.2018, 00:00","9.06.2018, 23:59",,35.00,14/10/2017
3396290243,true,,"29.12.2017, 00:00","28.01.2018, 23:59",,150.00,16/11/2017
1207355315,,"20.11.2018, 21:34","19.05.2018, 23:59","20.06.2018, 00:00",,150.00,25/09/2018
1475321608,true,,"20.03.2018, 00:00","19.04.2018, 23:59",,35.00,24/09/2018
3516258563,true,,"9.12.2017, 00:00","8.01.2018, 23:59",,35.00,07/11/2017
246993917,true,,"26.12.2017, 00:00","25.01.2018, 23:59",,50.00,19/09/2017
985528103,true,,"5.05.2018, 00:00","4.06.2018, 23:59",,35.00,04/12/2017
2636701549,true,,"23.07.2018, 00:00","22.08.2018, 23:59",,150.00,03/05/2018
3487178809,true,,"1.11.2018, 00:00","30.11.2018, 23:59",,35.00,01/10/2017
2491732442,true,,"8.05.2018, 00:00","7.06.2018, 23:59",,35.00,01/09/2017
3868463215,true,,"3.04.2018, 00:00","2.05.2018, 23:59",,100.00,01/09/2018
2829276138,true,,"30.04.2018, 00:00","29.05.2018, 23:59",,50.00,27/09/2017
3862547060,true,,"10.06.2018, 00:00","9.07.2018, 23:59",,50.00,08/01/2018
4089693606,true,,"13.06.2018, 00:00","12.07.2018, 23:59",,50.00,13/10/2018
3045300434,true,,"15.11.2017, 00:00","14.12.2017, 23:59",,35.00,14/09/2017
2464363758,true,,"2.09.2017, 00:00","1.10.2017, 23:59",,35.00,01/06/2017
1646183659,true,,"10.03.2018, 00:00","9.04.2018, 23:59",,50.00,08/01/2018
410647936,true,,"16.11.2017, 00:00","15.12.2017, 23:59",,50.00,15/09/2017
3690193892,true,,"27.03.2018, 00:00","26.04.2018, 23:59",,50.00,05/04/2018
1504517344,true,,"4.12.2017, 00:00","3.01.2018, 23:59",,40.00,02/11/2017
3244799073,true,,"25.04.2018, 00:00","24.05.2018, 23:59",,35.00,20/10/2018
3459622226,true,,"22.03.2018, 00:00","21.04.2018, 23:59",,50.00,16/09/2017
1053096930,true,,"3.06.2018, 00:00","2.07.2018, 23:59",,100.00,01/03/2018
2602386051,true,,"20.04.2018, 00:00","19.05.2018, 23:59",,50.00,18/09/2017
3577015298,true,,"5.09.2018, 00:00","4.10.2018, 23:59",,35.00,04/12/2017
3814853733,true,,"2.12.2018, 00:00","1.01.2019, 23:59",,50.00,02/07/2017
4116630834,true,,"8.08.2018, 00:00","7.09.2018, 23:59",,35.00,01/09/2017
3938611221,true,,"9.10.2017, 00:00","8.11.2017, 23:59",,50.00,06/09/2017
1345934654,true,,"3.05.2018, 00:00","2.06.2018, 23:59",,100.00,01/09/2018
1361363032,true,,"12.01.2018, 00:00","11.02.2018, 23:59",,40.00,15/10/2017
2580324345,true,,"19.06.2018, 00:00","18.07.2018, 23:59",,150.00,03/07/2018
445219454,true,,"5.02.2018, 00:00","4.03.2018, 23:59",,35.00,04/12/2017
1814640521,true,,"11.04.2018, 00:00","10.05.2018, 23:59",,40.00,12/10/2018
3705541778,true,,"8.02.2018, 00:00","7.03.2018, 23:59",,35.00,01/09/2017
1380917183,true,,"26.11.2017, 00:00","25.12.2017, 23:59",,50.00,19/09/2017
737587685,true,,"14.11.2017, 00:00","13.12.2017, 23:59",,50.00,11/09/2017
420827084,true,,"1.01.2018, 00:00","31.01.2018, 23:59",,35.00,01/10/2017
197554713,true,,"14.06.2018, 00:00","13.07.2018, 23:59",,120.00,20/10/2017
1710817229,,"20.11.2018, 21:34","3.07.2018, 23:59","4.08.2018, 00:00",,35.00,02/09/2018
178322868,,"20.11.2018, 21:34","17.05.2018, 23:59","18.06.2018, 00:00",,35.00,16/09/2018
3983049951,true,,"10.03.2018, 00:00","9.04.2018, 23:59",,30.00,12/10/2017
2200418548,true,,"14.04.2018, 00:00","13.05.2018, 23:59",,200.00,11/09/2018
116952550,true,,"14.10.2018, 00:00","13.11.2018, 23:59",,120.00,20/10/2017
2628474645,true,,"15.04.2018, 00:00","14.05.2018, 23:59",,50.00,06/02/2018
1238174039,true,,"19.05.2018, 00:00","18.06.2018, 23:59",,50.00,04/07/2018
3422194803,true,,"9.05.2018, 00:00","8.06.2018, 23:59",,50.00,06/09/2017
3251692882,true,,"11.04.2018, 00:00","10.05.2018, 23:59",,40.00,03/10/2017
1173410488,,"20.11.2018, 21:34","4.08.2018, 23:59","5.09.2018, 00:00",,40.00,08/10/2017
541263950,true,,"21.04.2018, 00:00","20.05.2018, 23:59",,50.00,14/11/2017
910635991,true,,"28.02.2018, 00:00","27.03.2018, 23:59",,120.00,07/03/2018
1453973738,,"20.11.2018, 21:34","31.05.2018, 23:59","1.07.2018, 00:00",,80.00,02/10/2018
642453585,true,,"28.11.2017, 00:00","27.12.2017, 23:59",,50.00,07/08/2017
3562270424,true,,"4.01.2018, 00:00","3.02.2018, 23:59",,50.00,06/10/2017
3178077377,true,,"2.10.2018, 00:00","1.11.2018, 23:59",,35.00,01/07/2017
2123589971,true,,"12.05.2018, 00:00","11.06.2018, 23:59",,50.00,17/10/2017
3162401801,true,,"29.04.2018, 00:00","28.05.2018, 23:59",,100.00,22/10/2018
640593782,true,,"29.06.2018, 00:00","28.07.2018, 23:59",,100.00,13/06/2018
3941061273,true,,"20.06.2018, 00:00","19.07.2018, 23:59",,150.00,05/07/2018
1260155633,true,,"13.03.2018, 00:00","12.04.2018, 23:59",,150.00,09/11/2017
3850239497,true,,"20.03.2018, 00:00","19.04.2018, 23:59",,35.00,23/09/2018
1654793284,true,,"10.02.2018, 00:00","9.03.2018, 23:59",,50.00,08/01/2018
2523855446,true,,"2.06.2018, 00:00","1.07.2018, 23:59",,35.00,03/12/2017
340628310,true,,"17.10.2018, 00:00","16.11.2018, 23:59",,50.00,12/01/2018
3201246844,true,,"8.12.2017, 00:00","7.01.2018, 23:59",,35.00,3/09/2017
3033356851,true,,"17.06.2018, 00:00","16.07.2018, 23:59",,50.00,12/01/2018
975993127,true,,"28.09.2018, 00:00","27.10.2018, 23:59",,80.00,19/01/2018
1361520005,true,,"15.03.2018, 00:00","14.04.2018, 23:59",,50.00,06/02/2018
1885582864,true,,"9.07.2018, 00:00","8.08.2018, 23:59",,50.00,06/09/2017
1703301688,true,,"2.11.2018, 00:00","1.12.2018, 23:59",,35.00,01/07/2017
892861435,true,,"17.04.2018, 00:00","16.05.2018, 23:59",,35.00,05/08/2018
295989659,true,,"5.05.2018, 00:00","4.06.2018, 23:59",,40.00,08/10/2017
1999612062,true,,"19.07.2018, 00:00","18.08.2018, 23:59",,40.00,08/06/2018
2853807170,true,,"9.05.2018, 00:00","8.06.2018, 23:59",,50.00,06/12/2017
1181468676,true,,"20.08.2018, 00:00","19.09.2018, 23:59",,120.00,02/05/2018
3025506904,true,,"31.03.2018, 00:00","29.04.2018, 23:59",,50.00,10/08/2018
1005521652,true,,"23.01.2018, 00:00","22.02.2018, 23:59",,40.00,13b/01/2018
324938425,true,,"8.10.2018, 00:00","7.11.2018, 23:59",,35.00,01/05/2017
2462798260,true,,"23.04.2018, 00:00","22.05.2018, 23:59",,50.00,18/10/2018
2749630958,true,,"2.05.2018, 00:00","1.06.2018, 23:59",,35.00,03/12/2017
4233298206,true,,"26.04.2018, 00:00","25.05.2018, 23:59",,50.00,19/09/2017
671275525,true,,"16.02.2018, 00:00","15.03.2018, 23:59",,50.00,12/11/2017
4183486948,true,,"20.03.2018, 00:00","19.04.2018, 23:59",,50.00,07/08/2018
3219541649,true,,"28.07.2018, 00:00","27.08.2018, 23:59",,80.00,19/01/2018
3206126613,true,,"12.06.2018, 00:00","11.07.2018, 23:59",,35.00,08/09/2018
3845821972,true,,"28.02.2018, 00:00","29.03.2018, 23:59",,50.00,06/04/2018
1387774175,true,,"19.04.2018, 00:00","18.05.2018, 23:59",,150.00,03/07/2018
4177447928,true,,"5.07.2018, 00:00","4.08.2018, 23:59",,35.00,07/10/2017
1700216053,true,,"14.02.2018, 00:00","13.03.2018, 23:59",,35.00,03/03/2018
1973607228,true,,"30.06.2018, 00:00","29.07.2018, 23:59",,50.00,27/09/2017
144650350,,"20.11.2018, 21:34","8.11.2018, 23:59","9.12.2018, 00:00",,50.00,06/12/2017
222286986,true,,"28.06.2018, 00:00","27.07.2018, 23:59",,100.00,08/08/2018
235430241,true,,"5.01.2018, 00:00","4.02.2018, 23:59",,35.00,07/10/2017
2546141733,,"20.11.2018, 21:34","11.11.2018, 23:59","12.12.2018, 00:00",,35.00,03/02/2018
1396730417,,"20.11.2018, 21:34","29.05.2018, 23:59","30.06.2018, 00:00",,35.00,24/10/2018
327123223,true,,"12.11.2017, 00:00","11.12.2017, 23:59",,40.00,15/10/2017
3770623899,true,,"20.09.2018, 00:00","19.10.2018, 23:59",,50.00,18/09/2017
698693400,true,,"12.12.2017, 00:00","11.01.2018, 23:59",,50.00,08/09/2017
2890658976,true,,"10.04.2018, 00:00","9.05.2018, 23:59",,150.00,09/10/2018
3952320811,true,,"27.01.2018, 00:00","26.02.2018, 23:59",,40.00,18/01/2018
3600912907,true,,"9.12.2017, 00:00","8.01.2018, 23:59",,50.00,4/09/2017
3920319551,true,,"1.05.2018, 00:00","31.05.2018, 23:59",,100.00,01/12/2017
3082749611,true,,"12.01.2018, 00:00","11.02.2018, 23:59",,50.00,08/09/2017
4220041629,true,,"10.04.2018, 00:00","9.05.2018, 23:59",,50.00,08/01/2018
1245612316,true,,"14.03.2018, 00:00","13.04.2018, 23:59",,35.00,03/03/2018
3916066187,true,,"28.05.2018, 00:00","27.06.2018, 23:59",,80.00,19/01/2018
4202131653,true,,"20.05.2018, 00:00","19.06.2018, 23:59",,120.00,02/05/2018
837486204,true,,"28.08.2018, 00:00","27.09.2018, 23:59",,80.00,19/01/2018
2936866025,true,,"12.04.2018, 00:00","11.05.2018, 23:59",,50.00,17/10/2017
1977755221,true,,"27.03.2018, 00:00","26.04.2018, 23:59",,35.00,29/09/2018
891523299,true,,"28.10.2017, 00:00","27.11.2017, 23:59",,50.00,07/08/2017
1118663167,true,,"24.05.2018, 00:00","23.06.2018, 23:59",,35.00,19/10/2018
3426396765,true,,"20.04.2018, 00:00","19.05.2018, 23:59",,35.00,23/09/2018
3072285968,true,,"25.03.2018, 00:00","24.04.2018, 23:59",,50.00,26/09/2018
3147094262,true,,"8.03.2018, 00:00","7.04.2018, 23:59",,50.00,03/08/2017
1676715503,,"20.11.2018, 21:34","12.11.2018, 23:59","13.12.2018, 00:00",,30.00,11/10/2017
574537896,true,,"13.08.2018, 00:00","12.09.2018, 23:59",,40.00,11/11/2017
4131285903,true,,"13.02.2018, 00:00","12.03.2018, 23:59",,40.00,11/11/2017
3979460249,,"20.11.2018, 21:34","28.05.2018, 23:59","29.06.2018, 00:00",,100.00,22/10/2018
1828040480,true,,"8.12.2017, 00:00","7.01.2018, 23:59",,50.00,02/08/2017
685933333,true,,"13.10.2018, 00:00","12.11.2018, 23:59",,30.00,11/10/2017
455085271,true,,"29.04.2018, 00:00","28.05.2018, 23:59",,100.00,13/06/2018
2527927735,true,,"10.04.2018, 00:00","9.05.2018, 23:59",,80.00,10/10/2018
4117474470,true,,"20.05.2018, 00:00","19.06.2018, 23:59",,50.00,18/09/2017
1907322535,true,,"5.03.2018, 00:00","4.04.2018, 23:59",,35.00,04/12/2017
2545017160,true,,"1.03.2018, 00:00","31.03.2018, 23:59",,100.00,01/12/2017
4163683434,true,,"5.06.2018, 00:00","4.07.2018, 23:59",,40.00,02/06/2018
1601204631,true,,"9.02.2018, 00:00","8.03.2018, 23:59",,50.00,06/12/2017
1882023047,true,,"19.04.2018, 00:00","18.05.2018, 23:59",,50.00,13/01/2018
1689201364,,"20.11.2018, 21:34","19.05.2018, 23:59","20.06.2018, 00:00",,35.00,23/09/2018
2867238000,true,,"29.05.2018, 00:00","28.06.2018, 23:59",,35.00,24/09/2017
1508516469,true,,"2.11.2018, 00:00","1.12.2018, 23:59",,35.00,03/12/2017
1192900066,true,,"14.04.2018, 00:00","13.05.2018, 23:59",,40.00,12/09/2018
1643589871,true,,"15.12.2017, 00:00","14.01.2018, 23:59",,200.00,05/08/2017
785151585,true,,"13.06.2018, 00:00","12.07.2018, 23:59",,150.00,09/11/2017
174099491,true,,"15.05.2018, 00:00","14.06.2018, 23:59",,40.00,15/10/2018
1961511956,,"20.11.2018, 21:34","19.11.2018, 00:00","19.12.2018, 00:00",,50.00,09/11/2018
2339684533,true,,"10.07.2018, 00:00","9.08.2018, 23:59",,35.00,14/10/2017
4278034425,true,,"14.04.2018, 00:00","13.05.2018, 23:59",,35.00,03/03/2018
2632483941,true,,"7.12.2017, 00:00","6.01.2018, 23:59",,50.00,13/10/2107
912747024,true,,"8.09.2017, 00:00","7.10.2017, 23:59",,50.00,02/08/2017
954912059,true,,"13.04.2018, 00:00","12.05.2018, 23:59",,150.00,09/11/2017
3645819574,true,,"2.12.2017, 00:00","1.01.2018, 23:59",,35.00,03/12/2017
603167797,,"20.11.2018, 21:34","23.06.2018, 23:59","24.07.2018, 00:00",,35.00,19/10/2018
227096039,true,,"28.06.2018, 00:00","27.07.2018, 23:59",,100.00,06/03/2018
2707130056,true,,"1.04.2018, 00:00","30.04.2018, 23:59",,100.00,01/12/2017
416727630,true,,"13.05.2018, 00:00","12.06.2018, 23:59",,50.00,13/10/2018
3800770204,true,,"12.02.2018, 00:00","11.03.2018, 23:59",,40.00,15/10/2017
1387095117,true,,"30.12.2017, 00:00","29.01.2018, 23:59",,50.00,26/09/2017
3714295076,,"20.11.2018, 21:34","22.07.2018, 23:59","23.08.2018, 00:00",,50.00,06/07/2018
2420563069,true,,"4.11.2017, 00:00","3.12.2017, 23:59",,150.00,03/07/2017
1359595821,true,,"30.05.2018, 00:00","29.06.2018, 23:59",,150.00,04/05/2018
2444179154,true,,"9.10.2017, 00:00","8.11.2017, 23:59",,0.00,01/03/2017
1485648445,true,,"29.03.2018, 00:00","28.04.2018, 23:59",,50.00,08/07/2018
1752053165,true,,"10.04.2018, 00:00","9.05.2018, 23:59",,35.00,14/10/2017
1570505787,true,,"11.11.2017, 00:00","10.12.2017, 23:59",,40.00,03/10/2017
533375490,true,,"2.06.2018, 00:00","1.07.2018, 23:59",,50.00,02/07/2017
2260804094,true,,"28.06.2018, 00:00","27.07.2018, 23:59",,120.00,07/03/2018
1276200820,true,,"6.02.2018, 00:00","5.03.2018, 23:59",,50.00,01/02/2018
3966305519,true,,"10.04.2018, 00:00","9.05.2018, 23:59",,40.00,06/09/2018
3714439788,true,,"9.04.2018, 00:00","8.05.2018, 23:59",,80.00,07/12/3017
2773050433,true,,"15.04.2018, 00:00","14.05.2018, 23:59",,40.00,15/10/2018
35182569,true,,"29.08.2018, 00:00","28.09.2018, 23:59",,35.00,24/09/2017
2551351817,true,,"11.06.2018, 00:00","10.07.2018, 23:59",,40.00,03/10/2017
1571124197,true,,"9.01.2018, 00:00","8.02.2018, 23:59",,80.00,07/12/3017
4167347852,true,,"2.12.2017, 00:00","1.01.2018, 23:59",,50.00,02/07/2017
449971122,true,,"14.06.2018, 00:00","13.07.2018, 23:59",,50.00,11/09/2017
1310340557,true,,"21.11.2017, 00:00","20.12.2017, 23:59",,50.00,14/11/2017
1035003668,true,,"13.11.2017, 00:00","12.12.2017, 23:59",,150.00,09/11/2017
874731647,,"20.11.2018, 21:34","16.05.2018, 23:59","17.06.2018, 00:00",,35.00,16/10/2018
2027198123,true,,"5.08.2018, 00:00","4.09.2018, 23:59",,35.00,04/12/2017
3137903635,true,,"4.04.2018, 00:00","3.05.2018, 23:59",,40.00,04/10/2108
3214503159,true,,"4.02.2018, 00:00","3.03.2018, 23:59",,35.00,03/01/2018
1164734613,true,,"1.09.2018, 00:00","30.09.2018, 23:59",,35.00,01/10/2017
2295774498,true,,"9.01.2018, 00:00","8.02.2018, 23:59",,35.00,07/11/2017
773374546,true,,"29.03.2018, 00:00","28.04.2018, 23:59",,100.00,13/06/2018
2555598019,true,,"5.11.2017, 00:00","4.12.2017, 23:59",,35.00,07/10/2017
812439405,true,,"12.07.2018, 00:00","11.08.2018, 23:59",,50.00,08/09/2017
1378840549,true,,"6.02.2018, 00:00","5.03.2018, 23:59",,50.00,06/01/2018
48615005,true,,"10.11.2017, 00:00","9.12.2017, 23:59",,35.00,14/10/2017
1355972233,true,,"12.07.2018, 00:00","11.08.2018, 23:59",,40.00,15/10/2017
3927214527,true,,"28.03.2018, 00:00","27.04.2018, 23:59",,35.00,30/09/2018
2177344807,true,,"23.03.2018, 00:00","22.04.2018, 23:59",,150.00,03/05/2018
1294668836,true,,"29.04.2018, 00:00","28.05.2018, 23:59",,50.00,08/07/2018
3507478532,true,,"23.08.2018, 00:00","22.09.2018, 23:59",,150.00,03/05/2018
1461889011,true,,"13.03.2018, 00:00","12.04.2018, 23:59",,150.00,09/09/2018
1428423130,true,,"9.06.2018, 00:00","8.07.2018, 23:59",,50.00,06/12/2017
486121493,true,,"19.03.2018, 00:00","18.04.2018, 23:59",,50.00,13/01/2018
87708920,true,,"13.02.2018, 00:00","12.03.2018, 23:59",,30.00,11/10/2017
1163422218,true,,"20.05.2018, 00:00","19.06.2018, 23:59",,50.00,03/05/2017
955201660,true,,"15.05.2018, 00:00","14.06.2018, 23:59",,50.00,13/09/2017
2319832695,true,,"16.11.2017, 00:00","15.12.2017, 23:59",,50.00,12/11/2017
3965715154,true,,"9.12.2018, 00:00","8.01.2019, 23:59",,50.00,06/09/2017
3856767274,true,,"22.12.2017, 00:00","21.01.2018, 23:59",,50.00,16/09/2017
1240718304,true,,"9.07.2017, 00:00","8.08.2017, 23:59",,0.00,01/03/2017
1330738659,true,,"14.01.2018, 00:00","13.02.2018, 23:59",,35.00,10/09/2017
3446260426,true,,"12.01.2018, 00:00","11.02.2018, 23:59",,50.00,17/10/2017
1076717182,true,,"12.08.2018, 00:00","11.09.2018, 23:59",,40.00,15/10/2017
1108354248,true,,"17.03.2018, 00:00","16.04.2018, 23:59",,40.00,13/09/2018
2614612210,true,,"19.05.2018, 00:00","18.06.2018, 23:59",,150.00,03/07/2018
1369104045,true,,"5.06.2018, 00:00","4.07.2018, 23:59",,35.00,07/10/2017
394140795,true,,"2.05.2018, 00:00","1.06.2018, 23:59",,35.00,01/07/2017
1400704048,true,,"12.01.2018, 00:00","11.02.2018, 23:59",,150.00,9/09/2017
3883787130,true,,"16.11.2017, 00:00","15.12.2017, 23:59",,0.00,22/10/2017
2517620179,true,,"16.01.2018, 00:00","15.02.2018, 23:59",,40.00,21/10/2017
2198302302,true,,"10.06.2018, 00:00","9.07.2018, 23:59",,35.00,14/10/2017
4140800138,true,,"4.12.2017, 00:00","3.01.2018, 23:59",,40.00,05/10/2017
3152986116,true,,"9.03.2018, 00:00","8.04.2018, 23:59",,50.00,06/09/2017
1419328721,true,,"8.09.2018, 00:00","7.10.2018, 23:59",,35.00,01/05/2017
3804475062,,"20.11.2018, 21:34","22.09.2018, 23:59","22.10.2018, 23:59",,150.00,03/05/2018
3840899509,true,,"5.12.2017, 00:00","4.01.2018, 23:59",,150.00,03/11/2017
2718016150,,"20.11.2018, 21:34","7.11.2018, 23:59","8.12.2018, 00:00",,35.00,01/09/2017
417759224,true,,"22.06.2018, 00:00","21.07.2018, 23:59",,50.00,16/09/2017
371030847,true,,"12.12.2017, 00:00","11.01.2018, 23:59",,50.00,17/10/2017
3236208873,true,,"3.04.2018, 00:00","2.05.2018, 23:59",,50.00,01/11/2017
3653561389,true,,"20.04.2018, 00:00","19.05.2018, 23:59",,120.00,02/05/2018
3582618878,true,,"20.04.2018, 00:00","19.05.2018, 23:59",,50.00,02/04/2018
781805414,true,,"29.07.2018, 00:00","28.08.2018, 23:59",,100.00,13/06/2018
1868049806,true,,"12.05.2018, 00:00","11.06.2018, 23:59",,50.00,08/09/2017
1579209328,true,,"29.10.2017, 00:00","28.11.2017, 23:59",,35.00,24/09/2017
3627090818,true,,"27.03.2018, 00:00","26.04.2018, 23:59",,50.00,21/09/2017
2915886960,true,,"24.03.2018, 00:00","23.04.2018, 23:59",,40.00,07/07/2018
664688364,true,,"2.02.2018, 00:00","1.03.2018, 23:59",,35.00,02/10/2017
973654513,true,,"27.03.2018, 00:00","26.04.2018, 23:59",,35.00,15/01/2018
1280789193,true,,"9.04.2018, 00:00","8.05.2018, 23:59",,40.00,07/10/2018
3302012768,true,,"16.05.2018, 00:00","15.06.2018, 23:59",,40.00,23/10/2017
2156334007,true,,"9.04.2018, 00:00","8.05.2018, 23:59",,50.00,06/12/2017
354121376,true,,"2.08.2017, 00:00","1.09.2017, 23:59",,35.00,01/06/2017
1523760939,true,,"26.02.2018, 00:00","25.03.2018, 23:59",,20.00,04/04/2018
465469294,true,,"30.04.2018, 00:00","29.05.2018, 23:59",,150.00,24/10/2017
2653770822,true,,"13.02.2018, 00:00","12.03.2018, 23:59",,150.00,09/11/2017
2564306278,true,,"9.01.2018, 00:00","8.02.2018, 23:59",,50.00,06/11/2017
2960744271,true,,"9.05.2018, 00:00","8.06.2018, 23:59",,35.00,02/01/2018
894420312,true,,"14.09.2018, 00:00","13.10.2018, 23:59",,50.00,11/09/2017
1669005584,true,,"14.07.2018, 00:00","13.08.2018, 23:59",,35.00,10/09/2017
4197388995,true,,"28.06.2018, 00:00","27.07.2018, 23:59",,80.00,19/01/2018
2689756982,true,,"21.01.2018, 00:00","20.02.2018, 23:59",,50.00,14/11/2017
166411769,true,,"13.12.2017, 00:00","12.01.2018, 23:59",,70.00,10/11/2017
2537422092,true,,"30.11.2017, 00:00","29.12.2017, 23:59",,50.00,26/09/2017
3931680701,true,,"14.03.2018, 00:00","13.04.2018, 23:59",,35.00,10/09/2017
4257251842,true,,"20.11.2017, 00:00","19.12.2017, 23:59",,50.00,18/09/2017
1608127889,true,,"11.02.2018, 00:00","10.03.2018, 23:59",,40.00,03/10/2017
799488078,true,,"30.05.2018, 00:00","29.06.2018, 23:59",,50.00,27/09/2017
4211786103,true,,"16.12.2017, 00:00","15.01.2018, 23:59",,40.00,23/10/2017
3107926398,true,,"28.12.2017, 00:00","27.01.2018, 23:59",,50.00,07/08/2017
1296811367,true,,"29.11.2017, 00:00","28.12.2017, 23:59",,35.00,24/09/2017
3922727604,true,,"9.08.2018, 00:00","8.09.2018, 23:59",,50.00,06/11/2017
275148493,,"20.11.2018, 21:34","3.08.2018, 23:59","4.09.2018, 00:00",,40.00,04/10/2108
789927797,true,,"17.03.2018, 00:00","16.04.2018, 23:59",,35.00,05/08/2018
841929200,true,,"1.04.2018, 00:00","30.04.2018, 23:59",,35.00,01/10/2017
3327211435,true,,"13.03.2018, 00:00","12.04.2018, 23:59",,50.00,18/10/2017
596772167,true,,"9.02.2018, 00:00","8.03.2018, 23:59",,35.00,07/11/2017
1350153178,true,,"27.10.2017, 00:00","26.11.2017, 23:59",,0.00,22/09/2017
1914729111,true,,"2.11.2018, 00:00","1.12.2018, 23:59",,35.00,02/10/2017
2497414618,true,,"13.05.2018, 00:00","12.06.2018, 23:59",,150.00,09/09/2018
4154101590,true,,"7.01.2018, 00:00","6.02.2018, 23:59",,35.00,05/11/2017
2223853183,true,,"28.01.2018, 00:00","27.02.2018, 23:59",,80.00,19/01/2018
2654383158,true,,"20.04.2018, 00:00","19.05.2018, 23:59",,150.00,05/07/2018
2544926131,true,,"17.04.2018, 00:00","16.05.2018, 23:59",,35.00,16/10/2018
3247543997,true,,"4.02.2018, 00:00","3.03.2018, 23:59",,50.00,06/10/2017
3957040675,true,,"11.04.2018, 00:00","10.05.2018, 23:59",,30.00,05/06/2018
2239662512,true,,"14.03.2018, 00:00","13.04.2018, 23:59",,40.00,12/09/2018
3969329936,true,,"2.11.2017, 00:00","1.12.2017, 23:59",,35.00,02/10/2017
2078013693,true,,"11.07.2018, 00:00","10.08.2018, 23:59",,50.00,16/10/2017
271954327,true,,"20.08.2018, 00:00","19.09.2018, 23:59",,50.00,18/09/2017
442408887,true,,"9.11.2018, 00:00","8.12.2018, 23:59",,50.00,06/09/2017
142728861,true,,"26.03.2018, 00:00","25.04.2018, 23:59",,50.00,12/06/2018
943484201,,"20.11.2018, 21:34","12.07.2018, 23:59","13.08.2018, 00:00",,50.00,13/10/2018
3235857654,,"20.11.2018, 21:34","3.09.2018, 23:59","4.10.2018, 00:00",,40.00,03/10/2018
4205922363,true,,"2.06.2018, 00:00","1.07.2018, 23:59",,35.00,01/07/2017
1091308914,true,,"12.04.2018, 00:00","11.05.2018, 23:59",,40.00,15/10/2017
1673876321,true,,"15.09.2017, 00:00","14.10.2017, 23:59",,200.00,05/08/2017
3448741414,true,,"19.06.2018, 00:00","18.07.2018, 23:59",,40.00,08/06/2018
3392712944,true,,"5.04.2018, 00:00","4.05.2018, 23:59",,150.00,03/11/2017
1242063961,true,,"9.09.2018, 00:00","8.10.2018, 23:59",,50.00,06/09/2017
2763051383,true,,"28.03.2018, 00:00","27.04.2018, 23:59",,120.00,07/03/2018
4285632881,true,,"9.09.2018, 00:00","8.10.2018, 23:59",,35.00,02/01/2018
3745680958,true,,"16.01.2018, 00:00","15.02.2018, 23:59",,50.00,12/11/2017
2658232124,true,,"23.09.2017, 00:00","22.10.2017, 23:59",,0.00,06/08/2017
199165081,true,,"27.01.2018, 00:00","26.02.2018, 23:59",,40.00,17/01/2018
3608318520,true,,"14.12.2018, 00:00","13.01.2019, 23:59",,120.00,20/10/2017
2161776703,true,,"3.09.2018, 00:00","2.10.2018, 23:59",,50.00,01/11/2017
3509369651,true,,"12.04.2018, 00:00","11.05.2018, 23:59",,50.00,08/09/2017
599746493,true,,"9.03.2018, 00:00","8.04.2018, 23:59",,150.00,2/02/2018
4020339354,true,,"2.03.2018, 00:00","1.04.2018, 23:59",,35.00,03/12/2017
2912181502,true,,"5.02.2018, 00:00","4.03.2018, 23:59",,40.00,10/10/2017
3478263485,true,,"20.08.2017, 00:00","19.09.2017, 23:59",,50.00,03/05/2017
3276338408,true,,"10.07.2018, 00:00","9.08.2018, 23:59",,50.00,09/01/2018
3874088135,true,,"20.05.2018, 00:00","19.06.2018, 23:59",,50.00,22/09/2018
1655968872,,"20.11.2018, 21:34","12.05.2018, 23:59","13.06.2018, 00:00",,35.00,10/09/2018
2579766820,true,,"29.12.2017, 00:00","28.01.2018, 23:59",,50.00,25/09/2017
3196339152,true,,"13.04.2018, 00:00","12.05.2018, 23:59",,50.00,13/10/2018
2209418764,,"20.11.2018, 21:34","10.08.2018, 23:59","11.09.2018, 00:00",,30.00,05/06/2018
2421163267,true,,"2.10.2017, 00:00","1.11.2017, 23:59",,50.00,02/07/2017
1122425207,true,,"1.07.2018, 00:00","31.07.2018, 23:59",,35.00,01/10/2017
3642571276,true,,"17.03.2018, 00:00","16.04.2018, 23:59",,50.00,11/01/2018
2412749436,true,,"9.04.2018, 00:00","8.05.2018, 23:59",,50.00,06/09/2017
3521655249,true,,"6.11.2017, 00:00","5.12.2017, 23:59",,0.00,04/11/2017
1752226394,true,,"8.09.2018, 00:00","7.10.2018, 23:59",,35.00,01/09/2017
2560432998,true,,"17.05.2018, 00:00","16.06.2018, 23:59",,50.00,11/01/2018
4010130140,true,,"30.12.2018, 00:00","29.01.2019, 23:59",,50.00,27/09/2017
2271250154,true,,"20.07.2018, 00:00","19.08.2018, 23:59",,120.00,02/05/2018
1807473068,true,,"18.04.2018, 00:00","17.05.2018, 23:59",,140.00,18/09/2018
177518923,true,,"10.02.2018, 00:00","9.03.2018, 23:59",,35.00,14/10/2017
1724843252,true,,"15.02.2018, 00:00","14.03.2018, 23:59",,50.00,06/02/2018
2771938387,true,,"14.03.2018, 00:00","13.04.2018, 23:59",,200.00,11/09/2018
2159607069,,"20.11.2018, 21:34","18.08.2018, 23:59","19.09.2018, 00:00",,40.00,08/06/2018
770434506,true,,"20.04.2018, 00:00","19.05.2018, 23:59",,50.00,22/09/2018
1174759129,,"20.11.2018, 21:34","26.06.2018, 23:59","27.07.2018, 00:00",,50.00,05/04/2018
1391765981,true,,"7.01.2018, 00:00","6.02.2018, 23:59",,50.00,13/10/2107
2460420744,true,,"13.02.2018, 00:00","12.03.2018, 23:59",,70.00,5/02
215807997,true,,"13.05.2018, 00:00","12.06.2018, 23:59",,40.00,11/11/2017
173436140,true,,"2.07.2018, 00:00","1.08.2018, 23:59",,35.00,01/07/2017
2401912955,true,,"5.12.2017, 00:00","4.01.2018, 23:59",,40.00,09/10/2017
892883676,true,,"1.03.2018, 00:00","31.03.2018, 23:59",,35.00,01/10/2017
379338586,true,,"28.02.2018, 00:00","28.03.2018, 23:59",,35.00,24/09/2017
4250416914,true,,"18.04.2018, 00:00","17.05.2018, 23:59",,100.00,17/10/2018
3200771206,true,,"8.01.2018, 00:00","7.02.2018, 23:59",,35.00,01/09/2017
3418800296,true,,"2.04.2018, 00:00","1.05.2018, 23:59",,35.00,03/12/2017
3020993783,true,,"23.05.2018, 00:00","22.06.2018, 23:59",,150.00,03/04/2018
1941025059,,"20.11.2018, 21:34","13.11.2018, 23:59","14.12.2018, 00:00",,35.00,10/09/2017
2149077015,true,,"9.11.2017, 00:00","8.12.2017, 23:59",,50.00,5/09/2017
3015033477,true,,"20.10.2018, 00:00","19.11.2018, 23:59",,50.00,18/09/2017
2097767680,true,,"22.04.2018, 00:00","21.05.2018, 23:59",,50.00,16/09/2017
1146754657,true,,"9.03.2018, 00:00","8.04.2018, 23:59",,50.00,06/11/2017
3462553888,true,,"20.07.2018, 00:00","19.08.2018, 23:59",,50.00,18/09/2017
1538475214,true,,"6.04.2018, 00:00","5.05.2018, 23:59",,50.00,02/11/2018
1001891831,true,,"10.03.2018, 00:00","9.04.2018, 23:59",,50.00,04/09/2018
1552179051,true,,"12.03.2018, 00:00","11.04.2018, 23:59",,50.00,08/09/2017
1847754345,true,,"20.06.2018, 00:00","19.07.2018, 23:59",,50.00,18/09/2017
2089616119,true,,"9.08.2018, 00:00","8.09.2018, 23:59",,50.00,06/09/2017
995064386,true,,"4.05.2018, 00:00","3.06.2018, 23:59",,35.00,02/09/2018
537651005,true,,"8.11.2017, 00:00","7.12.2017, 23:59",,35.00,01/09/2017
2072935199,true,,"14.11.2018, 00:00","13.12.2018, 23:59",,120.00,20/10/2017
3143043048,true,,"11.10.2017, 00:00","10.11.2017, 23:59",,0.00,04/07/2017
2460041235,true,,"21.03.2018, 00:00","20.04.2018, 23:59",,80.00,09/06/2018
1256414068,true,,"1.12.2017, 00:00","31.12.2017, 23:59",,100.00,01/12/2017
10964981,true,,"15.01.2018, 00:00","14.02.2018, 23:59",,200.00,05/08/2017
4254762966,true,,"11.03.2018, 00:00","10.04.2018, 23:59",,50.00,04/06/2018
3762710759,true,,"19.03.2018, 00:00","18.04.2018, 23:59",,40.00,08/06/2018
4198612819,true,,"27.05.2018, 00:00","26.06.2018, 23:59",,150.00,09/08/2018
1265398243,true,,"8.07.2017, 00:00","7.08.2017, 23:59",,35.00,01/05/2017
2913635990,true,,"27.10.2017, 00:00","26.11.2017, 23:59",,35.00,20/09/2017
887979549,true,,"12.03.2018, 00:00","11.04.2018, 23:59",,50.00,17/10/2017
1675741323,true,,"9.02.2018, 00:00","8.03.2018, 23:59",,50.00,06/11/2017
1448536757,true,,"4.03.2018, 00:00","3.04.2018, 23:59",,50.00,01/07/2018
3115270548,true,,"28.11.2017, 00:00","27.12.2017, 23:59",,120.00,15/11/2017
1135474190,true,,"1.08.2018, 00:00","31.08.2018, 23:59",,35.00,01/10/2017
60125204,true,,"30.07.2018, 00:00","29.08.2018, 23:59",,50.00,27/09/2017
3247182539,true,,"1.10.2018, 00:00","31.10.2018, 23:59",,35.00,01/10/2017
1488997152,true,,"2.01.2018, 00:00","1.02.2018, 23:59",,50.00,02/07/2017
4198514711,true,,"8.09.2017, 00:00","7.10.2017, 23:59",,35.00,01/05/2017
1069637064,true,,"6.03.2018, 00:00","5.04.2018, 23:59",,50.00,06/01/2018
2229617516,true,,"4.02.2018, 00:00","3.03.2018, 23:59",,40.00,02/11/2017
1353157262,true,,"1.04.2018, 00:00","30.04.2018, 23:59",,100.00,01/10/2018
326037850,true,,"23.03.2018, 00:00","22.04.2018, 23:59",,150.00,03/04/2018
2689239584,,"20.11.2018, 21:34","19.06.2018, 23:59","20.07.2018, 00:00",,35.00,24/09/2018
1519082022,true,,"12.06.2018, 00:00","11.07.2018, 23:59",,40.00,15/10/2017
1984657327,true,,"6.03.2018, 00:00","5.04.2018, 23:59",,50.00,01/08/2018
2998948607,true,,"9.04.2017, 00:00","8.05.2017, 23:59",,0.00,01/03/2017
1583293320,true,,"27.05.2018, 00:00","26.06.2018, 23:59",,40.00,18/01/2018
3029760978,true,,"30.01.2018, 00:00","27.02.2018, 23:59",,50.00,26/09/2017
3671520823,true,,"1.01.2018, 00:00","31.01.2018, 23:59",,100.00,01/12/2017
1749776296,true,,"8.05.2018, 00:00","7.06.2018, 23:59",,40.00,03/09/2018
1117434274,true,,"5.03.2018, 00:00","4.04.2018, 23:59",,40.00,10/10/2017
182888780,true,,"20.02.2018, 00:00","19.03.2018, 23:59",,50.00,03/05/2017
3209457193,true,,"8.03.2018, 00:00","7.04.2018, 23:59",,35.00,01/09/2017
4270615182,true,,"8.11.2017, 00:00","7.12.2017, 23:59",,35.00,01/05/2017
2322327528,true,,"4.09.2017, 00:00","3.10.2017, 23:59",,150.00,03/07/2017
1947812102,,"20.11.2018, 21:34","5.07.2018, 23:59","6.08.2018, 00:00",,100.00,02/08/2018
4142518640,true,,"9.10.2018, 00:00","8.11.2018, 23:59",,50.00,06/09/2017
2579039482,true,,"9.10.2018, 00:00","8.11.2018, 23:59",,50.00,06/12/2017
893460192,true,,"8.01.2018, 00:00","7.02.2018, 23:59",,35.00,01/05/2017
1222613381,true,,"21.05.2018, 00:00","20.06.2018, 23:59",,50.00,14/11/2017
2781172829,true,,"15.09.2018, 00:00","14.10.2018, 23:59",,50.00,13/09/2017
1990958176,true,,"1.12.2018, 00:00","31.12.2018, 23:59",,35.00,01/10/2017
541618489,true,,"5.09.2018, 00:00","4.10.2018, 23:59",,40.00,09/10/2017
1872895793,true,,"7.11.2017, 00:00","6.12.2017, 23:59",,20.00,05/12/2017
801110738,true,,"19.04.2018, 00:00","18.05.2018, 23:59",,40.00,08/06/2018
1752305799,true,,"29.11.2017, 00:00","28.12.2017, 23:59",,50.00,17/11/2017
2345689614,true,,"27.10.2018, 00:00","26.11.2018, 23:59",,35.00,20/09/2017
4129095834,true,,"27.03.2018, 00:00","26.04.2018, 23:59",,150.00,09/08/2018
439817798,,"20.11.2018, 21:34","19.06.2018, 23:59","20.07.2018, 00:00",,50.00,22/09/2018
486754578,true,,"5.01.2018, 00:00","4.02.2018, 23:59",,40.00,08/10/2017
3708334112,true,,"6.05.2018, 00:00","5.06.2018, 23:59",,50.00,01/02/2018
3210524229,true,,"16.12.2017, 00:00","15.01.2018, 23:59",,50.00,15/09/2017
3689039998,true,,"20.11.2018, 00:00","19.12.2018, 23:59",,50.00,02/04/2018
1878335022,true,,"25.05.2018, 00:00","24.06.2018, 23:59",,150.00,11/06/2018
1397710227,,"20.11.2018, 21:34","13.08.2018, 00:00","13.09.2018, 00:00",,50.00,13/10/2018
1156602419,,"20.11.2018, 21:34","27.07.2018, 00:00","27.08.2018, 00:00",,50.00,05/04/2018
1598769465,,"20.11.2018, 21:34","19.06.2018, 00:00","19.07.2018, 00:00",,35.00,20/09/2018
1473091305,,"20.11.2018, 21:34","20.08.2018, 00:00","20.09.2018, 00:00",,150.00,05/07/2018
2392592160,,"20.11.2018, 21:34","20.10.2018, 00:00","20.11.2018, 00:00",,120.00,02/05/2018
3823663093,,"20.11.2018, 21:34","4.10.2018, 00:00","4.11.2018, 00:00",,40.00,03/10/2018
3432084467,,"20.11.2018, 21:34","12.10.2018, 00:00","12.11.2018, 00:00",,35.00,08/09/2018
2399191851,,"20.11.2018, 21:34","9.11.2018, 00:00","9.12.2018, 00:00",,35.00,02/01/2018
3618162880,,"20.11.2018, 21:34","2.09.2018, 00:00","2.10.2018, 00:00",,40.00,03/10/2017
1181556797,,"20.11.2018, 21:34","20.07.2018, 00:00","20.08.2018, 00:00",,50.00,07/08/2018
1753625838,,"20.11.2018, 21:34","30.06.2018, 00:00","30.07.2018, 00:00",,35.00,24/10/2018
1422664667,,"20.11.2018, 21:34","13.07.2018, 00:00","13.08.2018, 00:00",,150.00,09/09/2018
1794362184,,"20.11.2018, 21:34","27.06.2018, 00:00","27.07.2018, 00:00",,110.00,28/09/2018
2583631072,,"20.11.2018, 21:34","27.07.2018, 00:00","27.08.2018, 00:00",,150.00,09/08/2018
931101099,,"20.11.2018, 21:34","10.06.2018, 00:00","10.07.2018, 00:00",,150.00,09/10/2018
3416440709,,"20.11.2018, 21:34","4.09.2018, 00:00","4.10.2018, 00:00",,40.00,04/10/2108
1471374514,,"20.11.2018, 21:34","20.06.2018, 00:00","20.07.2018, 00:00",,35.00,23/09/2018
2447869492,,"20.11.2018, 21:34","15.07.2018, 00:00","15.08.2018, 00:00",,40.00,15/10/2018
2463332771,,"20.11.2018, 21:34","5.09.2018, 00:00","5.10.2018, 00:00",,40.00,08/10/2017
1801163964,,"20.11.2018, 21:34","6.08.2018, 00:00","6.09.2018, 00:00",,100.00,02/08/2018
2816296733,,"20.11.2018, 21:34","18.06.2018, 00:00","18.07.2018, 00:00",,35.00,17/09/2018
3447311866,,"20.11.2018, 21:34","4.08.2018, 23:59","4.09.2018, 23:59",,150.00,03/11/2017
4260707869,,"20.11.2018, 21:34","19.09.2018, 00:00","19.10.2018, 00:00",,40.00,08/06/2018
713267567,,"20.11.2018, 21:34","29.09.2018, 00:00","29.10.2018, 00:00",,100.00,13/06/2018
3397996278,,"20.11.2018, 21:34","4.08.2018, 00:00","4.09.2018, 00:00",,35.00,02/09/2018
3897864924,,"20.11.2018, 21:34","25.06.2018, 00:00","25.07.2018, 00:00",,35.00,20/10/2018
46084266,,"20.11.2018, 21:34","18.06.2018, 00:00","18.07.2018, 00:00",,140.00,18/09/2018
2406603653,,"20.11.2018, 21:34","18.06.2018, 00:00","18.07.2018, 00:00",,35.00,16/09/2018
3464724607,,"20.11.2018, 21:34","17.06.2018, 00:00","17.07.2018, 00:00",,35.00,16/10/2018
3397639041,,"20.11.2018, 21:34","7.06.2018, 00:00","7.07.2018, 00:00",,120.00,03/11/2018
3909390556,,"20.11.2018, 21:34","26.05.2018, 00:00","26.06.2018, 00:00",,40.00,27/09/2018
2708779266,,"20.11.2018, 21:34","11.06.2018, 00:00","11.07.2018, 00:00",,40.00,11/10/2018
2289897965,,"20.11.2018, 21:34","23.08.2018, 00:00","23.09.2018, 00:00",,50.00,06/07/2018
2025081726,,"20.11.2018, 21:34","27.09.2018, 23:59","27.10.2018, 23:59",,100.00,08/08/2018
3182499039,,"20.11.2018, 21:34","23.06.2018, 00:00","23.07.2018, 00:00",,50.00,18/10/2018
3960476923,,"20.11.2018, 21:34","14.06.2018, 00:00","14.07.2018, 00:00",,40.00,12/09/2018
2585662534,,"20.11.2018, 21:34","3.07.2018, 00:00","3.08.2018, 00:00",,100.00,01/09/2018
53043510,,"20.11.2018, 21:34","16.09.2018, 00:00","16.10.2018, 00:00",,40.00,23/10/2017
2709073063,,"20.11.2018, 21:34","19.08.2018, 00:00","19.09.2018, 00:00",,50.00,04/07/2018
603484886,,"20.11.2018, 21:34","25.06.2018, 00:00","25.07.2018, 00:00",,50.00,26/09/2018
2821124926,,"20.11.2018, 21:34","20.07.2018, 00:00","20.08.2018, 00:00",,35.00,24/09/2018
2875526628,,"20.11.2018, 21:34","27.06.2018, 00:00","27.07.2018, 00:00",,35.00,29/09/2018
4226631564,,"20.11.2018, 21:34","18.07.2018, 00:00","18.08.2018, 00:00",,150.00,06/08/2018
1195714074,,"20.11.2018, 21:34","28.05.2018, 00:00","28.06.2018, 00:00",,35.00,30/09/2018
346964500,,"20.11.2018, 21:34","1.07.2018, 00:00","1.08.2018, 00:00",,80.00,02/10/2018
4274923778,,"20.11.2018, 21:34","8.07.2018, 00:00","8.08.2018, 00:00",,40.00,03/09/2018
848159324,,"20.11.2018, 21:34","6.06.2018, 00:00","6.07.2018, 00:00",,35.00,01/11/2018
74764611,,"20.11.2018, 21:34","11.09.2018, 00:00","11.10.2018, 00:00",,30.00,05/06/2018
1288997875,,"20.11.2018, 21:34","20.07.2018, 00:00","20.08.2018, 00:00",,50.00,22/09/2018
1636139018,,"20.11.2018, 21:34","11.06.2018, 00:00","11.07.2018, 00:00",,40.00,12/10/2018
2894472453,,"20.11.2018, 21:34","22.10.2018, 23:59","22.11.2018, 23:59",,150.00,03/05/2018
3397935483,,"20.11.2018, 21:34","13.06.2018, 00:00","13.07.2018, 00:00",,35.00,10/09/2018
1867182867,,"20.11.2018, 21:34","10.06.2018, 00:00","10.07.2018, 00:00",,80.00,10/10/2018
457401895,,"20.11.2018, 21:34","29.06.2018, 00:00","29.07.2018, 00:00",,100.00,22/10/2018
1632800506,,"20.11.2018, 21:34","9.06.2018, 00:00","9.07.2018, 00:00",,40.00,07/10/2018
3765602504,,"20.11.2018, 21:34","19.08.2018, 00:00","19.09.2018, 00:00",,150.00,03/07/2018
3069810682,,"20.11.2018, 21:34","17.06.2018, 00:00","17.07.2018, 00:00",,40.00,13/09/2018
950048866,,"20.11.2018, 21:34","18.06.2018, 00:00","18.07.2018, 00:00",,100.00,17/10/2018
2572827326,,"20.11.2018, 21:34","17.06.2018, 00:00","17.07.2018, 00:00",,140.00,14/09/2018
4177381915,,"20.11.2018, 21:34","29.08.2018, 00:00","29.09.2018, 00:00",,50.00,09/07/2018
3585695399,,"20.11.2018, 21:34","26.06.2018, 00:00","26.07.2018, 00:00",,40.00,21/10/2018
1691706104,,"20.11.2018, 21:34","5.07.2018, 00:00","5.08.2018, 00:00",,100.00,05/10/2018
268848169,,"20.11.2018, 21:34","10.07.2018, 00:00","10.08.2018, 00:00",,40.00,08/10/2018
2722018568,,"20.11.2018, 21:34","15.06.2018, 00:00","15.07.2018, 00:00",,50.00,14/10/2018
3777165359,,"20.11.2018, 21:34","14.06.2018, 00:00","14.07.2018, 00:00",,200.00,11/09/2018
754749951,,"20.11.2018, 21:34","6.06.2018, 00:00","6.07.2018, 00:00",,50.00,02/11/2018
3151657561,,"20.11.2018, 21:34","20.06.2018, 00:00","20.07.2018, 00:00",,150.00,25/09/2018
3637076190,,"20.11.2018, 21:34","20.10.2018, 00:00","20.11.2018, 00:00",,50.00,03/05/2017
2258745154,,"20.11.2018, 21:34","29.08.2018, 00:00","29.09.2018, 00:00",,50.00,08/07/2018
1520069546,,"20.11.2018, 21:34","30.06.2018, 00:00","30.07.2018, 00:00",,150.00,23/10/2018
3533723978,,"20.11.2018, 21:34","23.10.2018, 00:00","23.11.2018, 00:00",,150.00,03/04/2018
703167374,,"20.11.2018, 21:34","24.07.2018, 00:00","24.08.2018, 00:00",,35.00,19/10/2018
1783075330,,"20.11.2018, 21:34","5.10.2018, 00:00","5.11.2018, 00:00",,40.00,08/10/2017
1885532391,,"20.11.2018, 21:34","15.08.2018, 00:00","15.09.2018, 00:00",,40.00,15/10/2018
3560167951,,"20.11.2018, 21:34","6.07.2018, 00:00","6.08.2018, 00:00",,35.00,01/11/2018
3349094289,,"20.11.2018, 21:34","6.07.2018, 00:00","6.08.2018, 00:00",,50.00,02/11/2018
1153369532,,"20.11.2018, 21:34","30.07.2018, 00:00","30.08.2018, 00:00",,150.00,23/10/2018
3574700418,,"20.11.2018, 21:34","17.07.2018, 00:00","17.08.2018, 00:00",,40.00,13/09/2018
931641614,,"20.11.2018, 21:34","7.07.2018, 00:00","7.08.2018, 00:00",,120.00,03/11/2018
2092194317,,"20.11.2018, 21:34","18.08.2018, 00:00","18.09.2018, 00:00",,150.00,06/08/2018
1376106230,,"20.11.2018, 21:34","10.07.2018, 00:00","10.08.2018, 00:00",,80.00,10/10/2018
4121643150,,"20.11.2018, 21:34","25.07.2018, 00:00","25.08.2018, 00:00",,50.00,26/09/2018
2465535364,,"20.11.2018, 21:34","14.07.2018, 00:00","14.08.2018, 00:00",,200.00,11/09/2018
1308759959,,"20.11.2018, 21:34","17.07.2018, 00:00","17.08.2018, 00:00",,140.00,14/09/2018
1350281306,,"20.11.2018, 21:34","20.08.2018, 00:00","20.09.2018, 00:00",,50.00,07/08/2018
3972070642,,"20.11.2018, 21:34","6.09.2018, 00:00","6.10.2018, 00:00",,100.00,02/08/2018
275693590,,"20.11.2018, 21:34","4.09.2018, 23:59","4.10.2018, 23:59",,150.00,03/11/2017
3459231696,,"20.11.2018, 21:34","11.07.2018, 00:00","11.08.2018, 00:00",,40.00,12/10/2018
3565747559,,"20.11.2018, 21:34","26.06.2018, 00:00","26.07.2018, 00:00",,40.00,27/09/2018
1664588100,,"20.11.2018, 21:34","26.07.2018, 00:00","26.08.2018, 00:00",,40.00,21/10/2018
394054907,,"20.11.2018, 21:34","8.08.2018, 00:00","8.09.2018, 00:00",,40.00,03/09/2018
3455773116,,"20.11.2018, 21:34","1.08.2018, 00:00","1.09.2018, 00:00",,80.00,02/10/2018
1044786801,,"20.11.2018, 21:34","27.10.2018, 23:59","27.11.2018, 23:59",,100.00,08/08/2018
1565885295,,"20.11.2018, 21:34","20.11.2018, 00:00","20.12.2018, 00:00",,120.00,02/05/2018
509691424,,"20.11.2018, 21:34","18.07.2018, 00:00","18.08.2018, 00:00",,100.00,17/10/2018
1288286474,,"20.11.2018, 21:34","27.08.2018, 00:00","27.09.2018, 00:00",,50.00,05/04/2018
2474187573,,"20.11.2018, 21:34","20.09.2018, 00:00","20.10.2018, 00:00",,150.00,05/07/2018
1350904651,,"20.11.2018, 21:34","18.07.2018, 00:00","18.08.2018, 00:00",,35.00,17/09/2018
2446127039,,"20.11.2018, 21:34","18.07.2018, 00:00","18.08.2018, 00:00",,35.00,16/09/2018
1486004337,,"20.11.2018, 21:34","27.08.2018, 00:00","27.09.2018, 00:00",,150.00,09/08/2018
618793244,,"20.11.2018, 21:34","13.08.2018, 00:00","13.09.2018, 00:00",,150.00,09/09/2018
3608267532,,"20.11.2018, 21:34","27.07.2018, 00:00","27.08.2018, 00:00",,110.00,28/09/2018
4064293475,,"20.11.2018, 21:34","12.11.2018, 00:00","12.12.2018, 00:00",,35.00,08/09/2018
4230952376,,"20.11.2018, 21:34","20.08.2018, 00:00","20.09.2018, 00:00",,50.00,22/09/2018
3279673309,,"20.11.2018, 21:34","20.08.2018, 00:00","20.09.2018, 00:00",,35.00,24/09/2018
3971131012,,"20.11.2018, 21:34","10.07.2018, 00:00","10.08.2018, 00:00",,150.00,09/10/2018
1243969356,,"20.11.2018, 21:34","11.07.2018, 00:00","11.08.2018, 00:00",,40.00,11/10/2018
3440997517,,"20.11.2018, 21:34","9.07.2018, 00:00","9.08.2018, 00:00",,40.00,07/10/2018
1713226912,,"20.11.2018, 21:34","20.07.2018, 00:00","20.08.2018, 00:00",,150.00,25/09/2018
1146432955,,"20.11.2018, 21:34","29.09.2018, 00:00","29.10.2018, 00:00",,50.00,08/07/2018
353195230,,"20.11.2018, 21:34","4.11.2018, 00:00","4.12.2018, 00:00",,40.00,03/10/2018
2198947824,,"20.11.2018, 21:34","3.08.2018, 00:00","3.09.2018, 00:00",,100.00,01/09/2018
3051832691,,"20.11.2018, 21:34","17.07.2018, 00:00","17.08.2018, 00:00",,35.00,16/10/2018
3212495607,,"20.11.2018, 21:34","24.08.2018, 00:00","24.09.2018, 00:00",,35.00,19/10/2018
1130632442,,"20.11.2018, 21:34","5.08.2018, 00:00","5.09.2018, 00:00",,100.00,05/10/2018
1674842755,,"20.11.2018, 21:34","19.09.2018, 00:00","19.10.2018, 00:00",,50.00,04/07/2018
1086602812,,"20.11.2018, 21:34","4.09.2018, 00:00","4.10.2018, 00:00",,35.00,02/09/2018
3822866717,,"20.11.2018, 21:34","19.09.2018, 00:00","19.10.2018, 00:00",,150.00,03/07/2018
1922674255,,"20.11.2018, 21:34","14.07.2018, 00:00","14.08.2018, 00:00",,40.00,12/09/2018
4215465261,,"20.11.2018, 21:34","10.08.2018, 00:00","10.09.2018, 00:00",,40.00,08/10/2018
2152938032,,"20.11.2018, 21:34","30.07.2018, 00:00","30.08.2018, 00:00",,35.00,24/10/2018
2092865294,,"20.11.2018, 21:34","20.11.2018, 00:00","20.12.2018, 00:00",,50.00,03/05/2017
884842179,,"20.11.2018, 21:34","27.07.2018, 00:00","27.08.2018, 00:00",,35.00,29/09/2018
1674194043,,"20.11.2018, 21:34","11.10.2018, 00:00","11.11.2018, 00:00",,30.00,05/06/2018
1845336004,,"20.11.2018, 21:34","20.07.2018, 00:00","20.08.2018, 00:00",,35.00,23/09/2018
994141813,,"20.11.2018, 21:34","2.10.2018, 00:00","2.11.2018, 00:00",,40.00,03/10/2017
1810089903,,"20.11.2018, 21:34","13.07.2018, 00:00","13.08.2018, 00:00",,35.00,10/09/2018
3499349161,,"20.11.2018, 21:34","23.09.2018, 00:00","23.10.2018, 00:00",,50.00,06/07/2018
337466,,"20.11.2018, 21:34","19.07.2018, 00:00","19.08.2018, 00:00",,35.00,20/09/2018
245707045,,"20.11.2018, 21:34","29.09.2018, 00:00","29.10.2018, 00:00",,50.00,09/07/2018
4051499487,,"20.11.2018, 21:34","28.06.2018, 00:00","28.07.2018, 00:00",,35.00,30/09/2018
1063768922,,"20.11.2018, 21:34","4.10.2018, 00:00","4.11.2018, 00:00",,40.00,04/10/2108
2388749867,,"20.11.2018, 21:34","29.07.2018, 00:00","29.08.2018, 00:00",,100.00,22/10/2018
3876823924,,"20.11.2018, 21:34","15.07.2018, 00:00","15.08.2018, 00:00",,50.00,14/10/2018
725023781,,"20.11.2018, 21:34","16.10.2018, 00:00","16.11.2018, 00:00",,40.00,23/10/2017
1991828093,,"20.11.2018, 21:34","18.07.2018, 00:00","18.08.2018, 00:00",,140.00,18/09/2018
1265810569,,"20.11.2018, 21:34","13.09.2018, 00:00","13.10.2018, 00:00",,50.00,13/10/2018
3968813788,,"20.11.2018, 21:34","19.10.2018, 00:00","19.11.2018, 00:00",,40.00,08/06/2018
2295298132,,"20.11.2018, 21:34","23.07.2018, 00:00","23.08.2018, 00:00",,50.00,18/10/2018
1096308502,,"20.11.2018, 21:34","25.07.2018, 00:00","25.08.2018, 00:00",,35.00,20/10/2018
88264629,,"20.11.2018, 21:34","29.10.2018, 00:00","29.11.2018, 00:00",,100.00,13/06/2018
1471139825,,"20.11.2018, 21:34","25.08.2018, 00:00","25.09.2018, 00:00",,35.00,20/10/2018
550720298,,"20.11.2018, 21:34","30.08.2018, 00:00","30.09.2018, 00:00",,150.00,23/10/2018
2481206551,,"20.11.2018, 21:34","23.10.2018, 00:00","23.11.2018, 00:00",,50.00,06/07/2018
3333125244,,"20.11.2018, 21:34","27.09.2018, 00:00","27.10.2018, 00:00",,50.00,05/04/2018
4164821773,,"20.11.2018, 21:34","14.08.2018, 00:00","14.09.2018, 00:00",,40.00,12/09/2018
1100790508,,"20.11.2018, 21:34","15.09.2018, 00:00","15.10.2018, 00:00",,40.00,15/10/2018
2395603187,,"20.11.2018, 21:34","15.08.2018, 00:00","15.09.2018, 00:00",,50.00,14/10/2018
2732453894,,"20.11.2018, 21:34","6.08.2018, 00:00","6.09.2018, 00:00",,35.00,01/11/2018
3192494296,,"20.11.2018, 21:34","27.09.2018, 00:00","27.10.2018, 00:00",,150.00,09/08/2018
1388215915,,"20.11.2018, 21:34","1.09.2018, 00:00","1.10.2018, 00:00",,80.00,02/10/2018
879172931,,"20.11.2018, 21:34","14.08.2018, 00:00","14.09.2018, 00:00",,200.00,11/09/2018
1648802444,,"20.11.2018, 21:34","11.08.2018, 00:00","11.09.2018, 00:00",,40.00,11/10/2018
2493730419,,"20.11.2018, 21:34","19.10.2018, 00:00","19.11.2018, 00:00",,150.00,03/07/2018
2009516743,,"20.11.2018, 21:34","10.08.2018, 00:00","10.09.2018, 00:00",,150.00,09/10/2018
1616643401,,"20.11.2018, 21:34","25.08.2018, 00:00","25.09.2018, 00:00",,50.00,26/09/2018
2414745290,,"20.11.2018, 21:34","20.09.2018, 00:00","20.10.2018, 00:00",,50.00,07/08/2018
21566070,,"20.11.2018, 21:34","8.09.2018, 00:00","8.10.2018, 00:00",,40.00,03/09/2018
1079359521,,"20.11.2018, 21:34","19.10.2018, 00:00","19.11.2018, 00:00",,50.00,04/07/2018
2772336547,,"20.11.2018, 21:34","26.08.2018, 00:00","26.09.2018, 00:00",,40.00,21/10/2018
1980938106,,"20.11.2018, 21:34","26.07.2018, 00:00","26.08.2018, 00:00",,40.00,27/09/2018
2415018732,,"20.11.2018, 21:34","18.09.2018, 00:00","18.10.2018, 00:00",,150.00,06/08/2018
3020386638,,"20.11.2018, 21:34","6.10.2018, 00:00","6.11.2018, 00:00",,100.00,02/08/2018
2439561273,,"20.11.2018, 21:34","4.10.2018, 00:00","4.11.2018, 00:00",,35.00,02/09/2018
2441609116,,"20.11.2018, 21:34","18.08.2018, 00:00","18.09.2018, 00:00",,35.00,17/09/2018
65603158,,"20.11.2018, 21:34","18.08.2018, 00:00","18.09.2018, 00:00",,140.00,18/09/2018
3817626065,,"20.11.2018, 21:34","29.10.2018, 00:00","29.11.2018, 00:00",,50.00,09/07/2018
3220552095,,"20.11.2018, 21:34","4.11.2018, 00:00","4.12.2018, 00:00",,40.00,04/10/2108
3629504864,,"20.11.2018, 21:34","13.08.2018, 00:00","13.09.2018, 00:00",,35.00,10/09/2018
42649656,,"20.11.2018, 21:34","19.11.2018, 00:00","19.12.2018, 00:00",,40.00,08/06/2018
2301420513,,"20.11.2018, 21:34","4.10.2018, 23:59","4.11.2018, 23:59",,150.00,03/11/2017
2769352845,,"20.11.2018, 21:34","20.09.2018, 00:00","20.10.2018, 00:00",,35.00,24/09/2018
3975638958,,"20.11.2018, 21:34","13.09.2018, 00:00","13.10.2018, 00:00",,150.00,09/09/2018
1948207822,,"20.11.2018, 21:34","20.09.2018, 00:00","20.10.2018, 00:00",,50.00,22/09/2018
2689384051,,"20.11.2018, 21:34","10.08.2018, 00:00","10.09.2018, 00:00",,80.00,10/10/2018
2307216260,,"20.11.2018, 21:34","27.08.2018, 00:00","27.09.2018, 00:00",,110.00,28/09/2018
4024377962,,"20.11.2018, 21:34","10.09.2018, 00:00","10.10.2018, 00:00",,40.00,08/10/2018
383813540,,"20.11.2018, 21:34","29.10.2018, 00:00","29.11.2018, 00:00",,50.00,08/07/2018
39594277,,"20.11.2018, 21:34","18.08.2018, 00:00","18.09.2018, 00:00",,100.00,17/10/2018
3246438442,,"20.11.2018, 21:34","13.10.2018, 00:00","13.11.2018, 00:00",,50.00,13/10/2018
731473351,,"20.11.2018, 21:34","3.09.2018, 00:00","3.10.2018, 00:00",,100.00,01/09/2018
774131618,,"20.11.2018, 21:34","7.08.2018, 00:00","7.09.2018, 00:00",,120.00,03/11/2018
3203688948,,"20.11.2018, 21:34","30.08.2018, 00:00","30.09.2018, 00:00",,35.00,24/10/2018
2431840641,,"20.11.2018, 21:34","5.11.2018, 00:00","5.12.2018, 00:00",,40.00,08/10/2017
4033772962,,"20.11.2018, 21:34","29.08.2018, 00:00","29.09.2018, 00:00",,100.00,22/10/2018
4211557812,,"20.11.2018, 21:34","20.10.2018, 00:00","20.11.2018, 00:00",,150.00,05/07/2018
2689142279,,"20.11.2018, 21:34","27.08.2018, 00:00","27.09.2018, 00:00",,35.00,29/09/2018
1485565879,,"20.11.2018, 21:34","17.08.2018, 00:00","17.09.2018, 00:00",,35.00,16/10/2018
3453161127,,"20.11.2018, 21:34","20.08.2018, 00:00","20.09.2018, 00:00",,35.00,23/09/2018
1417589936,,"20.11.2018, 21:34","6.08.2018, 00:00","6.09.2018, 00:00",,50.00,02/11/2018
1242988347,,"20.11.2018, 21:34","5.09.2018, 00:00","5.10.2018, 00:00",,100.00,05/10/2018
2173529693,,"20.11.2018, 21:34","23.08.2018, 00:00","23.09.2018, 00:00",,50.00,18/10/2018
2931760226,,"20.11.2018, 21:34","11.08.2018, 00:00","11.09.2018, 00:00",,40.00,12/10/2018
2143458690,,"20.11.2018, 21:34","20.08.2018, 00:00","20.09.2018, 00:00",,150.00,25/09/2018
271546377,,"20.11.2018, 21:34","2.11.2018, 00:00","2.12.2018, 00:00",,40.00,03/10/2017
233714239,,"20.11.2018, 21:34","28.07.2018, 00:00","28.08.2018, 00:00",,35.00,30/09/2018
701009653,,"20.11.2018, 21:34","17.08.2018, 00:00","17.09.2018, 00:00",,40.00,13/09/2018
2019415427,,"20.11.2018, 21:34","9.08.2018, 00:00","9.09.2018, 00:00",,40.00,07/10/2018
3761179399,,"20.11.2018, 21:34","16.11.2018, 00:00","16.12.2018, 00:00",,40.00,23/10/2017
2483775601,,"20.11.2018, 21:34","18.08.2018, 00:00","18.09.2018, 00:00",,35.00,16/09/2018
3269914798,,"20.11.2018, 21:34","11.11.2018, 00:00","11.12.2018, 00:00",,30.00,05/06/2018
54431467,,"20.11.2018, 21:34","17.08.2018, 00:00","17.09.2018, 00:00",,140.00,14/09/2018
1141443764,,"20.11.2018, 21:34","24.09.2018, 00:00","24.10.2018, 00:00",,35.00,19/10/2018
1839995667,,"20.11.2018, 21:34","19.08.2018, 00:00","19.09.2018, 00:00",,35.00,20/09/2018
658931033,,"20.11.2018, 21:34","9.09.2018, 00:00","9.10.2018, 00:00",,40.00,07/10/2018
2928788768,,"20.11.2018, 21:34","20.10.2018, 00:00","20.11.2018, 00:00",,50.00,22/09/2018
3639940096,,"20.11.2018, 21:34","6.09.2018, 00:00","6.10.2018, 00:00",,35.00,01/11/2018
3605748517,,"20.11.2018, 21:34","25.09.2018, 00:00","25.10.2018, 00:00",,35.00,20/10/2018
2466355111,,"20.11.2018, 21:34","30.09.2018, 00:00","30.10.2018, 00:00",,150.00,23/10/2018
489706598,,"20.11.2018, 21:34","13.09.2018, 00:00","13.10.2018, 00:00",,35.00,10/09/2018
210820136,,"20.11.2018, 21:34","4.11.2018, 23:59","4.12.2018, 23:59",,150.00,03/11/2017
2575870100,,"20.11.2018, 21:34","27.10.2018, 00:00","27.11.2018, 00:00",,150.00,09/08/2018
2970619125,,"20.11.2018, 21:34","20.11.2018, 00:00","20.12.2018, 00:00",,150.00,05/07/2018
1664651561,,"20.11.2018, 21:34","18.09.2018, 00:00","18.10.2018, 00:00",,35.00,16/09/2018
810659238,,"20.11.2018, 21:34","6.11.2018, 00:00","6.12.2018, 00:00",,100.00,02/08/2018
2481269440,,"20.11.2018, 21:34","27.10.2018, 00:00","27.11.2018, 00:00",,50.00,05/04/2018
2155919531,,"20.11.2018, 21:34","10.09.2018, 00:00","10.10.2018, 00:00",,150.00,09/10/2018
1965879586,,"20.11.2018, 21:34","20.09.2018, 00:00","20.10.2018, 00:00",,35.00,23/09/2018
3658065832,,"20.11.2018, 21:34","27.09.2018, 00:00","27.10.2018, 00:00",,35.00,29/09/2018
2615110878,,"20.11.2018, 21:34","23.09.2018, 00:00","23.10.2018, 00:00",,50.00,18/10/2018
2848209389,,"20.11.2018, 21:34","19.11.2018, 00:00","19.12.2018, 00:00",,150.00,03/07/2018
794543709,,"20.11.2018, 21:34","24.10.2018, 00:00","24.11.2018, 00:00",,35.00,19/10/2018
3728140651,,"20.11.2018, 21:34","7.09.2018, 00:00","7.10.2018, 00:00",,120.00,03/11/2018
3277499770,,"20.11.2018, 21:34","20.10.2018, 00:00","20.11.2018, 00:00",,35.00,24/09/2018
1504389428,,"20.11.2018, 21:34","8.10.2018, 00:00","8.11.2018, 00:00",,40.00,03/09/2018
3451338493,,"20.11.2018, 21:34","13.11.2018, 00:00","13.12.2018, 00:00",,50.00,13/10/2018
1578357711,,"20.11.2018, 21:34","11.09.2018, 00:00","11.10.2018, 00:00",,40.00,11/10/2018
1840699405,,"20.11.2018, 21:34","20.10.2018, 00:00","20.11.2018, 00:00",,50.00,07/08/2018
951730975,,"20.11.2018, 21:34","6.09.2018, 00:00","6.10.2018, 00:00",,50.00,02/11/2018
494584036,,"20.11.2018, 21:34","14.09.2018, 00:00","14.10.2018, 00:00",,40.00,12/09/2018
168049135,,"20.11.2018, 21:34","10.10.2018, 00:00","10.11.2018, 00:00",,40.00,08/10/2018
3954142021,,"20.11.2018, 21:34","18.09.2018, 00:00","18.10.2018, 00:00",,140.00,18/09/2018
2966398839,,"20.11.2018, 21:34","30.09.2018, 00:00","30.10.2018, 00:00",,35.00,24/10/2018
2443148649,,"20.11.2018, 21:34","3.10.2018, 00:00","3.11.2018, 00:00",,100.00,01/09/2018
658052273,,"20.11.2018, 21:34","4.11.2018, 00:00","4.12.2018, 00:00",,35.00,02/09/2018
1160623804,,"20.11.2018, 21:34","11.09.2018, 00:00","11.10.2018, 00:00",,40.00,12/10/2018
436332973,,"20.11.2018, 21:34","17.09.2018, 00:00","17.10.2018, 00:00",,35.00,16/10/2018
724452898,,"20.11.2018, 21:34","17.09.2018, 00:00","17.10.2018, 00:00",,140.00,14/09/2018
1277661714,,"20.11.2018, 21:34","26.08.2018, 00:00","26.09.2018, 00:00",,40.00,27/09/2018
3866896284,,"20.11.2018, 21:34","26.09.2018, 00:00","26.10.2018, 00:00",,40.00,21/10/2018
2281589187,,"20.11.2018, 21:34","1.10.2018, 00:00","1.11.2018, 00:00",,80.00,02/10/2018
3099201050,,"20.11.2018, 21:34","19.09.2018, 00:00","19.10.2018, 00:00",,35.00,20/09/2018
4033607327,,"20.11.2018, 21:34","25.09.2018, 00:00","25.10.2018, 00:00",,50.00,26/09/2018
279495157,,"20.11.2018, 21:34","15.09.2018, 00:00","15.10.2018, 00:00",,50.00,14/10/2018
808401171,,"20.11.2018, 21:34","18.09.2018, 00:00","18.10.2018, 00:00",,100.00,17/10/2018
407420851,,"20.11.2018, 21:34","20.09.2018, 00:00","20.10.2018, 00:00",,150.00,25/09/2018
937634070,,"20.11.2018, 21:34","17.09.2018, 00:00","17.10.2018, 00:00",,40.00,13/09/2018
1961916414,,"20.11.2018, 21:34","18.09.2018, 00:00","18.10.2018, 00:00",,35.00,17/09/2018
4127468963,,"20.11.2018, 21:34","28.08.2018, 00:00","28.09.2018, 00:00",,35.00,30/09/2018
1957003375,,"20.11.2018, 21:34","10.09.2018, 00:00","10.10.2018, 00:00",,80.00,10/10/2018
1936808243,,"20.11.2018, 21:34","27.09.2018, 00:00","27.10.2018, 00:00",,110.00,28/09/2018
2335998713,,"20.11.2018, 21:34","18.10.2018, 00:00","18.11.2018, 00:00",,150.00,06/08/2018
2444375896,,"20.11.2018, 21:34","13.10.2018, 00:00","13.11.2018, 00:00",,150.00,09/09/2018
1324994714,,"20.11.2018, 21:34","19.11.2018, 00:00","19.12.2018, 00:00",,50.00,04/07/2018
1582591100,,"20.11.2018, 21:34","29.09.2018, 00:00","29.10.2018, 00:00",,100.00,22/10/2018
2677428856,,"20.11.2018, 21:34","14.09.2018, 00:00","14.10.2018, 00:00",,200.00,11/09/2018
1028216645,,"20.11.2018, 21:34","5.10.2018, 00:00","5.11.2018, 00:00",,100.00,05/10/2018
66895412,,"20.11.2018, 21:34","15.10.2018, 00:00","15.11.2018, 00:00",,40.00,15/10/2018
2215097163,,"20.11.2018, 21:34","18.10.2018, 00:00","18.11.2018, 00:00",,100.00,17/10/2018
3462508913,,"20.11.2018, 21:34","17.10.2018, 00:00","17.11.2018, 00:00",,40.00,13/09/2018
26915395,,"20.11.2018, 21:34","10.10.2018, 00:00","10.11.2018, 00:00",,80.00,10/10/2018
1902687338,,"20.11.2018, 21:34","14.10.2018, 00:00","14.11.2018, 00:00",,40.00,12/09/2018
4009913459,,"20.11.2018, 21:34","15.11.2018, 00:00","15.12.2018, 00:00",,40.00,15/10/2018
3718103016,,"20.11.2018, 21:34","11.10.2018, 00:00","11.11.2018, 00:00",,40.00,12/10/2018
2670543654,,"20.11.2018, 21:34","28.09.2018, 00:00","28.10.2018, 00:00",,35.00,30/09/2018
803535026,,"20.11.2018, 21:34","20.10.2018, 00:00","20.11.2018, 00:00",,150.00,25/09/2018
1155839658,,"20.11.2018, 21:34","6.10.2018, 00:00","6.11.2018, 00:00",,35.00,01/11/2018
3448997108,,"20.11.2018, 21:34","13.10.2018, 00:00","13.11.2018, 00:00",,35.00,10/09/2018
3447404654,,"20.11.2018, 21:34","29.10.2018, 00:00","29.11.2018, 00:00",,100.00,22/10/2018
1151984961,,"20.11.2018, 21:34","20.11.2018, 00:00","20.12.2018, 00:00",,50.00,07/08/2018
2006845926,,"20.11.2018, 21:34","23.10.2018, 00:00","23.11.2018, 00:00",,50.00,18/10/2018
712775724,,"20.11.2018, 21:34","25.10.2018, 00:00","25.11.2018, 00:00",,35.00,20/10/2018
2548845522,,"20.11.2018, 21:34","1.11.2018, 00:00","1.12.2018, 00:00",,80.00,02/10/2018
2376168920,,"20.11.2018, 21:34","18.10.2018, 00:00","18.11.2018, 00:00",,140.00,18/09/2018
366928421,,"20.11.2018, 21:34","10.11.2018, 00:00","10.12.2018, 00:00",,40.00,08/10/2018
1252940447,,"20.11.2018, 21:34","5.11.2018, 00:00","5.12.2018, 00:00",,100.00,05/10/2018
3209332064,,"20.11.2018, 21:34","14.10.2018, 00:00","14.11.2018, 00:00",,200.00,11/09/2018
388670979,,"20.11.2018, 21:34","26.10.2018, 00:00","26.11.2018, 00:00",,40.00,21/10/2018
835102431,,"20.11.2018, 21:34","18.10.2018, 00:00","18.11.2018, 00:00",,35.00,17/09/2018
2604942549,,"20.11.2018, 21:34","10.10.2018, 00:00","10.11.2018, 00:00",,150.00,09/10/2018
3134732351,,"20.11.2018, 21:34","25.10.2018, 00:00","25.11.2018, 00:00",,50.00,26/09/2018
1646524348,,"20.11.2018, 21:34","20.11.2018, 00:00","20.12.2018, 00:00",,35.00,24/09/2018
741468390,,"20.11.2018, 21:34","18.11.2018, 00:00","18.12.2018, 00:00",,150.00,06/08/2018
2465295387,,"20.11.2018, 21:34","3.11.2018, 00:00","3.12.2018, 00:00",,100.00,01/09/2018
1479712270,,"20.11.2018, 21:34","17.10.2018, 00:00","17.11.2018, 00:00",,35.00,16/10/2018
4081131016,,"20.11.2018, 21:34","19.10.2018, 00:00","19.11.2018, 00:00",,35.00,20/09/2018
2955248921,,"20.11.2018, 21:34","17.10.2018, 00:00","17.11.2018, 00:00",,140.00,14/09/2018
26814271,,"20.11.2018, 21:34","15.10.2018, 00:00","15.11.2018, 00:00",,50.00,14/10/2018
704746564,,"20.11.2018, 21:34","8.11.2018, 00:00","8.12.2018, 00:00",,40.00,03/09/2018
243702867,,"20.11.2018, 21:34","27.10.2018, 00:00","27.11.2018, 00:00",,110.00,28/09/2018
1674621911,,"20.11.2018, 21:34","20.11.2018, 00:00","20.12.2018, 00:00",,50.00,22/09/2018
2036817599,,"20.11.2018, 21:34","20.10.2018, 00:00","20.11.2018, 00:00",,35.00,23/09/2018
1287096188,,"20.11.2018, 21:34","11.10.2018, 00:00","11.11.2018, 00:00",,40.00,11/10/2018
3985530368,,"20.11.2018, 21:34","18.10.2018, 00:00","18.11.2018, 00:00",,35.00,16/09/2018
348171398,,"20.11.2018, 21:34","13.11.2018, 00:00","13.12.2018, 00:00",,150.00,09/09/2018
894133397,,"20.11.2018, 21:34","30.10.2018, 00:00","30.11.2018, 00:00",,150.00,23/10/2018
3560744520,,"20.11.2018, 21:34","27.10.2018, 00:00","27.11.2018, 00:00",,35.00,29/09/2018
3686313685,,"20.11.2018, 21:34","7.10.2018, 00:00","7.11.2018, 00:00",,120.00,03/11/2018
2823637425,,"20.11.2018, 21:34","30.10.2018, 00:00","30.11.2018, 00:00",,35.00,24/10/2018
2354590202,,"20.11.2018, 21:34","26.09.2018, 00:00","26.10.2018, 00:00",,40.00,27/09/2018
1464779124,,"20.11.2018, 21:34","9.10.2018, 00:00","9.11.2018, 00:00",,40.00,07/10/2018
3390311808,,"20.11.2018, 21:34","6.10.2018, 00:00","6.11.2018, 00:00",,50.00,02/11/2018
3201735651,,"20.11.2018, 21:34","17.11.2018, 00:00","17.12.2018, 00:00",,35.00,16/10/2018
3593907886,,"20.11.2018, 21:34","15.11.2018, 00:00","15.12.2018, 00:00",,50.00,14/10/2018
1738286185,,"20.11.2018, 21:34","28.10.2018, 00:00","28.11.2018, 00:00",,35.00,30/09/2018
1925358715,,"20.11.2018, 21:34","20.11.2018, 00:00","20.12.2018, 00:00",,150.00,25/09/2018
2372119350,,"20.11.2018, 21:34","6.11.2018, 00:00","6.12.2018, 00:00",,50.00,02/11/2018
1483695537,,"20.11.2018, 21:34","18.11.2018, 00:00","18.12.2018, 00:00",,35.00,17/09/2018
3012556721,,"20.11.2018, 21:34","7.11.2018, 00:00","7.12.2018, 00:00",,120.00,03/11/2018
2525587953,,"20.11.2018, 21:34","10.11.2018, 00:00","10.12.2018, 00:00",,80.00,10/10/2018
3882643638,,"20.11.2018, 21:34","11.11.2018, 00:00","11.12.2018, 00:00",,40.00,12/10/2018
409451379,,"20.11.2018, 21:34","17.11.2018, 00:00","17.12.2018, 00:00",,140.00,14/09/2018
982965409,,"20.11.2018, 21:34","18.11.2018, 00:00","18.12.2018, 00:00",,35.00,16/09/2018
3017352877,,"20.11.2018, 21:34","17.11.2018, 00:00","17.12.2018, 00:00",,40.00,13/09/2018
2102240420,,"20.11.2018, 21:34","18.11.2018, 00:00","18.12.2018, 00:00",,140.00,18/09/2018
1003286180,,"20.11.2018, 21:34","14.11.2018, 00:00","14.12.2018, 00:00",,40.00,12/09/2018
3262551824,,"20.11.2018, 21:34","26.10.2018, 00:00","26.11.2018, 00:00",,40.00,27/09/2018
2851914645,,"20.11.2018, 21:34","6.11.2018, 00:00","6.12.2018, 00:00",,35.00,01/11/2018
418194195,,"20.11.2018, 21:34","10.11.2018, 00:00","10.12.2018, 00:00",,150.00,09/10/2018
3792601306,,"20.11.2018, 21:34","20.11.2018, 00:00","20.12.2018, 00:00",,35.00,23/09/2018
3978765780,,"20.11.2018, 21:34","14.11.2018, 00:00","14.12.2018, 00:00",,200.00,11/09/2018
3520210868,,"20.11.2018, 21:34","11.11.2018, 00:00","11.12.2018, 00:00",,40.00,11/10/2018
2202213847,,"20.11.2018, 21:34","18.11.2018, 00:00","18.12.2018, 00:00",,100.00,17/10/2018
367752127,,"20.11.2018, 21:34","13.11.2018, 00:00","13.12.2018, 00:00",,35.00,10/09/2018
3224935660,,"20.11.2018, 21:34","9.11.2018, 00:00","9.12.2018, 00:00",,40.00,07/10/2018
3316517850,,"20.11.2018, 21:34","19.11.2018, 00:00","19.12.2018, 00:00",,35.00,20/09/2018
"""
	
}
