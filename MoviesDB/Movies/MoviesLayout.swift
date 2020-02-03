//
//  MoviesLayout.swift
//  MoviesDB
//
//  Created by prafull kumar on 3/2/20.
//  Copyright © 2020 prafull kumar. All rights reserved.
//

import UIKit

protocol MoviesLayoutDelegate: class {
    func height(supplementaryViewKind: String) -> CGFloat
}

class MoviesLayout: UICollectionViewLayout {
    
    private var numberOfColumns: Int = 2
    private let imageAspectRatio: CGFloat = 275/185
    private let cellPadding: CGFloat = 6
    weak var delegate: MoviesLayoutDelegate?

    // 3
    private var cache: [UICollectionViewLayoutAttributes] = []

    // 4
    private var contentHeight: CGFloat = 0

    private var contentWidth: CGFloat {
      guard let collectionView = collectionView else {
        return 0
      }
      let insets = collectionView.contentInset
      return collectionView.bounds.width - (insets.left + insets.right)
    }

    // 5
    override var collectionViewContentSize: CGSize {
      return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func invalidateLayout() {
        cache.removeAll()
        super.invalidateLayout()
    }
    
    override func prepare() {
        // 1
        guard
          cache.isEmpty == true,
          let collectionView = collectionView
          else {
            return
        }
        // header
        
        var evalheaderHeight: CGFloat = 0
        if let headerHeight = delegate?.height(supplementaryViewKind: UICollectionView.elementKindSectionHeader), headerHeight != 0 {
            let footerAttributes = UICollectionViewLayoutAttributes(
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                                                    with: IndexPath(row: collectionView.numberOfItems(inSection: 0), section: 0))

            footerAttributes.frame = CGRect.init(origin: CGPoint.init(x: 0, y: 0),
                                           size: CGSize(width: contentWidth, height: headerHeight))
            cache.append(footerAttributes)
            evalheaderHeight = headerHeight
        }
        
        // cell
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
          xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: evalheaderHeight, count: numberOfColumns)
         
        
        // Cells
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
          let indexPath = IndexPath(item: item, section: 0)
            
          let photoHeight = columnWidth * imageAspectRatio
          let height = cellPadding * 2 + photoHeight
          let frame = CGRect(x: xOffset[column],
                             y: yOffset[column],
                             width: columnWidth,
                             height: height)
          let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
          // 5
          let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
          attributes.frame = insetFrame
          cache.append(attributes)
            
          // 6
          contentHeight = max(contentHeight, frame.maxY)
          yOffset[column] = yOffset[column] + height
            
          column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
        
        // footer
        if let footerHeight = delegate?.height(supplementaryViewKind: UICollectionView.elementKindSectionFooter), footerHeight != 0 {
            let footerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                                                    with: IndexPath(row: collectionView.numberOfItems(inSection: 0), section: 0))

            footerAttributes.frame = CGRect.init(origin: CGPoint.init(x: 0, y: contentHeight),
                                           size: CGSize(width: contentWidth, height: footerHeight))
            cache.append(footerAttributes)
            contentHeight += footerHeight
        }
        
      }
      
      override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        // Loop through the cache and look for items in the rect
        for attributes in cache {
          if attributes.frame.intersects(rect) {
            visibleLayoutAttributes.append(attributes)
          }
        }
        return visibleLayoutAttributes
      }
      
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
      override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
      }
    }
