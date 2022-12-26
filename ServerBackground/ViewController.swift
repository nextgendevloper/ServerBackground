//
//  ViewController.swift
//  ServerBackground
//
//  Created by zmobile on 07/12/22.
//

import UIKit
import IOSReusableCV

class ViewController: UIViewController {
    
     var arrayOfURL = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        _ = StockDownloadManager.fetchCategories { value in
            if value{
                StockDownloadManager.fetchStockForCategories(category: "hi") { [self] bool in
                    if bool{
                        DispatchQueue.main.async {
                            arrayOfURL = DBManager.shared.getUrlArray(categoryId: 1)
                              addChildVCWithMultiplier(collectionView, toView: self.view, aniamte: false, transitionType: .None, fadeEnable: false, heightMultiplier: 1)
                        }
                   
                    }
                }
            }
        }
       
        
    }
    
    lazy var collectionView : ReusableCV = {
        let customLayout = ReusableCVLayout(numberOfRow: 2, column: 3, and: .vertical)
           var myConfig = CVConfig(cellClass: CollectionViewCell(), cellIdentifier: "CollectionViewCell", reusableLayout: customLayout)
           return ReusableCV.createInstance(delegate: self, config: myConfig)
       }()
    
}

extension ViewController:ReusableCVDelegate{
    func numberOfSections(collectionview: UICollectionView) -> Int {
        return 1
    }
    
    func numberOfcells(collectionview: UICollectionView) -> Int {
        return arrayOfURL.count
    }
    
    func configure(_ cell: UICollectionViewCell, at indexPath: IndexPath, for collectionview: UICollectionView) {
        if let cell = cell as? CollectionViewCell{
            cell.configure()
        }
    }
    
    func didSelect(_ cell: UICollectionViewCell, at indexPath: IndexPath, for collectionview: UICollectionView) {
        print("cell",indexPath.item)
    }
    func willDisplay(_ cell: UICollectionViewCell, at indexPath: IndexPath, for collectionview: UICollectionView) {
        if let cell = cell as? CollectionViewCell{
          
            cell.willDisplay(url: arrayOfURL[indexPath.item], index: indexPath)
        }
    }
    func endDisplaying(_ cell: UICollectionViewCell, at indexpath: IndexPath, for collectionview: UICollectionView) {
        if let cell = cell as? CollectionViewCell{
            cell.endDisplaying(url: arrayOfURL[indexpath.item])
        }
    }
    
}
