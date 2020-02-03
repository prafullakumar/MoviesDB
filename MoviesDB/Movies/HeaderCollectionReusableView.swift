//
//  HeaderCollectionReusableView.swift
//  MoviesDB
//
//  Created by prafull kumar on 3/2/20.
//  Copyright © 2020 prafull kumar. All rights reserved.
//

import UIKit
import Kingfisher
struct MovieHeaderViewModel {
    let dataModel: MovieList.Result?
    
    init(dataModel: MovieList.Result?) {
        self.dataModel = dataModel
    }
    
    var description: String {
        return dataModel?.overview ?? ""
    }
    
    var releaseDate: String {
        return dataModel?.releaseDate ?? "NA"
    }
    
    var rating: String {
        return "\(dataModel?.voteAverage ?? 0)"
    }
    
    var movieName: String {
        return dataModel?.originalTitle ?? "NA"
    }
    
    var imageURL: String {
        return Constants.imageBaseURL + (dataModel?.posterPath ?? "")
    }
    
}


class HeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var overviewLabel: UITextView!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bind(viewModel: MovieHeaderViewModel) {
        overviewLabel.text = viewModel.description
        rating.text = viewModel.rating
        releaseDate.text = viewModel.releaseDate
        movieName.text = viewModel.movieName
        movieImage.kf.setImage(with: URL(string: viewModel.imageURL))
    }
}
