//
//  ViewController.swift
//  MoviesDB
//
//  Created by prafull kumar on 2/2/20.
//  Copyright © 2020 prafull kumar. All rights reserved.
//

import UIKit
import Kingfisher

class MovieViewController: UICollectionViewController {
    struct Constant {
        let topBottomPadding: CGFloat = 10
        let leftRightPadding: CGFloat = 16
        let cellIdentifier = "MoviesCollectionViewCell"
        let footerIdentifier = "FooterCollectionReusableView"
        let headerIdentifier = "HeaderCollectionReusableView"
        let controllerIdentifire = "MovieViewController"
        let footerHeight: CGFloat = 100
        let headerHeight: CGFloat = 275
        let descriptionPadding: CGFloat = 20
    }
    
    var viewModel: MoviesViewModel!
    
    private let constant = Constant()
    private var footer: FooterCollectionReusableView?
    
    lazy var activityView: UIActivityIndicatorView = {
       let activityView = UIActivityIndicatorView(style: .large)
       activityView.center = self.view.center
       activityView.startAnimating()
       self.view.addSubview(activityView)
       activityView.isHidden = true
       return activityView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if viewModel == nil {
            viewModel = MoviesViewModel()
        }
        viewModel.delegate = self
        setupUI()
        viewModel.fetchData()
    }
    
    private func setupUI() {
        
        self.title = viewModel.title
        
        if let layout = self.collectionViewLayout as? MoviesLayout {
            layout.delegate = self
        }
        
        self.collectionView.register(UINib(nibName: constant.cellIdentifier, bundle: .main),
                                     forCellWithReuseIdentifier: constant.cellIdentifier)
        
        self.collectionView.register(UINib(nibName: constant.footerIdentifier, bundle: .main),
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                     withReuseIdentifier: constant.footerIdentifier)
        
        self.collectionView.register(UINib(nibName: constant.headerIdentifier, bundle: .main),
        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
        withReuseIdentifier: constant.headerIdentifier)
        
        
        
        collectionView?.backgroundColor = .systemBackground
        collectionView?.contentInset = UIEdgeInsets(top: constant.topBottomPadding,
                                                    left: constant.leftRightPadding,
                                                    bottom: constant.topBottomPadding,
                                                    right: constant.leftRightPadding)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cellCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: constant.cellIdentifier, for: indexPath) as? MoviesCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.imageView.kf.setImage(with: URL(string: viewModel.getImageURLString(for: indexPath.row)))
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dataModel = viewModel.dataObject(for: indexPath.row) else { return }
        let detailViewModel = MoviesViewModel(detailObject: dataModel)
        guard let movieViewController = self.storyboard?.instantiateViewController(withIdentifier: constant.controllerIdentifire) as? MovieViewController else {
            fatalError("Storybord not configured")
        }
        movieViewController.viewModel = detailViewModel
        self.navigationController?.pushViewController(movieViewController, animated: true)

    }
    
    
     override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            footer = footer ?? (collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: constant.footerIdentifier,
            for: indexPath) as? FooterCollectionReusableView)
            footer?.loader.isHidden = false
            footer?.loader.startAnimating()
            viewModel.fetchNextPage()
             return footer ?? UICollectionReusableView()
        case UICollectionView.elementKindSectionHeader:
            guard let header  = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: constant.headerIdentifier,
            for: indexPath) as? HeaderCollectionReusableView else {
                return UICollectionReusableView()
            }
            header.bind(viewModel: MovieHeaderViewModel(dataModel: viewModel.detailObjectModel))
            return header
        default:
            return UICollectionReusableView()
        }

    }
}

extension MovieViewController: MoviesLayoutDelegate {
    func height(supplementaryViewKind: String) -> CGFloat {
         switch supplementaryViewKind {
           case UICollectionView.elementKindSectionFooter:
            return viewModel.shouldShowFooter ?  constant.footerHeight : 0
           case UICollectionView.elementKindSectionHeader:
            return viewModel.shoudShowHeader ?  constant.headerHeight  + getDescriptionHeight() : 0
           default:
               return 0
           }
    }
    
    func getDescriptionHeight() -> CGFloat {
        guard let description = viewModel.headerDescription else {
            return 0
        }
        return description.getHeight(withConstrainedWidth: self.collectionView.frame.width - constant.descriptionPadding * 2, font: UIFont.systemFont(ofSize: 14))
    }
}

extension MovieViewController: MovieViewControllerUpdateDelegate {
    func viewModel(didUpdateState state: ViewModelState) {
        switch state {
        case .loading:
            if !viewModel.hasData { showLoading() }
        case .loadSuccess:
            hideLoading()
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.reloadData()
        case .loadFail(let errorMessage):
            hideLoading()
            let alert = UIAlertController(title: "Error!",
                                          message: errorMessage,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        case .unknown:
            break
        }
    }
    
    private func showLoading() {
        activityView.isHidden = false
        activityView.startAnimating()
    }
    
    private func hideLoading() {
        activityView.isHidden = true
        activityView.startAnimating()
        footer?.loader.startAnimating()
        footer?.loader.isHidden = true
    }
}


