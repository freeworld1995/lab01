//
//  LeftDataSource.swift
//  Lab01
//
//  Created by Jimmy Hoang on 2/24/17.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import SwiftyJSON

class LeftDataSource {
    var listViewController = Variable<[String]>(["Discovery", "Favorite", "Option"])
    let disposeBag = DisposeBag()
    
    func setupDatasource(tableView: UITableView) {
        listViewController.asObservable().bindTo(tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)
        ) { (row, data, cell) in
            cell.textLabel?.text = data
        }
    }
}
