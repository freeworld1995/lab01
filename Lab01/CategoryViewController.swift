//
//  CategoryViewController.swift
//  Lab01
//
//  Created by Jimmy Hoang on 2/19/17.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import SwiftyJSON

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var transitionImage: UIImageView?
    var transitionLabel: String?
    let minimizeTransition = MinimizeTransition()
    let datasource = CategoryDataSource()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        //        let rect = UIView(frame: CGRect(x: 5, y: 5, width: 150, height: 130))
        //        rect.backgroundColor = UIColor.red
        navigationController?.delegate = self
        collectionView.rx.setDelegate(self).addDisposableTo(disposeBag)
        datasource.getData(collectionView: collectionView)
        
        collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "categoryCell")
        //        self.view.addSubview(rect)
        
        
        //        collectionView.rx.modelSelected(Category.self).subscribe(onNext: { (cell) in
        //            print("fuck")
        //        }, onError: { (error) in
        //            print(error)
        //        }, onCompleted: {
        //            print("completed touched cell")
        //        }).addDisposableTo(disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        if segue.identifier == "CategoryToListSong" {
        //            let vc = storyboard?.instantiateViewController(withIdentifier: "ListSongVC") as! ListSongViewController
        ////            vc.imageFromCategoryVC.image = transitionImage?.image
        //            vc.transitioningDelegate = self
        //        }
        
        if let vc = segue.destination as? ListSongViewController {
            vc.image = transitionImage
            vc.label = transitionLabel
        }
    }
    
}

extension CategoryViewController: UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return minimizeTransition
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width / 2 - 10, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CategoryCollectionViewCell
        transitionLabel = cell.categoryLabel.text
        transitionImage = cell.categoryImage
        let originalFrame = cell.categoryImage.superview!.convert(cell.categoryImage.frame, to: nil)
        var origin = originalFrame.origin
        var size = originalFrame.size

        minimizeTransition.setOriginalFrame(origin: &origin, size: &size)

        self.performSegue(withIdentifier: "CategoryToListSong", sender: nil)
        
        print("cell frame: \(cell.frame)")
        print("original frame: \(cell.categoryImage.superview?.convert(cell.categoryImage.frame, to: nil))")
    }
}

