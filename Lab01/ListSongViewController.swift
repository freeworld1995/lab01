//
//  ListSongViewController.swift
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

class ListSongViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageFromCategoryVC: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var image: UIImageView?
    var label: String?
    
    let datasource = ListSongDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datasource.getSongs(tableView: tableView)
        tableView.register(UINib(nibName: "SongTableViewCell", bundle: nil), forCellReuseIdentifier: "SongTableViewCell")
        
        imageFromCategoryVC.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backToCategory)))
        imageFromCategoryVC.isUserInteractionEnabled = true
        
        navigationItem.title = "Discovery"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imageFromCategoryVC.image = image?.image
        categoryLabel.text = label
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }
    
    func backToCategory(gesture: UITapGestureRecognizer) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //    func setupNavBar() {
    //        self.na
    //    }
    
}

extension ListSongViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
