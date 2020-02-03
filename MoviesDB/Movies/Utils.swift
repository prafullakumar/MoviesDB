//
//  Utils.swift
//  MoviesDB
//
//  Created by prafull kumar on 3/2/20.
//  Copyright © 2020 prafull kumar. All rights reserved.
//

import UIKit

extension String {
    func getHeight(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
           let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
           let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
           return ceil(boundingBox.height)
    }
}
