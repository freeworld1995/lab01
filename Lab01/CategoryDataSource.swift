//
//  CategoryDataSource.swift
//  Lab01
//
//  Created by Jimmy Hoang on 2/21/17.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import SwiftyJSON
import ReachabilitySwift

class CategoryDataSource {
    let disposeBag = DisposeBag()
    var list = Variable<[Category]>([])
    
    let index: [Int] = [2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 14, 15, 16, 17, 18, 19 , 20, 21, 22, 24, 34, 50, 51]
    
    func getData(collectionView: UICollectionView) {
        
        list.value = Services.getCategoryImageURLs(index: index)
        
        self.list.asObservable().bindTo(collectionView.rx.items(cellIdentifier: "categoryCell", cellType: CategoryCollectionViewCell.self)
        ) { (item, category, cell) in
            cell.tag = self.index[item]
            cell.loadImage(url: category.title)
            
            }.addDisposableTo(self.disposeBag)
        
    }
}
