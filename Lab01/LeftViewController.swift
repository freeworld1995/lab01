//
//  LeftViewController.swift
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


class LeftViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let datasource = LeftDataSource()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rx.setDelegate(self).addDisposableTo(disposeBag)
        datasource.setupDatasource(tableView: tableView)
        setupDidSelect()
    }
    
    func setupDidSelect() {
        tableView.rx.modelSelected(String.self).subscribe(onNext: { (model) in
            print(model)
        }, onError: { (error) in
            print(error)
        }, onCompleted: { 

        }).addDisposableTo(disposeBag)
    }

    
}

extension LeftViewController: UITableViewDelegate {
    
}
