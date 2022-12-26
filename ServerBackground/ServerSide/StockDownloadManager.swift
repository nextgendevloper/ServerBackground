//
//  Stock Manager.swift
//  Dummy Project
//
//  Created by zmobile on 15/12/22.
//

import Foundation
import UIKit
import IOS_CommonUtil

class StockDownloadManager {
    lazy var networkOperationQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "com.Designs.loadThumbnails_JD"
        queue.qualityOfService = .userInteractive
        return queue
    }()
 
    static var stockThumbnails = NSCache<NSString, UIImage>()
     static let shared = StockDownloadManager()
      init () {}
    
    
    static func fetchImage(url:String,index:IndexPath, autoDownload:Bool = false, completion:@escaping(UIImage?,SwiftError?,IndexPath?)->()) -> NetworkOperation?{
        //check image is availabel in cache or not
        if let cachedImage = stockThumbnails.object(forKey: url as NSString){
            print("return Cache Image\(cachedImage)")
            completion(cachedImage,nil,index)
            return nil
        }
        //else check is image already downloading in queue then makes its priority high
        
        else if let operation = StockDownloadManager.shared.operationInArray(url: url) {
            print("Increase the priority for \(url)")
                    operation.queuePriority = .veryHigh
            completion(nil,nil,index)
            return nil
        }
        
    else {
        //create operation
        let operation = NetworkOperation(url: url, indexPath: index)
        operation.start()
            operation.queuePriority = .high
        //if auto download is true add operation in queue to Download
            print("Create a new task for \(operation)")
        if autoDownload{
            self.shared.networkOperationQueue.addOperation(operation)
        }
        operation.downloadDataHandler = { data,error in
            if error == nil{  //check id error is nil
               //check for url and get image from url
                    let image = UIImage(data: data!)
                //add cache
                stockThumbnails.setObject(image!, forKey: url as NSString)
                completion(image,nil, index)
            }
            //if error is not nill return error message
            else{
                completion(nil,error,index)
            }
        }
        
            return operation
        }
       
    }
    
    
    func operationInArray(url:String)->NetworkOperation?{
        var array = [NetworkOperation]()
        for i in StockDownloadManager.shared.networkOperationQueue.operations{
        let j = i as! NetworkOperation
            if j.uRL == URL(string: url) {
                if (j.isExecuting == true && j.isFinished == false){
                    array.append(j)
                }
         }
       }
        return array.first
    }
    
    static func setPriority(for url:String , priority: Operation.QueuePriority){
        //else check is image already downloading in queue then makes its priority high
        
        if let operation = StockDownloadManager.shared.operationInArray(url: url) {
            print("Increase the priority for \(url)")
                    operation.queuePriority = priority
           
        }
    }
    
    
    // MARK: - Fetch categories
    
    static func fetchCategories(completion:@escaping(Bool)->())->Bool{
        let url = "https://aegisdemoserver.in/SEGAds/webservices/BackgroundSystem/RoundRobin/GetCategories.php?PackageName=com.coolapps.postermaker"
        let operation = NetworkOperation(url: url, indexPath: [0,0])
       operation.start()
        operation.downloadDataHandler = { data,error in
            let obj = StockDownloadManager.shared.nsdataToJSON(data: data!)
//            print("Json File Data",obj)
            if let newdata = obj?["data"] as? [[String:Any]] {
                print("new data" ,newdata)
                for array in newdata{
                    let model = StockCategoryModel()
                    model.downloadDate = getCurrentShortDate()
                    model.categoryName = array["DisplayCategoryName"] as! String
                    model.categroryThumbURL = array["CategoryThumb"] as! String
                    DBManager.shared.insertEntryInStockCategory(model: model)
                }
               completion(true)
            }
          

        }
      
       return true
    }
    // Convert from NSData to json object
     private func nsdataToJSON(data: Data) -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
    
//    // MARK: - FetchStocksForCategories
//    static func fetchStockForCategories(category:String)->Bool{
//       let categoryModel = DBManager.shared.fetchForStockCategory(for: category)
//        if let url = categoryModel?.categroryThumbURL{
//         let operation = NetworkOperation(url: url, indexPath: [0,0])
//        operation.start()
//         operation.downloadDataHandler = { data,error in
//             let obj = StockDownloadManager.shared.nsdataToJSON(data: data!)
// //            print("Json File Data",obj)
//             if let newdata = obj?["data"] as? [[String:Any]] {
//                 print("new data" ,newdata)
//                 for array in newdata{
//                     let model = StockCategoryModel()
//                     model.categoryName = array["DisplayCategoryName"] as! String
//                     model.categroryThumbURL = array["CategoryThumb"] as! String
//                     DBManager.shared.insertEntryInStockCategory(model: model)
//                 }
//
//             }
//          }
//        }
//        return true
//     }

    static func fetchStockForCategories(category:String,completion:@escaping(Bool)->())->Bool{
        //get url for category
         let url = "https://aegisdemoserver.in/SEGAds//webservices/BackgroundSystem/RoundRobin/GetBackgrounds.php?Category=Sunset&PackageName=com.coolapps.postermaker&PageNo=1"
        
        //get Category Model from categoryName
        let categoryModel = DBManager.shared.fetchForStockCategory(for: "Sunset")
        
        //get data and update database for category
         let operation = NetworkOperation(url: url, indexPath: [0,0])
        operation.start()
         operation.downloadDataHandler = { data,error in
             let obj = StockDownloadManager.shared.nsdataToJSON(data: data!)
 //            print("Json File Data",obj)
             if let newdata = obj?["hits"] as? [[String:Any]] {
                 print("new data" ,newdata)
//                 var fetchCompleted = false
                 for array in newdata{
                     let model = StockPhotosModel()
                     model.categoryId = categoryModel!.id
                     model.stockThumbURL = array["previewURL"] as! String
                     model.stockLargeURL = array["largeImageURL"] as! String
                     model.tags = array["tags"] as! String
                     model.thumbWidth = String(array["previewWidth"] as! Int64)
                     model.thumbHeight = String(array["previewHeight"] as! Int64)
                     DBManager.shared.insertEntryInStockPhotos(model: model)
                 }
                 DBManager.shared.updateCategoryStockAvilable(isFetch: true, at: categoryModel!.id)
                 completion(true)
             }
           
             
         }
        return true
     }
}

