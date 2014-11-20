//
//  HistoricalPedometerViewController.swift
//  HelloPedometer
//
//  Created by Hayley Guillou on 2014-11-19.
//  Copyright (c) 2014 hayleyguillou. All rights reserved.
//

import UIKit
import CoreMotion

class HistoricalPedometerViewController: UIViewController {
    
    override func viewDidLoad() {
        datePickerView.datePickerMode = UIDatePickerMode.Date
        datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
        
        let singleFingerTap = UITapGestureRecognizer()
        singleFingerTap.addTarget(self, action: Selector("closeDp:"))
        self.view.addGestureRecognizer(singleFingerTap)
    }
    
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
    @IBOutlet weak var outputLabel: UITextView!
    
    var datePickerView  : UIDatePicker = UIDatePicker()
    var currTextField: UITextField!
    var pedometer = CMPedometer()
    
    @IBAction func dp(sender: UITextField) {
        self.datePickerView.hidden = false
        currTextField = sender
        sender.inputView = datePickerView
    }
    
    func handleDatePicker(sender: UIDatePicker){
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        currTextField.text = dateFormatter.stringFromDate(sender.date)
    }
    
    var midnight: NSDate {
        let cal = NSCalendar.autoupdatingCurrentCalendar()
        return cal.startOfDayForDate(NSDate())
    }
    
    @IBAction func closeDp(sender: AnyObject) {
        if (currTextField != nil){
            currTextField.resignFirstResponder()
        }
        
    }
    
    @IBAction func submit(sender: AnyObject) {
        closeDp(sender)
        if (!startTextField.text.isEmpty && !endTextField.text.isEmpty) {
            var message: NSString = ""
            var startDate = getDate(startTextField.text)
            var endDate = getDate(endTextField.text)
            if CMPedometer.isStepCountingAvailable() {
                self.pedometer.queryPedometerDataFromDate(startDate, toDate: endDate, withHandler: {activity, error in
                    if (error != nil){
                        message = "Error: could not retrieve pedometer information for this date range: \(self.startTextField.text) - \(self.endTextField.text)."
                    }
                    else{
                        message = "Between \(self.startTextField.text) and \(self.endTextField.text), I walked \(activity.numberOfSteps) steps."
                    }
                })
            } else {
                message = "Error: Could not access pedometer information."
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.outputLabel.text = message
            }
        }
    }
    
    func getDate(stringDate: NSString) -> (NSDate) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let date = dateFormatter.dateFromString(stringDate)
        return date!
    }
    
}
