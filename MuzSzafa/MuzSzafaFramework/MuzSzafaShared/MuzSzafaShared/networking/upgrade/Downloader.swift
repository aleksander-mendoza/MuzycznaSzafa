//
//  Downloader.swift
//  MuzSzafaShared
//
//  Created by Alagris on 02/07/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation

open class Downloader {
    open class func load(url: URL, to localUrl: URL, completion: @escaping () throws -> ()) rethrows{
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.downloadTask(with: request) {
            (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Success: \(statusCode)")
                }
                
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: localUrl)
                    try completion()
                } catch (let writeError) {
                    print("error writing file \(localUrl) : \(writeError)")
                }
                
            } else {
                print("Failure: %@", error.debugDescription );
            }
        }
        task.resume()
    }
}

