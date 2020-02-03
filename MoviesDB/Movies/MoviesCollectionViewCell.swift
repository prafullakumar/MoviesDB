//
//  MoviesCollectionViewCell.swift
//  MoviesDB
//
//  Created by prafull kumar on 3/2/20.
//  Copyright © 2020 prafull kumar. All rights reserved.
//

import UIKit

class MoviesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }

    private func setupUI() {
        imageView.layer.cornerRadius = 10
    }


}
