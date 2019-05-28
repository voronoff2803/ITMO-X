//
//  UIViewController+LoadIndicator.swift
//  ITMO X
//
//  Created by Alexey Voronov on 13/05/2019.
//  Copyright © 2019 Alexey Voronov. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func loadingIndicator(show: Bool) {
        DispatchQueue.main.async {
            if show {
                var offset: CGFloat = 0.0
                if let tableView = self.view as? UITableView {
                    offset = tableView.contentOffset.y
                    if offset < 0 {
                        offset = 0
                    }
                }
                self.view.isUserInteractionEnabled = false
                let back = UIView(frame: self.view.frame)
                back.transform = CGAffineTransform(translationX: 0, y: offset)
                back.backgroundColor = Config.Colors.white
                let indicator = UIActivityIndicatorView()
                indicator.center = CGPoint(x: back.frame.width/2, y: back.frame.height/2)
                if Config.Colors.blackStatus {
                    indicator.style = .whiteLarge
                } else {
                    indicator.style = .gray
                }
                back.addSubview(indicator)
                self.view.addSubview(back)
                indicator.startAnimating()
                back.layer.zPosition = 10
                back.tag = 10
            } else {
                self.view.subviews.filter() {$0.tag == 10}.forEach() {$0.removeFromSuperview()}
                self.view.isUserInteractionEnabled = true
            }
        }
    }
}
