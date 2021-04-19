//
//  OverviewViewController.swift
//  MuzSzafa
//
//  Created by Alagris on 17/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import UIKit
import MuzSzafaFramework
import MuzSzafaShared
import CoreData
class PaymentsViewController: UIViewController {
	

	@IBOutlet weak var payments: EntitiesTableView!{
		didSet{
			payments.onChangeImpl = { [weak self] _ in
				self!.performSegue(withIdentifier: "showPayment", sender: self!.payments.getSelected())
			}
			payments.allowDeleting = true
		}
	}
	
	var deal:Deal?{
		didSet{
			
		}
	}
	
	@IBAction func newPayment(_ sender: Any) {
		if let deal = deal{
			let payment = Payment.createNew(deal)
			performSegue(withIdentifier: "showPayment", sender: payment)
		}
	}
	func reloadData() {
		payments?.reloadData(mo: deal, relat: Deal.payment, cache: CoreContext.shared.cache)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		reloadData()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier!{
		case "showPayment":
			let dest = segue.destination as! EntityViewController
			assert(sender is Payment)
			dest.mo = (sender as! NSManagedObject)
        default:
            break
        }
    }

}
