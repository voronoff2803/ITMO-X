//
//  CdeSubjectCell.swift
//  ITMO X
//
//  Created by Alexey Voronov on 12/05/2019.
//  Copyright © 2019 Alexey Voronov. All rights reserved.
//

import UIKit

class CdeSubjectCell: UITableViewCell {
    
    var cellIndex: IndexPath?
    var subject: CdeSubject?

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
    
    private let devider: UIView = {
        let view = UIView()
        view.backgroundColor = Config.Colors.gray
        return view
    }()
    
    private let valueLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = Config.Colors.black
        lbl.font = UIFont.systemFont(ofSize: 25, weight: .light)
        lbl.textAlignment = .center
        return lbl
    }()
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        decorate()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func decorate() {
        self.selectionStyle = .none
        self.backgroundColor = Config.Colors.white
        
        addSubview(subjectNameLabel)
        addSubview(subjectDescriptionLabel)
        addSubview(devider)
        addSubview(valueLabel)
        
        devider.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 10, paddingLeft: 70, paddingBottom: 10, paddingRight: 0, width: 1.5, height: 0, enableInsets: false)
        subjectNameLabel.anchor(top: topAnchor, left: devider.leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 17, paddingBottom: 0, paddingRight: 17, width: 0, height: 0, enableInsets: false)
        subjectDescriptionLabel.anchor(top: nil, left: devider.leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 17, paddingBottom: 12, paddingRight: 17, width: 0, height: 0, enableInsets: false)
        valueLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: devider.leftAnchor, paddingTop: 4, paddingLeft: 0, paddingBottom: 4, paddingRight: 0, width: 0, height: 0, enableInsets: false)
    }
    
    func setup(subject: CdeSubject, indexPath: IndexPath!) {
        self.subject = subject
        if (self.cellIndex == indexPath && self.subjectNameLabel.text != subject.name) || self.subjectNameLabel.text == nil {
            DispatchQueue.global().asyncAfter(deadline: .now() + .random(in: 0...0.2), execute: {
                DispatchQueue.main.async {
                    self.subjectNameLabel.changeText(text: subject.name)
                    self.valueLabel.changeText(text: subject.points ?? "0")
                    self.subjectDescriptionLabel.changeText(text: subject.worktype)
                }
            })
        } else {
            self.valueLabel.text = subject.points ?? "0"
            self.subjectNameLabel.text = subject.name
            self.subjectDescriptionLabel.text = subject.worktype
        }
        if let value = subject.points {
            if (value != "") {
                if Float(value.replacingOccurrences(of: ",", with: "."))! >= 60  {
                    //subjectDescriptionLabel.textColor = Config.Colors.green
                    //valueLabel.textColor = Config.Colors.green
                    devider.backgroundColor = Config.Colors.green
                } else {
                    //subjectDescriptionLabel.textColor = Config.Colors.black
                    //valueLabel.textColor = Config.Colors.black
                    devider.backgroundColor = Config.Colors.grayText
                }
            } else {
                devider.backgroundColor = Config.Colors.grayText
            }
        } else {
            devider.backgroundColor = Config.Colors.gray
        }
        self.cellIndex = indexPath
    }
    
    func setup(mark: CdeMark) {
        valueLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        subjectNameLabel.text = mark.name ?? mark.workType
        if let value = mark.value {
            valueLabel.text = value + "/" + mark.max!
            if (mark.limit != nil && mark.limit != "") {
                subjectDescriptionLabel.text = "Необходимый порог: \(mark.limit ?? "")"
                if Float(mark.limit!.replacingOccurrences(of: ",", with: "."))! <= Float(value.replacingOccurrences(of: ",", with: "."))! {
                    subjectDescriptionLabel.textColor = Config.Colors.green
                    //valueLabel.textColor = Config.Colors.green
                    devider.backgroundColor = Config.Colors.green
                } else {
                    subjectDescriptionLabel.textColor = Config.Colors.black
                    //valueLabel.textColor = Config.Colors.black
                    devider.backgroundColor = Config.Colors.grayText
                }
            } else {
                subjectDescriptionLabel.text = ""
            }
        } else {
            valueLabel.text = ""
            subjectDescriptionLabel.text = ""
            subjectNameLabel.textColor = Config.Colors.black
            valueLabel.textColor = Config.Colors.black
        }
    }

}
