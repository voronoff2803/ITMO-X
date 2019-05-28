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
    
    func getMainScreenController() -> UIViewController {
        let scheduleControoler = ScheduleTableViewController()
        let cdeControoller = CdeTableViewController()
        let scheduleNavigationController = NavigationController(rootViewController: scheduleControoler)
        let cdeNavigationController = NavigationController(rootViewController: cdeControoller)
        let tabBarController = TabBarController()
        scheduleNavigationController.tabBarItem = UITabBarItem(title: "Расписание", image: UIImage(named: "graduation_cap"), tag: 0)
        cdeNavigationController.tabBarItem = UITabBarItem(title: "Журнал", image: UIImage(named: "bookmark"), tag: 1)
        let tabBarList = [scheduleNavigationController, cdeNavigationController]
        tabBarController.viewControllers = tabBarList
        return tabBarController
    }
}
