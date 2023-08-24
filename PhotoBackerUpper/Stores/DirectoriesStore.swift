//
//  DirectoriesStore.swift
//  PhotoBackerUpper
//
//  Created by Nick Rodriguez on 18/08/2023.
//

import UIKit
import Alamofire

enum DirectoryStoreError: Error {
    case failedToCreateDirectory
    case failedToSendImage
    case failedToReceiveImage
    case failedToConvertDataToImage
    case failedToGetStuffFromServerAPI
    
    var localizedDescription: String {
        switch self {
        case .failedToCreateDirectory: return "Server unable to make new directory"
        case .failedToSendImage: return "Server did not RECEIVE the image sent"
        case .failedToReceiveImage: return "Server did not SEND Image"
        case .failedToConvertDataToImage: return "Data from server failed to convert to an image"
        default: return "failedToGetStuffFromServerAPI"
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
    
    func uploadImage(image: UIImage, uiimageName:String, withParameters params: [String: String],  completion: @escaping (Result<[String:String],Error>) -> Void) {

        let request = requestStore.createRequestSendImageAndTokenFour(endpoint: .receive_image, uiimage: image,uiimageName:uiimageName, dictString: params )
        
        let task = requestStore.session.dataTask(with: request!) { data, response, error in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let respSavedImage = try jsonDecoder.decode([String:String].self, from:data)
                    OperationQueue.main.addOperation {
                        completion(.success(respSavedImage))
                    }
                }
                catch {
                    print("Failed to make new direcotry")
                    OperationQueue.main.addOperation {
                        completion(.failure(DirectoryStoreError.failedToSendImage))
                    }
                }
            }
        }
        task.resume()
    }

    func receiveImageFilenamesArray(directory:Directory,completion:@escaping(Result<[String],Error>)->Void){
        let request = requestStore.createRequestWithTokenAndBody(endPoint: .get_dir_image_list, dictBody: ["directory_id":directory.id])
        let task = requestStore.session.dataTask(with: request) { data, response, error in
            if let unwp_data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let arryFilenames = try jsonDecoder.decode([String].self,from: unwp_data)
                    OperationQueue.main.addOperation {
                        completion(.success(arryFilenames))
                    }
                } catch{
                    OperationQueue.main.addOperation {
                        completion(.failure(DirectoryStoreError.failedToGetStuffFromServerAPI))
                    }
                }

            }
        }
        task.resume()
    }
    
    func receiveImage(directory:Directory,imageFilename:String, completion:@escaping(Result<UIImage,Error>)->Void){
        let request = requestStore.createRequestWithTokenAndBody(endPoint: .send_image, dictBody: ["directory_id":directory.id,"file_name":imageFilename])
        let task = requestStore.session.dataTask(with: request) { data, response, error in
//            let result = self.processImageRequest(data: data, error: error)
            if let unwp_data = data {
                OperationQueue.main.addOperation {
                    let uiimageResult = UIImage(data: unwp_data)
                    if let unwp_uiimageResult = uiimageResult{
                        completion(.success(unwp_uiimageResult))
                        print("--> Successfully downloaded image: \(imageFilename)")
                    } else {
                        completion(.failure(DirectoryStoreError.failedToConvertDataToImage))
                    }
                }
            }
            if let unwrapped_error = error{
                print("Error photo request: \(unwrapped_error)")
                completion(.failure(DirectoryStoreError.failedToReceiveImage))
            }
        }
        task.resume()
    }


    
}


