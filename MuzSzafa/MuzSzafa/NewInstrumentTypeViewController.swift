
//  NewInstrumentViewController.swift
//  MuzycznaSzafa
//
//  Created by Alagris on 03/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import UIKit
import CoreData
import MuzSzafaFramework
import MuzSzafaShared
class NewInstrumentTypeViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
		navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    
    @IBOutlet weak var newInstrumentTypeName: UITextField!
	
    @IBAction func validateId(_ sender: UITextField) {
        let isIdValid = validateName(sender.text) && !InstrumentType.ent.exists(sender.text!)
        if isIdValid{
            sender.layer.borderColor = UIColor.black.cgColor
        }else{
            sender.layer.borderColor = UIColor.red.cgColor
        }
        navigationItem.rightBarButtonItem?.isEnabled = isIdValid
    }
	
    @IBAction func tapped(_ sender: Any) {
        newInstrumentTypeName.resignFirstResponder()
    }
	
    @IBAction func addNewInstrument(_ sender: Any) {
        if let id = newInstrumentTypeName.text{
            _ = InstrumentType.ent.ensureExists(id)
			navigationController?.popViewController(animated: true)
        }
    }
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
