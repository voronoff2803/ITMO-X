//
//  ViewController.swift
//  ITMO X
//
//  Created by Alexey Voronov on 11/05/2019.
//  Copyright © 2019 Alexey Voronov. All rights reserved.
//

import UIKit

class ScheduleTableViewController: UITableViewController {
    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setTime()
        title = String(day) + "  " + Config.months[month]
        tableView.reloadData()
    }
    
    func setup() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: ApiWorker.shared.group, style: .plain, target: self, action: #selector(changeGroupAction))
        navigationItem.rightBarButtonItem?.tintColor = Config.Colors.black
        setTime()
        changeEven(weekEven)
        title = String(day) + "  " + Config.months[month]
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: "ScheduleCell")
        tableView.rowHeight = 65
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = Config.Colors.gray
        tableView.backgroundColor = Config.Colors.gray
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
    }
    
    @objc func refresh() {
        setTime()
        changeEven(weekEven)
        title = String(day) + "  " + Config.months[month]
        reloadSchedule()
    }
    
    @objc func changeGroupAction() {
        let alert = UIAlertController(title: "Номер группы", message: nil, preferredStyle: UIAlertController.Style.alert)
        let save = UIAlertAction(title: "Сохранить", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            if textField.text != "" {
                ApiWorker.shared.group = textField.text ?? "K3240"
                UserDefaults.standard.set(ApiWorker.shared.group, forKey: "group")
            }
            self.reloadSchedule()
        }
        

        alert.addTextField { (textField) in
            textField.text = ApiWorker.shared.group
        }

        alert.addAction(save)
        
        self.present(alert, animated:true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getSubjects(weekType: weekEven, weekDay: section).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell") as! ScheduleCell
        cell.setup(subject: getSubjects(weekType: weekEven, weekDay: indexPath.section)[indexPath.row], indexPath: indexPath)
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Config.weekdays[section]
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
    
    func scrollToCurrent() {
        let indexPath = IndexPath(row: 0, section: Helper.app.normalWeekDay(self.weekday))
        if let _ = tableView.cellForRow(at: indexPath) {
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func reloadSchedule() {
        self.loadingIndicator(show: true)
        ApiWorker.shared.getSchedule(onSuccess: {
            DispatchQueue.main.async {
                self.changeEven(ApiWorker.shared.weekEven)
                self.refreshControl!.endRefreshing()
                self.loadingIndicator(show: false)
                self.tableView.reloadData()
                self.scrollToCurrent()
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: ApiWorker.shared.group, style: .plain, target: self, action: #selector(self.changeGroupAction))
                self.navigationItem.rightBarButtonItem?.tintColor = Config.Colors.black
            }
        }) { (error) in
            self.refreshControl!.endRefreshing()
            self.alert(title: "Ошибка", message: "Проверьте номер группы")
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
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = UIFont.systemFont(ofSize: 13)
        header.textLabel?.frame = header.frame
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init(frame: CGRect.zero)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ScheduleCell
        cell.tapped()
    }
    @objc func changeEvenAction() {
        changeEven(nil)
    }
    
    func changeEven(_ even: Int?) {
        var title = ""
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
        var style = UIBarButtonItem.Style.plain
        if trueweekEven == weekEven {
            style = .done
        }
        
        if weekEven == 2 {
            title = "Нечетная"
        } else {
            title = "Четная"
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: title, style: style, target: self, action: #selector(changeEvenAction))
        navigationItem.leftBarButtonItem?.tintColor = Config.Colors.black
    }
}
