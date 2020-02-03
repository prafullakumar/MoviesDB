//
//  MoviesViewModel.swift
//  MoviesDB
//
//  Created by prafull kumar on 3/2/20.
//  Copyright © 2020 prafull kumar. All rights reserved.
//

import Foundation
import Moya

enum ScreenType {
    case trending
    case details
}

enum ViewModelState {
    case loading
    case loadSuccess
    case loadFail(String)
    case unknown
}


protocol  MovieViewControllerUpdateDelegate: class {
    func viewModel(didUpdateState state: ViewModelState)
}


final class MoviesViewModel {
    let screenType: ScreenType
    let detailObjectModel: MovieList.Result?
    let store: MoviesStore
    var dataModel: MovieList?
    var latestPage = 1
    weak var delegate: MovieViewControllerUpdateDelegate?
    var state: ViewModelState = .unknown {
        didSet {
            self.delegate?.viewModel(didUpdateState: state)
        }
    }
    
    init() {
        self.screenType = .trending
        detailObjectModel = nil
        self.store = MoviesStore(networking: Networking(provider: MoyaProvider<MoviesAPI>()))
    }
    
    init(detailObject : MovieList.Result) {
        self.screenType = .details
        detailObjectModel = detailObject
        self.store = MoviesStore(networking: Networking(provider: MoyaProvider<MoviesAPI>()))
    }
    
    var title: String {
        switch screenType {
        case .details:
            return detailObjectModel?.title ?? "Movie"
        default:
            return "Trending Now"
        }
        
    }
    var shoudShowHeader: Bool {
        switch screenType {
        case .details:
            return true
        default:
            return false
        }
    }
     
    var hasData: Bool {
        switch screenType {
        case .details:
            return true
        default:
            return cellCount != 0
        }
    }
    
    var shouldShowFooter: Bool {
        return (latestPage < (dataModel?.totalPages ?? Int.max)) && hasData
    }
    
    
    var cellCount: Int {
        return (dataModel?.results.count ?? 0)
    }
    
    ///
    var headerDescription: String? {
        return detailObjectModel?.overview
    }
    
    func dataObject(for index: Int) -> MovieList.Result? {
        return dataModel?.results[index]
    }
    
    func fetchData() {
        switch state {
            case .loading:
                return
            default:
                state = .loading
                self.fetchLatestData()
        }
    }
    
    func fetchNextPage() {
        switch state {
            case .loading:
                return
            default:
                if latestPage >= (dataModel?.totalPages ?? Int.max)  {
                    state = .loadFail("No more data to show")
                } else {
                    state = .loading
                    self.fetchNextPageData()
                }
        }
    }
    
    func getImageURLString(for index: Int) -> String {
        return Constants.imageBaseURL  + (dataModel?.results[index].posterPath ?? "") //if URl Invalid no imge will render
    }
    
    
    
    ///
    private func fetchLatestData() {
        switch screenType {
        case .trending:
            fetchTrendindMovieData()
        default:
            fetchSimilerMovieData()
        }
       
    }
    
    private func fetchTrendindMovieData() {
       store.getTrendingMovies(page: 1) { [weak self] (result) in
           guard let self = self else { return }
           switch result {
           case .success(let list):
                   self.dataModel = list
                   self.latestPage = 2
                   self.state = .loadSuccess
           case .failure(let errorMessage):
               self.state = .loadFail(errorMessage)
           }
       }
    }
    
    private func fetchSimilerMovieData() {
        guard let movieID = detailObjectModel?.id else {
            self.state = .loadFail("Do not have a valid movie ID")
            return
        }
        
        store.getSimilarMovies(page: 1, movieId: String(movieID)) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let list):
                    self.dataModel = list
                    self.latestPage = 2
                    self.state = .loadSuccess
            case .failure(let errorMessage):
                self.state = .loadFail(errorMessage)
            }
        }
    }
    
    private func fetchNextPageData() {
        switch screenType {
        case .trending:
            fetchTrendindMovieNextPageData()
        default:
            fetchSimilerMovieNextPageData()
        }
    }
    
    private func fetchTrendindMovieNextPageData() {
        store.getTrendingMovies(page: latestPage) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let list):
                    self.appendDataToDataModel(newData: list)
                    self.latestPage += 2
                    self.state = .loadSuccess
            case .failure(let errorMessage):
                self.state = .loadFail(errorMessage)
            }
        }
    }
    
    
    private func fetchSimilerMovieNextPageData() {
        guard let movieID = detailObjectModel?.id else {
                  self.state = .loadFail("Do not have a valid movie ID")
                  return
              }
              
        store.getSimilarMovies(page: latestPage, movieId: String(movieID)) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let list):
                    self.appendDataToDataModel(newData: list)
                    self.latestPage += 1
                    self.state = .loadSuccess
            case .failure(let errorMessage):
                self.state = .loadFail(errorMessage)
            }
        }
    }
    
    private func appendDataToDataModel(newData: MovieList) {
        guard let currentData = self.dataModel else {
            self.dataModel = newData
            return
        }
        
        let list: [MovieList.Result] = currentData.results + newData.results
        self.dataModel = MovieList(results: list, page: newData.page,
                                   totalResults: list.count,
                                   dates: newData.dates,
                                   totalPages: newData.totalPages)
    }
    
}
