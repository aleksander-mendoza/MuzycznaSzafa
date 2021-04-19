//
//  IncomeViewController.swift
//  MuzSzafaMac
//
//  Created by Alagris on 03/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
import MuzSzafaMacFramework
import MuzSzafaShared
class IncomeViewController: NSViewController{
    
    @IBOutlet weak var controls: CoreDataTable!
    @IBOutlet weak var payments: EntitiesFilteredTableView!
    private var pair:TablePair!
    
    override func keyDown(with event: NSEvent) {
        if event.keyCode == 53{
            goBack(nil)
        }
    }
	private let income = ManualPropertyEntry(localizedName: "income",type: .display, val: "0", userHelp: CoreDataManualHelp("Help:Manual:income") )
	private let realIncome = ManualPropertyEntry(localizedName: "real_income", type: .display, val: "0", userHelp: CoreDataManualHelp("Help:Manual:real_income"))
    private let date = ManualPropertyEntry(localizedName: "date", type: .date, val: Date())
    private let mode = ManualPropertyEntry(name: "summary_mode", type: .list,opts:[.size:8])
    private let done = ManualPropertyEntry(localizedName: "Done", type: .button)
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    private func setup(){
        func onDone(_:Any?,_:PropertyTableEntryEvent){
            dismiss(nil)
        }
        done.onChangeImpl = onDone
        
        
        date.onChangeImpl = setIncome
        mode.onChangeImpl = setIncome
    }
    
    private func setIncome(_:Any?,_ event:PropertyTableEntryEvent){
        guard event is PropertyTableEntryValChangeEvent else {return}
        let m = mode.value as! Int? ?? 0
        let d = date.value as! Date? ?? Date()
		let (sum,realSum) = updatePaymentSummary(mode: m, date: d, table: payments)
        payments.reloadData()
        income.set(value: moneyToString(sum))
		realIncome.set(value: moneyToString(realSum))
    }
    
    @IBAction func goBack(_ sender: Any?) {
        if controls.ent == nil{
            dismiss(nil)
        }else{
            setControls()
        }
    }
    
    private func setControls(){
        controls.setLocalizedTitle(title: "Summary")
        controls.reloadData(entries: [date,mode,income,realIncome,done])
        setIncome(nil,PropertyTableEntryValChangeEvent.singleton)
    }
    
    override func viewDidLoad() {
        pair = TablePair(prop: controls,
                         list: payments,
						 ent: "Payment",
                         cntx: CoreContext.shared
                         )
        setControls()
    }
}
