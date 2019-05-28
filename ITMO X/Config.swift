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
        static var blue = #colorLiteral(red: 0, green: 0.4618991017, blue: 1, alpha: 1)
        static var grayText = #colorLiteral(red: 0.6763240232, green: 0.6763240232, blue: 0.6763240232, alpha: 1)
        static var gray = #colorLiteral(red: 0.9298659581, green: 0.9298659581, blue: 0.9298659581, alpha: 1)
        static var white = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        static var green = #colorLiteral(red: 0.3492472069, green: 0.6454830266, blue: 0.1348775036, alpha: 1)
        static var red = #colorLiteral(red: 1, green: 0.3355553344, blue: 0.2866917798, alpha: 1)
        static var black = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        static var whiteBars = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        static var blackStatus = false
    }
    
    static var semestr = "1"
}
