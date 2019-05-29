//
//  Helper.swift
//  ITMO X
//
//  Created by Alexey Voronov on 13/05/2019.
//  Copyright © 2019 Alexey Voronov. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    static var app: Helper = {
        return Helper()
    }()
    
    func normalWeekDay(_ weekDay: Int) -> Int {
        if weekDay < 2 {
            return 6
        } else {
            return weekDay - 2
        }
    }
}
