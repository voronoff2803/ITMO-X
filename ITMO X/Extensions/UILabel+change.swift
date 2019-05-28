//
//  UILabel.swift
//  ITMO X
//
//  Created by Alexey Voronov on 15/05/2019.
//  Copyright © 2019 Alexey Voronov. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func changeText(text: String?) {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: 5)
            self.alpha = 0
        }, completion: { bool in
            self.text = text
            self.transform = CGAffineTransform(translationX: 0, y: -10)
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = CGAffineTransform(translationX: 0, y: 0)
                self.alpha = 1
            })
        })
    }
}
