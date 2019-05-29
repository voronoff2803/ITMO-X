//
//  Config.swift
//  ITMO X
//
//  Created by Alexey Voronov on 12/05/2019.
//  Copyright © 2019 Alexey Voronov. All rights reserved.
//

import Foundation
import UIKit

struct Config {
    static let weekdays = [
        "Понедельник",
        "Вторник",
        "Среда",
        "Четверг",
        "Пятница",
        "Суббота",
        "Воскресенье"
    ]
    
    static let months = [
        "",
        "Января",
        "Февраля",
        "Марта",
        "Апреля",
        "Мая",
        "Июня",
        "Июля",
        "Августа",
        "Сентября",
        "Октября",
        "Ноября",
        "Декабря"
    ]
    
    struct Colors {
        static var blue = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        static var grayText = #colorLiteral(red: 0.728748858, green: 0.7488489747, blue: 0.7654711604, alpha: 1)
        static var gray = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8004869435)
        static var white = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        static var green = #colorLiteral(red: 0, green: 0.790019691, blue: 0.467805326, alpha: 1)
        static var red = #colorLiteral(red: 0.9951623082, green: 0.2123986185, blue: 0.2090759277, alpha: 1)
        static var black = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        static var whiteBars = #colorLiteral(red: 0.04605636048, green: 0.04651236405, blue: 0.04651236405, alpha: 1)
        static var blackStatus = true
    }
    
    static var semestr = "1"
}
