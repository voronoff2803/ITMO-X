//
//  ScheduleCell.swift
//  ITMO X
//
//  Created by Alexey Voronov on 12/05/2019.
//  Copyright © 2019 Alexey Voronov. All rights reserved.
//

import UIKit

class ScheduleCell: UITableViewCell {
    
    var subject: ScheduleSubject?
    var cellIndex: IndexPath?
    
    private let subjectNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = Config.Colors.black
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let subjectDescriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = Config.Colors.grayText
        lbl.font = UIFont.systemFont(ofSize: 13)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let startTimeLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = Config.Colors.black
        lbl.font = UIFont.systemFont(ofSize: 13)
        lbl.textAlignment = .right
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let endTimeLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = Config.Colors.grayText
        lbl.font = UIFont.systemFont(ofSize: 13)
        lbl.textAlignment = .right
        lbl.numberOfLines = 0
        return lbl
    }()
    
    
    private let devider: UIView = {
        let view = UIView()
        view.backgroundColor = Config.Colors.gray
        return view
    }()
    
    private let current: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = Config.Colors.blue
        return view
    }()
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        decorate()
    }
    
    func decorate() {
        self.selectionStyle = .none
        self.backgroundColor = Config.Colors.white
        addSubview(subjectNameLabel)
        addSubview(subjectDescriptionLabel)
        addSubview(devider)
        addSubview(startTimeLabel)
        addSubview(endTimeLabel)
        addSubview(current)
        
        devider.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 10, paddingLeft: 70, paddingBottom: 10, paddingRight: 0, width: 1.5, height: 0, enableInsets: false)
        startTimeLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: devider.leftAnchor, paddingTop: 14, paddingLeft: 0, paddingBottom: 0, paddingRight: 13, width: 0, height: 0, enableInsets: false)
        endTimeLabel.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: devider.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 14, paddingRight: 13, width: 0, height: 0, enableInsets: false)
        subjectNameLabel.anchor(top: topAnchor, left: devider.leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 17, paddingBottom: 0, paddingRight: 17, width: 0, height: 0, enableInsets: false)
        subjectDescriptionLabel.anchor(top: nil, left: devider.leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 17, paddingBottom: 12, paddingRight: 17, width: 0, height: 0, enableInsets: false)
        current.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 4, height: 0, enableInsets: false)
    }
    
    func setup(subject: ScheduleSubject, indexPath: IndexPath!) {
        self.subjectDescriptionLabel.textColor = Config.Colors.grayText
        self.subject = subject
        let place = subject.place ?? ""
        let room = subject.room ?? ""
        self.subjectNameLabel.text = subject.title
        self.subjectDescriptionLabel.text = place + " " + room
        self.startTimeLabel.text = subject.start_time
        self.endTimeLabel.text = subject.end_time
        if subject.status == "Лек" {
            devider.backgroundColor = Config.Colors.red
        } else {
            devider.backgroundColor = Config.Colors.green
        }
        
    
        self.cellIndex = indexPath
    }
    
    func tapped() {
        self.subjectDescriptionLabel.text = subject?.person ?? ""
        self.isUserInteractionEnabled = false
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0, execute: {
            DispatchQueue.main.async {
                self.isUserInteractionEnabled = true
                let place = self.subject?.place ?? ""
                let room = self.subject?.room ?? ""
                self.subjectDescriptionLabel.text = place + " " + room
            }
        })
    }
}

