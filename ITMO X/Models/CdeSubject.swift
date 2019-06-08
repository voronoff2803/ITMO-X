//
//  CdeSubject.swift
//  ITMO X
//
//  Created by Alexey Voronov on 12/05/2019.
//  Copyright © 2019 Alexey Voronov. All rights reserved.
//

import Foundation

struct CdeSubject {
    let name: String?
    let mark: String?
    let worktype: String?
    let points: String?
    let semester: String
    let marks: [CdeMark]?
}

struct CdeMark {
    let name: String?
    let workType: String?
    let max: String?
    let value: String?
    let mark: String?
    let limit: String?
}
