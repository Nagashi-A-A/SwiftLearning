//
//  DatePickerController.swift
//  PersonalPlanner
//
//  Created by Anton Yaroshchuk on 10.07.2021.
//

import UIKit

class DatePickerController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var dateToSend: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.layer.cornerRadius = 15
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        dateToSend = datePicker.date
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
