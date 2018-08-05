//
//  AddPayDateViewController.swift
//  AlloSpend
//
//  Created by Bryan Butz on 8/5/18.
//  Copyright © 2018 Bryan Butz. All rights reserved.
//

import UIKit
import RealmSwift

class AddPayDateViewController: UIViewController {
    
    @IBOutlet weak var payDatePicker: UIDatePicker!
    //let myDatePicker = UIDatePicker()
    let realm = try! Realm()
    @IBAction func myDatePickerValueChanged(_ sender: Any) {
        

    
    }
    
    @IBAction func addPayDateButtonPressed(_ sender: Any) {
        
        let payDate = PayDate()
        let selectedDate = payDatePicker.date
        payDate.dueDate = selectedDate
        
        do {
            try realm.write {
                realm.add(payDate)}
        } catch {
            print("Error saving context, \(error)")
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
}
