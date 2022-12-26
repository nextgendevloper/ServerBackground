//
//  DBInterface.swift
//  AddWatermark
//
//  Created by zmobile on 22/02/22.
//

import UIKit
import IOS_CommonUtil

public class DBInterface : NSObject {
    
    enum QueryType {
        case insert
        case update
    }
    
    var database: FMDatabase!
    var dB_fileName : String = "LogoMaker_Local.sqlite"
    var db_local_path : String
    
    /// opens up and tell db is open or not
    var dbIsOpen : Bool {
        return database.open()
    }
    
    /// manage current Database version - you can Set and Get
    var dBVersion : Int {
        get {
            return getDbVersion()
        }
        set {
            setDbVersion(Double(newValue))
        }
    }
    
    
    // MARK: - INITIALISATION
    override init() {
       
        // assign path for database in local directory
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        self.db_local_path = documentsDirectory.appending("/\(dB_fileName)")
        if FileManager.default.fileExists(atPath: db_local_path) {
            database = FMDatabase(path: db_local_path)
        }
        super.init()
    }
    /// assigns path for database in local directory

     init(path:URL) {
      
         self.db_local_path =   path.appendingPathComponent(dB_fileName).path
         if FileManager.default.fileExists(atPath: db_local_path) {
             self.database = FMDatabase(path: db_local_path)
           
         }
         super.init()
    }
    

    
   

    
    // MARK: - PRIVATE METHODS
    
    
    
    
   private func getDbVersion()->Int {
        if dbIsOpen {
            let query = "PRAGMA user_version"
          
            
                do {
                    let results = try runQuery(query, values: nil)
                        if results.next() {
                            return Int(results.int(forColumn: "user_version"))
                        } else {
                            print("db user_version",database.lastError() ?? "")
                            return 0
                        }
                    } catch   {
                       if  let err = error as? SwiftError {
                           print("db user_version",err.info.title ?? "")
                            return 0
                        }
                    }
                    
               }
        return 0
       
    }
    
  private  func setDbVersion(_ version: Double)  {
        if dbIsOpen {
             let query = "PRAGMA user_version = \(version)"
            
            do {
                try updateQuery(query, values: nil)
                    print("success  !! new DBVersion : ", version)
            }
            catch {
                print("error user_version")
            }
        }
       
    }
    
    
    
    // MARK: - PUBLIC METHODS
    
    /// runs given query and return array of result in FMResultSet
    func runQuery(_ query : String , values : [Any]!) throws -> FMResultSet {
        if dbIsOpen {
        do {
           return try database.executeQuery(query, values: values)
        }
        catch {
            throw SwiftError.toast("Execute Query Failed - ")
        }
        }else{
        throw SwiftError.toast("Execute Query Failed - ")
        }
    }
    
    /// runs given query and return array of result in FMResultSet
    func updateMultipleQuery(_ queries : [String] , arrayOfValues : [[Any]?]) throws {
        if dbIsOpen {
        do {
            for index in 0...queries.count - 1 {
                 try database.executeUpdate(queries[index], values: arrayOfValues[index])
            }
            
        }
        catch {
            throw SwiftError.toast("Execute Multiple Query Failed - ")
        }
        }
    }
    
    /// runs given query and return array of result in FMResultSet
    func updateQuery(_ query : String , values : [Any]!) throws  {
        if dbIsOpen {
        do {
           return try database.executeUpdate(query, values: values)
        }
        catch {
            throw SwiftError.toast("Update Query Failed - ")
        }
        }
        
    }
    
    
    /// intserts new entry to database and return newly generated row ID
    func insertNewEntry(query : String)->Int {
        if dbIsOpen {
            if database.executeStatements(query) {
                return Int(database.lastInsertRowId())
            }
           
        }
        return 0
    }
    /// intserts new entry to database and return newly generated row ID
    func insertMultipleNewEntry(queries : [String])->Bool {
        if dbIsOpen {
            for query in queries {
               let didSuccedd =  database.executeStatements(query)
                if !didSuccedd {
                    return false
                }
            }
            return true
        }
        return false
    }
    
 
    
    
    
    func buildInsertQueryFor(tableName : String , tableColumnNames : String , tableColoumnValues : String ) -> String {
            return "insert into \(tableName) (\(tableColumnNames)) values (\(tableColoumnValues));"
    }
    
    
   
    
}

