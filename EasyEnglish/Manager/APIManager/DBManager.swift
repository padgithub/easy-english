//
//  DBManager.swift
//  EasyEnglish
//
//  Created by Anh Dũng on 8/5/19.
//  Copyright © 2019 Anh Dũng. All rights reserved.
//

import SwiftyJSON
import Alamofire

class DBManager: NSObject {
    override init() {
        super.init()
    }
    
    func checkDB(success: @escaping (Bool) -> Void ) {
        apiRequestShared.webServiceCall("https://easyapp-api.herokuapp.com/checkdbJP", params: nil, isShowLoader: true, method: .get, isHasHeader: true) { (response) in
            success(response.responeJson["status"].boolValue)
        }
    }
    
    func downloadDB(success: @escaping (Bool) -> Void) {
        let fileManager = FileManager.default
        let destinationSqliteURL = GroupManager.database
        
        Alamofire.request("https://easyapp-api.herokuapp.com/filedbJP").downloadProgress(closure : { (progress) in
            print(progress.fractionCompleted)
            
        }).responseData{ (response) in
            print(response)
            print(response.result.value!)
            print(response.result.description)
            
            if let data = response.result.value {
                let fileURL = destinationSqliteURL
                do {
                    if fileManager.fileExists(atPath: destinationSqliteURL.path) {
                        do {
                            try fileManager.removeItem(atPath: destinationSqliteURL.path)
                        } catch {
                            print("Could not clear temp folder: \(error)")
                        }
                    }
                    try data.write(to: fileURL)
                    print("Wirte data sucess")
                    success(true)
                } catch {
                    print("Something went wrong!")
                    success(false)
                }
                
            }else{
                success(false)
            }
        }
    }
    
    func report(playlistId: String, videoId: String, email: String, contents: String, success: @escaping (Bool) -> Void) {
       let url = "https://easyapp-api.herokuapp.com/addReportJP?playlistId=\(playlistId)&videoId=\(videoId)&email=\(email)&contents=\(contents)"
        apiRequestShared.webServiceCall(url, params: nil, isShowLoader: true, method: .get, isHasHeader: true) { (response) in
            success(response.responeJson["status"].boolValue)
        }
    }
    
}
