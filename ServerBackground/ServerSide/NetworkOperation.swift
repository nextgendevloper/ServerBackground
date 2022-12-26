//
//  MyOpreation.swift
//  Dummy Project
//
//  Created by zmobile on 09/12/22.
//

import Foundation
import UIKit
import IOS_CommonUtil

typealias DownloadDataHandler = (_ data:Data?,_ error:SwiftError?) -> Void
typealias DownloadProgessHandler = (_ progress: Double?,_ indexPath:IndexPath) -> Void

class NetworkOperation : Operation {
    var downloadDataHandler: DownloadDataHandler?
    var downloadProgressHandler: DownloadProgessHandler?
    var observer : NSKeyValueObservation?
    var uRL:URL
    var indexPath:IndexPath
    var autoDismiss:Bool
       
    deinit {
        print("DeInit Operation")
        observer?.invalidate()
    }
    
    init (url: String,indexPath:IndexPath,autoDismiss:Bool = true) {
        self.uRL = URL(string: url)!
        self.indexPath = indexPath
        self.autoDismiss = autoDismiss
        super.init()
    }
    
    
        override var isAsynchronous: Bool {
            get {
                return  true
            }
        }
        private var _executing = false {
            willSet {
                willChangeValue(forKey: "isExecuting")
            }
            didSet {
                didChangeValue(forKey: "isExecuting")
            }
        }
        
        override var isExecuting: Bool {
            return _executing
        }
        
        private var _finished = false {
            willSet {
                willChangeValue(forKey: "isFinished")
            }
            
            didSet {
                didChangeValue(forKey: "isFinished")
            }
        }
        
        override var isFinished: Bool {
            return _finished
        }
        
        func executing(_ executing: Bool) {
            _executing = executing
        }
        
        func finish(_ finished: Bool) {
            _finished = finished
        }
        
      
    override func start() {
        guard isCancelled == false else {
            finish(true)
            return
        }
        self.executing(true)
        //Asynchronous logic (eg: n/w calls) with callback
        self.downloadFromUrl()
    }
       
        /*override func start() {
            if self.isCancelled {
                finish(true)
            }
           main()
        }*/
        
       
        
        func downloadFromUrl() {
            let newSession = URLSession.shared
            let downloadTask = newSession.dataTask(with: uRL) { [self] data, response, error in
                //handle when error not occured
                if (error != nil) {
                    //network error
                    downloadDataHandler?(nil, SwiftError.toast("Network Error"))
                }else if let url = data {
                        //pass data with no error
                        downloadDataHandler?(url,nil)
                }else{
                        //return data error
                    downloadDataHandler?(nil,SwiftError.toast("Data Error"))
                    
                }
                if autoDismiss{
                    finish(true)
                    executing(false)
                }
               
               
            }
            downloadTask.progress.totalUnitCount = 1
            observer = downloadTask.progress.observe(\.fractionCompleted) { [self] progress, _ in
                self.downloadProgressHandler?(progress.fractionCompleted, indexPath)
                 if progress.fractionCompleted == 100.0 {
                     observer?.invalidate()
                 }
            }


           // downloadTask.progress.fileOperationKind = .downloading
            downloadTask.resume()

        }
    func downloadFromUrlInJSON() {
        let newSession = URLSession.shared
        let downloadTask = newSession.dataTask(with: uRL) { [self] data, response, error in
            //handle when error not occured
            if (error != nil) {
                //network error
                downloadDataHandler?(nil, SwiftError.toast("Network Error"))
            }else if let url = data {
                    //pass data with no error
                    downloadDataHandler?(url,nil)
            }else{
                    //return data error
                downloadDataHandler?(nil,SwiftError.toast("Data Error"))
                
            }
            if autoDismiss{
                finish(true)
                executing(false)
            }
           
           
        }
     
     
        downloadTask.resume()

    }
        
    }
