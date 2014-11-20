//
//  ViewController.swift
//  HelloPedometer
//
//  Created by Hayley Guillou on 2014-11-18.
//  Copyright (c) 2014 hayleyguillou. All rights reserved.
//

import UIKit
import CoreMotion

class LivePedometerViewController: UIViewController {
    
    let pedometer = CMPedometer()
    var lastUpdatedDate = NSDate()
    let dateFormatter = NSDateFormatter()
    
    @IBOutlet weak var stepCountLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
    }
    
    override func viewWillAppear(animated: Bool) {
        setupPedometer()
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        pedometer.stopPedometerUpdates()
        super.viewWillDisappear(animated)
    }
    
    func setupPedometer() {
        
        if CMPedometer.isStepCountingAvailable() {
            self.pedometer.startPedometerUpdatesFromDate(midnight) { pedometerData, pedError in
                if pedError != nil {
                    // failed, handle error
                } else {
                    self.lastUpdatedDate = NSDate()
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.stepCountLabel.text = "\(pedometerData.numberOfSteps.integerValue) steps"
                        self.lastUpdatedLabel.text = "Last updated: \(self.dateFormatter.stringFromDate(pedometerData.endDate))"
                    }
                }
            }
        } else {
            self.stepCountLabel.text = "Could not access pedometer data"
            self.lastUpdatedLabel.text = "Last updated: never"
        }
        
    }
    
    var midnight: NSDate {
        let cal = NSCalendar.autoupdatingCurrentCalendar()
        return cal.startOfDayForDate(NSDate())
    }
    
}

