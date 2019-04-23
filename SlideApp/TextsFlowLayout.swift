//
//  TextsFlowLayout.swift
//  Slide MessagesExtension
//
//  Created by Alek Matthiessen on 1/21/18.
//  Copyright © 2018 AA Tech. All rights reserved.
//

import UIKit

class TextsFlowLayout: UICollectionViewFlowLayout {
    
    private var numberOfColumns: Int = 4
    
    init(numberOfColumns: Int) {
        super.init()
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        
        self.numberOfColumns = numberOfColumns
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    override var itemSize: CGSize {
        get {
            if let collectionView = collectionView {
                let itemWidth: CGFloat = (collectionView.frame.width/CGFloat(self.numberOfColumns))
                //                let itemHeight: CGFloat =  (collectionView.frame.height/CGFloat(self.numberOfColumns))
                
                let itemHeight: CGFloat =  (itemWidth / 3)
                
                return CGSize(width: itemWidth, height: itemHeight)
            }
            
            // Default fallback
            return CGSize(width: 50, height: 50)
        }
        set {
            super.itemSize = newValue
        }
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        if let collectionView = collectionView {
            return collectionView.contentOffset
        }
        return CGPoint.zero
    }
}

