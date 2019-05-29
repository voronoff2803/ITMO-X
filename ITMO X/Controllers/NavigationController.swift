//
//  NavigationController.swift
//  ITMO X
//
//  Created by Alexey Voronov on 12/05/2019.
//  Copyright © 2019 Alexey Voronov. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .medium)]
        self.navigationBar.barTintColor = Config.Colors.whiteBars
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Config.Colors.black]
        if Config.Colors.blackStatus {
            navigationBar.barStyle = .black
        }
    }
}
