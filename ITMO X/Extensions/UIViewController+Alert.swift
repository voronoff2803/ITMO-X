//
//  UIViewController+Alert.swift
//  ITMO
//
//  Created by Alexey Voronov on 12/03/2019.
//  Copyright © 2019 Alexey Voronov. All rights reserved.
//

import UIKit

extension UIViewController {
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
