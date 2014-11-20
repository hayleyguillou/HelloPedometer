//
//  WeeklyPedometerViewController.swift
//  HelloPedometer
//
//  Created by Hayley Guillou on 2014-11-20.
//  Copyright (c) 2014 hayleyguillou. All rights reserved.
//

import UIKit
import CoreMotion

class WeeklyPedometerViewController: UITableViewController {

    required init(coder aDecoder: NSCoder) {
        pedometerCollection = [weekPedometer]()
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }

    let dateFormatter = NSDateFormatter()
    let lengthFormatter = NSLengthFormatter()
    let pedometer = CMPedometer()
    
    var pedometerCollection: [weekPedometer]
    
    struct weekPedometer {
        var startDate: NSDate
        var endDate: NSDate
        var numberOfSteps: Int
        
        init(date: NSDate) {
            self.endDate = date
            self.startDate = self.endDate.dateByAddingTimeInterval(-60 * 60 * 24 * 7)
            numberOfSteps = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        fetchPedometerData()
        dateFormatter.dateFormat = "dd-MM-yyyy";
    }
    
    
    // MARK:- Motion Activity Methods
    func fetchPedometerData() {
        let oneWeekInterval = 60 * 60 * 24 * 7 as NSTimeInterval
        var date = NSDate()
        var errorOccurred = false
        while( !errorOccurred ) {
            var week = weekPedometer(date: date)
            if CMPedometer.isStepCountingAvailable() {
                pedometer.queryPedometerDataFromDate(week.startDate, toDate: week.endDate, withHandler: {
                    activity, error in
                    if error != nil {
                        errorOccurred = true
                        println("There was an error retrieving the motion results: \(error)")
                    } else {
                        week.numberOfSteps = Int(activity.numberOfSteps)
                        self.pedometerCollection.append(week)
                    }
                })
            } else {
//                var date1: NSDate = date
//                var date2: NSDate = NSDate().dateByAddingTimeInterval(-(60*60*24*365))
//                week.numberOfSteps = week.startDate.hashValue % 12000
//                self.pedometerCollection.append(week)
//                var result = date1.compare(date2)
//                if (result == NSComparisonResult.OrderedAscending) {
                    errorOccurred = true
//                }
                
            }
            
            date = date.dateByAddingTimeInterval(-oneWeekInterval)
        }
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
    
    // MARK:- UITableViewController methods
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pedometerCollection.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell.textLabel.text = "\(dateFormatter.stringFromDate(self.pedometerCollection[indexPath.row].startDate)) - \(dateFormatter.stringFromDate(self.pedometerCollection[indexPath.row].endDate)) ... \(self.pedometerCollection[indexPath.row].numberOfSteps) steps."
        cell.textLabel.sizeToFit()
        return cell
        
    }
    
}