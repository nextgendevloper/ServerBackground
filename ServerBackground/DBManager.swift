//
//  DBManager.swift
//  CGDemo
//
//  Created by zmobile on 04/11/22.
//

import Foundation
import CoreGraphics
import IOS_CommonUtil

class DBManager : DBInterface{
  
static let shared: DBManager = DBManager()
    // MARK: - Enum of Table
    struct DBTableNames {
       static var StockCategory_Table = "StockCategoryTable"
       static var StockPhotos_Table = "StockPhotosTable"
        
    }
    
    // MARK: - Initializer
    override init() {
        super.init()
         dB_fileName = "Server_Background.sqlite"
      
        // assign path for database in local directory
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        self.db_local_path = documentsDirectory.appending("/\(dB_fileName)")
        if FileManager.default.fileExists(atPath: db_local_path) {
            database = FMDatabase(path: db_local_path)
            print("preset created",db_local_path)
        }
    }

// MARK: - Variables
    
    //Category Table
    let Stock_Category_Id = "Id"
    let Stock_Category_CategoryName = "CategoryName"
    let Stock_Category_CategroryThumbURL = "CategoryThumbURL"
    let Stock_Category_CategoryThumbDiskURL = "CategoryThumbDiskURL"
    let Stock_Category_isStockFetched = "IsStockFetched"
    let Stock_Category_downloadDate = "DownloadDdate"
    let Stock_Category_expiryDate = "ExpiryDate"
    let Stock_Category_FavouriteCategory = "FavouriteCategory"
    
    // Photo Table
    let Stock_Photo_Id = "Id"
    let Stock_Photo_CategoryId = "CategoryID"
    let Stock_Photo_StockThumbURL = "StockThumbURL"
    let Stock_Photo_StockThumbWidth = "StockThumbWidth"
    let Stock_Photo_StockThumbHeight = "StockThumbHeight"
    let Stock_Photo_StockThumbDiskURL = "StockThumbDiskURL"
    let Stock_Photo_StockLargeURL = "StockLargeURL"
    let Stock_Photo_StockLargeDiskURL = "StockLargeDiskURL"
    let Stock_Photo_StockIsFavourite = "StockIsFavourite"
    let Stock_Photo_StockIsRecent = "StockIsRecent"
    let Stock_Photo_Tags = "Tags"
// MARK: - Create Function

    func createDataBase()->Bool{
        var created = false
        if !FileManager.default.fileExists(atPath: db_local_path) {
            database = FMDatabase(path: db_local_path)
        
       
            let query = "create table \(DBTableNames.StockCategory_Table) (\(Stock_Category_Id) integer primary key autoincrement not null, \(Stock_Category_CategoryName) text not null,\(Stock_Category_CategroryThumbURL),\(Stock_Category_CategoryThumbDiskURL),\(Stock_Category_isStockFetched),\(Stock_Category_downloadDate),\(Stock_Category_expiryDate),\(Stock_Category_FavouriteCategory))"
            let query2 = "create table \(DBTableNames.StockPhotos_Table) (\(Stock_Photo_Id) integer primary key autoincrement not null, \(Stock_Photo_CategoryId), \(Stock_Photo_StockThumbURL),\(Stock_Photo_StockThumbWidth),\(Stock_Photo_StockThumbHeight), \(Stock_Photo_StockThumbDiskURL), \(Stock_Photo_StockLargeURL), \(Stock_Photo_StockLargeDiskURL), \(Stock_Photo_StockIsFavourite), \(Stock_Photo_StockIsRecent), \(Stock_Photo_Tags))"
    do {
        try updateQuery(query, values: nil)
        try updateQuery(query2, values: nil)
        print("true")
        created = true
     }
     catch {  print("Could not create table.")
         print(error.localizedDescription)
        
     }
        }
    
        return created
    }
    
  // MARK: - Insert Methods of Stock Category
    //Stock Category
    func insertEntryInStockCategory(model:StockCategoryModel)->Bool{
        var inserted = false
        let query = "insert into \(DBTableNames.StockCategory_Table) (\(Stock_Category_Id), \(Stock_Category_CategoryName),\(Stock_Category_CategroryThumbURL),\(Stock_Category_CategoryThumbDiskURL),\(Stock_Category_isStockFetched),\(Stock_Category_downloadDate),\(Stock_Category_expiryDate),\(Stock_Category_FavouriteCategory)) values (null, '\(model.categoryName)', '\(model.categroryThumbURL)', '\(model.categoryThumbDiskURL)', '\(model.isStockFetched)', '\(model.downloadDate)', '\(model.expiryDate)', '\(model.favouriteCategory)');"
    do {
        try insertNewEntry(query: query)
        print("true")
        inserted = true
     }
     catch {  print("Could not create table.")
         print(error.localizedDescription)

     }

    print("insertion is complete")
        return inserted
    }
    
    
    func insertEntryInStockCategory(models:[StockCategoryModel])->Bool{
        var inserted = false
        
        for model in models {
        let query = "insert into \(DBTableNames.StockCategory_Table) (\(Stock_Category_Id), \(Stock_Category_CategoryName),\(Stock_Category_CategroryThumbURL),\(Stock_Category_CategoryThumbDiskURL),\(Stock_Category_isStockFetched),\(Stock_Category_downloadDate),\(Stock_Category_expiryDate),\(Stock_Category_FavouriteCategory)) values (null, '\(model.categoryName)', '\(model.categroryThumbURL)', '\(model.categoryThumbDiskURL)', '\(model.isStockFetched)', '\(model.downloadDate)', '\(model.expiryDate)', '\(model.favouriteCategory)');"
    do {
        try insertNewEntry(query: query)
        print("true")
        inserted = true
     }
     catch {  print("Could not create table.")
         print(error.localizedDescription)

     }
        }

    print("insertion is complete")
        return inserted
    }
    
    
    
    
    
    
    
// MARK: - Inserting Method of Stock Photos
     
    func insertEntryInStockPhotos(model:StockPhotosModel)->Bool{
        var inserted = false
        let query = "insert into  \(DBTableNames.StockPhotos_Table) (\(Stock_Photo_Id), \(Stock_Photo_CategoryId), \(Stock_Photo_StockThumbURL),\(Stock_Photo_StockThumbWidth),\(Stock_Photo_StockThumbHeight), \(Stock_Photo_StockThumbDiskURL), \(Stock_Photo_StockLargeURL), \(Stock_Photo_StockLargeDiskURL), \(Stock_Photo_StockIsFavourite), \(Stock_Photo_StockIsRecent), \(Stock_Photo_Tags)) values (null, '\(model.categoryId)', '\(model.stockThumbURL)','\(model.thumbWidth)','\(model.thumbHeight)', '\(model.stockThumbDiskURL)', '\(model.stockLargeURL)', '\(model.stockLargeDiskURL)', '\(model.stockIsFavourite)', '\(model.stockIsRecent)', '\(model.tags)');"
    do {
        try insertNewEntry(query: query)
        print("true")
        inserted = true
     }
     catch {  print("Could not create table.")
         print(error.localizedDescription)

     }

    print("insertion is complete")
        return inserted
    }

    
    func insertEntryInStockPhotos(modelS:[StockPhotosModel])->Bool{
        var inserted = false
        for model in modelS{
        let query = "insert into  \(DBTableNames.StockPhotos_Table) (\(Stock_Photo_Id), \(Stock_Photo_CategoryId), \(Stock_Photo_StockThumbURL),\(Stock_Photo_StockThumbWidth),\(Stock_Photo_StockThumbHeight), \(Stock_Photo_StockThumbDiskURL), \(Stock_Photo_StockLargeURL), \(Stock_Photo_StockLargeDiskURL), \(Stock_Photo_StockIsFavourite), \(Stock_Photo_StockIsRecent), \(Stock_Photo_Tags)) values (null, '\(model.categoryId)', '\(model.stockThumbURL)', '\(model.thumbWidth)','\(model.thumbHeight)','\(model.stockThumbDiskURL)', '\(model.stockLargeURL)', '\(model.stockLargeDiskURL)', '\(model.stockIsFavourite)', '\(model.stockIsRecent)', '\(model.tags)');"
    do {
        try insertNewEntry(query: query)
        print("true")
        inserted = true
     }
     catch {  print("Could not create table.")
         print(error.localizedDescription)

     }

    print("insertion is complete")
        }
        return inserted
     
}

//    // MARK: - Fetching Methods OF Stock Category
    
    
    func fetchDataBaseStockCategory()->[StockCategoryModel]{
        var stockCategory:[StockCategoryModel]!
        let query = "select * from \(DBTableNames.StockCategory_Table)"

        do {
            let results = try runQuery(query, values: nil)
            while results.next() {
                let model = StockCategoryModel()
                model.id = Int(results.int(forColumn: Stock_Category_Id))
                model.categoryName = results.string(forColumn: Stock_Category_Id)
                model.categroryThumbURL = results.string(forColumn: Stock_Category_CategoryName)
                model.categoryThumbDiskURL = results.string(forColumn: Stock_Category_CategroryThumbURL)
                model.categoryThumbDiskURL = results.string(forColumn: Stock_Category_CategoryThumbDiskURL)
                model.isStockFetched = results.string(forColumn: Stock_Category_isStockFetched).toBool()!
                model.downloadDate = results.string(forColumn: Stock_Category_downloadDate)
                model.expiryDate = results.string(forColumn: Stock_Category_expiryDate)
                model.favouriteCategory = results.string(forColumn: Stock_Category_FavouriteCategory).toBool()!
                if stockCategory == nil {
                    stockCategory = [StockCategoryModel]()
                }

                stockCategory.append(model)
                print("data is fetch")
                      }
        }
        catch {
            print(error.localizedDescription)
        }

        return stockCategory
    }

//    func fetchIdsOfBGCategory()->[Int]{
//        let query = "Select \(BGCategory_ID) from \(DBTableNames.BGCategory_Table)"
//        var array = [Int]()
//        do {
//            let results = try runQuery(query, values: nil)
//
//            while results.next() {
//
//                array.append(Int(results.int(forColumn: BGCategory_ID)))
//
//
//            }
//        } catch {
//            print("failed to fetch templateInfo")
//        }
//        return array
//    }
////
    func fetchForStockCategory(for id : Int) -> StockCategoryModel? {
        let query = "Select * from \(DBTableNames.StockCategory_Table) where \(Stock_Category_Id) =?"

        do {
            let results = try runQuery(query, values: [id])

            if results.next() {

                var stockCategory = StockCategoryModel()
                stockCategory.id = Int(results.int(forColumn: Stock_Category_Id))
                stockCategory.categoryName = results.string(forColumn: Stock_Category_Id)
                stockCategory.categroryThumbURL = results.string(forColumn: Stock_Category_CategoryName)
                stockCategory.categoryThumbDiskURL = results.string(forColumn: Stock_Category_CategroryThumbURL)
                stockCategory.categoryThumbDiskURL = results.string(forColumn: Stock_Category_CategoryThumbDiskURL)
                stockCategory.isStockFetched = results.string(forColumn: Stock_Category_isStockFetched).toBool()!
                stockCategory.downloadDate = results.string(forColumn: Stock_Category_downloadDate)
                stockCategory.expiryDate = results.string(forColumn: Stock_Category_expiryDate)
                stockCategory.favouriteCategory = results.string(forColumn: Stock_Category_FavouriteCategory).toBool()!
                return stockCategory
            }
        } catch {
            print("failed to fetch templateInfo")
        }
        return nil
    }

    //
    func fetchForStockCategory(for name : String) -> StockCategoryModel? {
        let query = "Select * from \(DBTableNames.StockCategory_Table) where \(Stock_Category_CategoryName) =?"

        do {
            let results = try runQuery(query, values: [name])

            if results.next() {

                var stockCategory = StockCategoryModel()
                stockCategory.id = Int(results.int(forColumn: Stock_Category_Id))
                stockCategory.categoryName = results.string(forColumn: Stock_Category_Id)
                stockCategory.categroryThumbURL = results.string(forColumn: Stock_Category_CategoryName)
                stockCategory.categoryThumbDiskURL = results.string(forColumn: Stock_Category_CategroryThumbURL)
                stockCategory.isStockFetched = results.string(forColumn: Stock_Category_isStockFetched).toBool()!
                stockCategory.downloadDate = results.string(forColumn: Stock_Category_downloadDate)
                stockCategory.expiryDate = results.string(forColumn: Stock_Category_expiryDate)
                stockCategory.favouriteCategory = results.string(forColumn: Stock_Category_FavouriteCategory).toBool()!
                return stockCategory
            }
        } catch {
            print("failed to fetch templateInfo")
        }
        return nil
    }

// MARK: - Delete Stock Category
    func deleteAllCategories()->Bool{
        var deleted = false
//get array of Model of all Categories
       let arrayOfCategory = fetchDataBaseStockCategory()
        for item in arrayOfCategory {
            //get id
            let iD = item.id
            //get array of photo Model at category
            if let arrayOfPhoto = fetchDataBaseStockPhoto(categoryAt: iD){
            for photoModel in arrayOfPhoto{
                let photoId = photoModel.id
                //delete from local
                //delete from databse
                deleteStockPhoto(at: photoId)
            }
            }
            //delete from local
            //delete from database
            deleteStockCategory(at: iD)
            deleted = true
        }
        return deleted
    }
    
    func deleteStockCategory(at id:Int)->Bool{
        var deleted = false
        let query = "delete from \(DBTableNames.StockCategory_Table) where \(Stock_Category_Id)=?"
            do {
               try updateQuery(query, values: [id])
               deleted = true
            }
            catch {
                print("failed to deleteTemplate")
            }
            
        return deleted
    }
    
// MARK: - Update Stock Category
    func updateCategoryThumbDiskURL(url:String,at id:Int)->Bool{
        var update = false
        let query = "update \(DBTableNames.StockCategory_Table) set \(Stock_Category_CategoryThumbDiskURL) = '\(url)' where \(Stock_Category_Id) = \(id)"

        do {
            let results = try updateQuery(query, values: nil)
            
           update = true
           
        } catch {
            print("failed to Update")
        }
        return update
    }
    
    func updateCategoryStockAvilable(isFetch:Bool,at id:Int)->Bool{
        var isFetched = false
        let query = "update \(DBTableNames.StockCategory_Table) set \(Stock_Category_isStockFetched) = '\(isFetch)' where \(Stock_Category_Id) = \(id)"

        do {
            let results = try updateQuery(query, values: nil)
//            print(results.string(forColumn: Stock_Category_isStockFetched))
            isFetched = true
           
        } catch {
            print("failed to Update")
        }
        return isFetched
    }
    
    
     // MARK: - Fetch from Stock Photo
    
    func fetchDataBaseStockPhoto(categoryAt categoryId:Int)->[StockPhotosModel]?{
        var stockPhotosModel:[StockPhotosModel]!
        let query = "select * from \(DBTableNames.StockPhotos_Table) where \(Stock_Photo_CategoryId)= '\(categoryId)' "

        do {
            let results = try runQuery(query, values:nil)
            while results.next() {
                let stockPhoto = StockPhotosModel()
                stockPhoto.id = Int(results.int(forColumn: Stock_Category_Id))
                stockPhoto.categoryId = Int(results.int(forColumn: Stock_Photo_CategoryId))
                stockPhoto.stockThumbURL = results.string(forColumn: Stock_Photo_StockThumbURL)
                stockPhoto.stockThumbDiskURL = results.string(forColumn: Stock_Photo_StockThumbDiskURL)
                stockPhoto.stockLargeURL = results.string(forColumn: Stock_Photo_StockLargeURL)
                stockPhoto.stockLargeDiskURL = results.string(forColumn: Stock_Photo_StockLargeDiskURL)
                stockPhoto.stockIsFavourite = results.string(forColumn: Stock_Photo_StockIsFavourite).toBool()!
                stockPhoto.stockIsRecent = Int(results.int(forColumn: Stock_Photo_StockIsRecent))
                stockPhoto.tags = results.string(forColumn: Stock_Photo_Tags)
                if stockPhotosModel == nil {
                    stockPhotosModel = [StockPhotosModel]()
                }

                stockPhotosModel.append(stockPhoto)
                print("data is fetch")
                      }
        }
        catch {
            print(error.localizedDescription)
        }

        return stockPhotosModel
    }
    
    func fetchDataBaseStockPhoto(tag:String)->[StockPhotosModel]?{
        var stockPhotosModel:[StockPhotosModel]!
        let query = "select * from \(DBTableNames.StockPhotos_Table) where \(Stock_Photo_Tags)= '\(tag)' "

        do {
            let results = try runQuery(query, values:nil)
            while results.next() {
                let stockPhoto = StockPhotosModel()
                stockPhoto.id = Int(results.int(forColumn: Stock_Category_Id))
                stockPhoto.categoryId = Int(results.int(forColumn: Stock_Photo_CategoryId))
                stockPhoto.stockThumbURL = results.string(forColumn: Stock_Photo_StockThumbURL)
                stockPhoto.stockThumbDiskURL = results.string(forColumn: Stock_Photo_StockThumbDiskURL)
                stockPhoto.stockLargeURL = results.string(forColumn: Stock_Photo_StockLargeURL)
                stockPhoto.stockLargeDiskURL = results.string(forColumn: Stock_Photo_StockLargeDiskURL)
                stockPhoto.stockIsFavourite = results.string(forColumn: Stock_Photo_StockIsFavourite).toBool()!
                stockPhoto.stockIsRecent = Int(results.int(forColumn: Stock_Photo_StockIsRecent))
                stockPhoto.tags = results.string(forColumn: Stock_Photo_Tags)
                if stockPhotosModel == nil {
                    stockPhotosModel = [StockPhotosModel]()
                }

                stockPhotosModel.append(stockPhoto)
                print("data is fetch")
                      }
        }
        catch {
            print(error.localizedDescription)
        }

        return stockPhotosModel
    }
    
    func fetchForStockPhoto(for id : Int) -> StockPhotosModel? {
        let query = "Select * from \(DBTableNames.StockPhotos_Table) where \(Stock_Photo_Id) =?"

        do {
            let results = try runQuery(query, values: [id])

            if results.next() {

                var stockPhoto = StockPhotosModel()
                stockPhoto.id = Int(results.int(forColumn: Stock_Category_Id))
                stockPhoto.categoryId = Int(results.int(forColumn: Stock_Photo_CategoryId))
                stockPhoto.stockThumbURL = results.string(forColumn: Stock_Photo_StockThumbURL)
                stockPhoto.stockThumbDiskURL = results.string(forColumn: Stock_Photo_StockThumbDiskURL)
                stockPhoto.stockLargeURL = results.string(forColumn: Stock_Photo_StockLargeURL)
                stockPhoto.stockLargeDiskURL = results.string(forColumn: Stock_Photo_StockLargeDiskURL)
                stockPhoto.stockIsFavourite = results.string(forColumn: Stock_Photo_StockIsFavourite).toBool()!
                stockPhoto.stockIsRecent = Int(results.int(forColumn: Stock_Photo_StockIsRecent))
                stockPhoto.tags = results.string(forColumn: Stock_Photo_Tags)
                return stockPhoto
            }
        } catch {
            print("failed to fetch templateInfo")
        }
        return nil
    }
    
    // MARK: - Update From Stock Photo
    func updateStockPhotoThumbURL(url:String,at id:Int)->Bool{
        var updated = false
        let query = "update \(DBTableNames.StockPhotos_Table) set \(Stock_Photo_StockThumbURL) = '\(url)' where \(Stock_Photo_Id) = \(id)"

        do {
            let results = try updateQuery(query, values: nil)
            updated = true
           
        } catch {
            print("failed to Update Photo URL")
        }
        return updated
    }
    
    func updateStockPhotoThumbDiskURL(url:String,at id:Int)->Bool{
        var updated = false
        let query = "update \(DBTableNames.StockPhotos_Table) set \(Stock_Photo_StockThumbDiskURL) = '\(url)' where \(Stock_Photo_Id) = \(id)"

        do {
            let results = try updateQuery(query, values: nil)
            updated = true
           
        } catch {
            print("failed to Update Photo Disk URL")
        }
        return updated
    }
    
    func updateStockPhotoIsFavourite(isFav:Bool,at id:Int)->Bool{
        var updated = false
        let query = "update \(DBTableNames.StockPhotos_Table) set \(Stock_Photo_StockIsFavourite) = '\(isFav)' where \(Stock_Photo_Id) = \(id)"

        do {
            let results = try updateQuery(query, values: nil)
//            print(results.string(forColumn: Stock_Category_isStockFetched))
            updated = true
           
        } catch {
            print("failed to Update Is Fav")
        }
        return updated
    }
    
    // MARK: - Delete From Stock Photo
    func deleteStockPhoto(at id:Int)->Bool{
        var deleted = false
        let query = "delete from \(DBTableNames.StockPhotos_Table) where \(Stock_Category_Id)=?"
            do {
               try updateQuery(query, values: [id])
               deleted = true
            }
            catch {
                print("failed to deleteTemplate")
            }
            
        return deleted
    }
    //additional
    
    func getUrlArray(categoryId:Int)->[String]{
       
        var stockPhotosModel = [String]()
        let query = "select * from \(DBTableNames.StockPhotos_Table)"

        do {
            let results = try runQuery(query, values:nil)
            while results.next() {
                let stockPhoto = results.string(forColumn: Stock_Photo_StockThumbURL)!
               


                stockPhotosModel.append(stockPhoto)
                print("data is fetch")
                      }
        }
        catch {
            print(error.localizedDescription)
        }

        return stockPhotosModel
    }
    
    
}

// MARK: - Extension

extension DBManager {
    
    static func createCopyOfDatabaseIfNeeded()  {
         
         let bundlePath = Bundle.main.path(forResource: "Server_Background", ofType: ".db")
         let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
         let fileManager = FileManager.default
         let fullDestPath = URL(fileURLWithPath: destPath).appendingPathComponent("/Server_Background.sqlite")
         let fullDestPathString = fullDestPath.path
         if fileManager.fileExists(atPath: fullDestPathString){
             print(fileManager.fileExists(atPath: bundlePath!))
             
         }else{
             do{
                 try fileManager.copyItem(atPath: bundlePath!, toPath: fullDestPathString)
             }catch{
                 print(error)
             }
         }
     }
    
    
  
    
}

