//
//  CollectionViewCell.swift
//  Dummy Project
//
//  Created by zmobile on 16/12/22.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var loader : UIActivityIndicatorView!
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var percentage : UILabel!
    @IBOutlet weak var loaderView:CircularProgressBarView!

    var currentCellIndexPath:IndexPath = [0,0]
    var currentURL : String?
    var operation : NetworkOperation?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      //  operation = nil
        imageView.image = nil
        percentage.text = ""
    }
    func configure(){
        //loader show true
        self.loaderView.isHidden = false
        //image View hidden true
        self.imageView.isHidden = true
//        if let currentURL = currentURL {
//            StockDownloadManager.setPriority(for: currentURL, priority: .veryHigh)
//        }

    }
    func willDisplay(url:String,index:IndexPath){
        //set indexPath
        currentCellIndexPath = index
        currentURL = url
        // fetchImage at url
       

        operation = StockDownloadManager.fetchImage(url: url, index: index) { [self] image, error,index  in
            //if image is get than check current indepath ==  Indexpath
            if currentCellIndexPath == index{
               if let img = image{
                   DispatchQueue.main.async {
                       self.loaderView.isHidden = true
                       self.imageView.isHidden = false
                       self.imageView.image = img
                   }
                   
               }
            }
               if let error = error{
                   print(error)
               }
           }
      
       
        //hide loader , show imageView and Image
        //if error print Swift error
        
    
    
        
        operation?.downloadProgressHandler = { [self] val , newPath in
            if currentCellIndexPath == newPath {
 
                print("Progress at cell \(currentCellIndexPath.item): ", val)
            DispatchQueue.main.async {
//                self.percentage.text = "\(Int(value ?? .zero)) %"
                self.loaderView.circleValue = val!
                self.loaderView.circleLayer.layoutIfNeeded()
                self.loaderView.progressLayer.layoutIfNeeded()
                self.loaderView.setNeedsDisplay()
            }
            }
        }
    }
 
    func endDisplaying(url:String){
        //call fetch image at low prority
        StockDownloadManager.setPriority(for: url, priority: .low)
    }
    
}
