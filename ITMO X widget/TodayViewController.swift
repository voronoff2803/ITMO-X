//
//  TodayViewController.swift
//  ITMO X widget
//
//  Created by Alexey Voronov on 29/05/2019.
//  Copyright © 2019 Alexey Voronov. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NCWidgetProviding {
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == NCWidgetDisplayMode.compact {
            preferredContentSize = CGSize(width: maxSize.width, height: 65)
        } else {
            preferredContentSize = CGSize(width: maxSize.width, height: CGFloat(65 * getSubjects(weekType: weekEven, weekDay: Helper.app.normalWeekDay(weekday)).count))
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
    @IBOutlet var tableView: UITableView!
    
    var weekEven = 1
    var trueweekEven = 1
    var day = 0
    var weekday = 0
    var month = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeEven(ApiWorker.shared.weekEven)
        setup()
        reloadSchedule()
        extensionContext?.widgetLargestAvailableDisplayMode = .compact
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setTime()
        title = String(day) + "  " + Config.months[month]
        tableView.reloadData()
    }
    
    func setup() {
        setTime()
        changeEven(weekEven)
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: "ScheduleCell")
        tableView.rowHeight = 65
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = Config.Colors.gray
        tableView.backgroundColor = Config.Colors.gray
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getSubjects(weekType: weekEven, weekDay: Helper.app.normalWeekDay(weekday)).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell") as! ScheduleCell
        cell.setup(subject: getSubjects(weekType: weekEven, weekDay: Helper.app.normalWeekDay(weekday))[indexPath.row], indexPath: indexPath)
        return cell
    }

    
    func getSubjects(weekType: Int, weekDay: Int) -> [ScheduleSubject] {
        var result: [ScheduleSubject] = []
        let subjects = ApiWorker.shared.subjects
        for item in subjects {
            if (item.data_day == weekDay && (item.data_week == weekType || item.data_week == 0)) {
                result.append(item)
            }
        }
        return result
    }
    
    func reloadSchedule() {
        ApiWorker.shared.getSchedule(onSuccess: {
            DispatchQueue.main.async {
                self.changeEven(ApiWorker.shared.weekEven)
                self.tableView.reloadData()
            }
        }) { (error) in
        }
    }
    
    func setTime() {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .weekday], from: date)
        
        month = components.month!
        day = components.day!
        weekday = components.weekday!
    }
    

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ScheduleCell
        cell.tapped()
    }
    @objc func changeEvenAction() {
        changeEven(nil)
    }
    
    func changeEven(_ even: Int?) {
        if even == nil {
            if weekEven == 2 {
                weekEven = 1
            }  else {
                weekEven = 2
            }
            tableView.reloadData()
        } else {
            trueweekEven = even!
            weekEven = even!
        }
    }
    
    
    
}
