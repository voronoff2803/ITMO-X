//
//  UIViewController+statusBar.swift
//  ITMO X
//
//  Created by Alexey Voronov on 13/05/2019.
//  Copyright © 2019 Alexey Voronov. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    var preferredSarStyle: UIStatusBarStyle {
        if Config.Colors.blackStatus {
            return .default
        } else {
            return .lightContent
        }
    }
    
}
