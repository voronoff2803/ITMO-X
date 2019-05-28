//
//  CdeTableViewController.swift
//  ITMO X
//
//  Created by Alexey Voronov on 12/05/2019.
//  Copyright © 2019 Alexey Voronov. All rights reserved.
//

import UIKit

class CdeTableViewController: UITableViewController {

    var subjects: [CdeSubject] = []
    let segment: UISegmentedControl = UISegmentedControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    func  setup() {
        self.reloadCde()
        self.title = "Журнал"
        self.tableView.register(CdeSubjectCell.self, forCellReuseIdentifier: "CdeSubjectCell")
        self.tableView.rowHeight = 65
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorColor = Config.Colors.gray
        self.tableView.backgroundColor = Config.Colors.gray
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        self.setSegmentedControl()
    }
    
    func setSegmentedControl() {
        self.segment.addTarget(self, action: #selector(changeSem(_:)), for: .valueChanged)
        self.segment.sizeToFit()
        self.segment.tintColor = Config.Colors.black
        self.navigationItem.titleView = self.segment
    }
    
    func updateSegmentedControl() {
        self.segment.removeAllSegments()
        let semestr = Int(Config.semestr) ?? 0
        for i in 1...semestr {
            self.segment.insertSegment(withTitle: "\(i) сем", at: self.segment.numberOfSegments, animated: false)
        }
        self.segment.sizeToFit()
        self.segment.selectedSegmentIndex = Int(Config.semestr)! - 1
    }
    
    @objc func changeSem(_ control: UISegmentedControl) {
        Config.semestr = String(control.selectedSegmentIndex + 1)
        self.subjects = ApiWorker.shared.cdeSbjects.filter() {$0.semester == Config.semestr}
        self.tableView.reloadData()
    }
    
    @objc func refresh() {
        self.reloadCde()
    }
    
    func reloadCde() {
        loadingIndicator(show: true)
        ApiWorker.shared.getJournal(onSuccess: {
            DispatchQueue.main.async {
                self.loadingIndicator(show: false)
                self.subjects = ApiWorker.shared.cdeSbjects.filter() {$0.semester == Config.semestr}
                self.refreshControl!.endRefreshing()
                self.updateSegmentedControl()
                self.tableView.reloadData()
            }
        }, onFailure: { (error) in
            DispatchQueue.main.async {
                print(error)
                self.alert(title: "Ошибка", message: "Проверьте логин и пароль")
                self.loadingIndicator(show: false)
                self.refreshControl!.endRefreshing()
            }
        })
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return subjects.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CdeSubjectCell", for: indexPath) as! CdeSubjectCell
        cell.setup(subject: subjects[indexPath.row], indexPath: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let subject = subjects[indexPath.row]
        let cdePointsTableController = CdePointsTableController(points: subject.marks!, title: subject.name!)
        navigationController?.pushViewController(cdePointsTableController, animated: true)
    }
}
