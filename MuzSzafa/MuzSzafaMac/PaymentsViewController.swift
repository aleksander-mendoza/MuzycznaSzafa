//
//  PaymentsViewController.swift
//  MuzSzafaMac
//
//  Created by Alagris on 01/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
import MuzSzafaMacFramework
import MuzSzafaShared
class PaymentsViewController: NSViewController {

    var onDismissCallback:(()->Void)?
    override func keyDown(with event: NSEvent) {
        if event.keyCode == 53{
            dismiss(nil)
        }
    }
    
    @IBAction func done(_ sender: Any) {
        onDismissCallback?()
        dismiss(self)
    }
    @IBAction func removePayment(_ sender: Any) {
        if let mo = list.selectedObj{
            let selectedRow = list.selectedRow
            CoreContext.shared.get().delete(mo)
            list.reloadData()
            CoreContext.shared.save()
            list.selectRowIndexes([min(selectedRow,max(0,list.numberOfRows-1))], byExtendingSelection: false)
        }
    }
    @IBAction func addPayment(_ sender: Any) {
        let selectedRow = list.selectedRow
        _ = Payment.createNew(deal)
        list.reloadData()
        CoreContext.shared.save()
        list.selectRowIndexes([selectedRow], byExtendingSelection: false)
    }
    @IBOutlet weak var list: EntitiesTableView!{
        didSet{
            list.sort = [NSSortDescriptor(key: "term_end", ascending: false)]
        }
    }
    @IBOutlet weak var properties: CoreDataTable!
    private var pair:TablePair!
    /**this is set by segue*/
    var deal:Deal!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        list.pred = Payment.safePred(Payment.deal.equals(deal))
        pair = TablePair(prop: properties, list: list, ent: "Payment", cntx: CoreContext.shared)!
    }
    
}
