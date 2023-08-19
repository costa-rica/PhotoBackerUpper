//
//  DirectoriesStore.swift
//  PhotoBackerUpper
//
//  Created by Nick Rodriguez on 18/08/2023.
//

import Foundation

enum DirectoryStoreError: Error {
    case failedToCreateDirectory
    
    var localizedDescription: String {
        switch self {
        case .failedToCreateDirectory: return "Server unable to make new directory"
        }
    }
}

class DirectoryStore {
    var requestStore:RequestStore!
    
    func createDirectory(directoryName:String,is_public: Bool, completion:@escaping(Result<Directory,Error>)->Void){
        let request = requestStore.createRequestWithTokenAndBody(endPoint: .create_directory, dictBody: ["new_dir_name":directoryName])
        let task = requestStore.session.dataTask(with: request){ data, response, error in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let new_dir = try jsonDecoder.decode(Directory.self, from:data)
                    OperationQueue.main.addOperation {
                        completion(.success(new_dir))
                    }
                }
                catch {
                    print("Failed to make new direcotry")
                    OperationQueue.main.addOperation {
                        completion(.failure(DirectoryStoreError.failedToCreateDirectory))
                    }
                }
            }
        }
        task.resume()
    }
}


