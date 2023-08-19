//
//  RequestStore.swift
//  PhotoBackerUpper
//
//  Created by Nick Rodriguez on 18/08/2023.
//

import Foundation

enum RequestStoreError: Error{
    case failedToProvideCredentials
    case failedToCodeCredentials
    
    var localizedDescription: String{
        switch self {
        case .failedToProvideCredentials: return "No credentials provided"
        case .failedToCodeCredentials: return "Credentials did not code into json"
        }
    }
}

enum APIBase:String, CaseIterable {
    case local = "localhost"
    case dev = "dev"
    case prod = "prod"
    var urlString:String {
        switch self{
        case .local: return "http://127.0.0.1:5001/"
        case .dev: return "https://dev.api.tu-rincon.com/"
        case .prod: return "https://api.tu-rincon.com/"
        }
    }
}

enum EndPoint: String {
    case are_we_running = "are_we_running"
    case register = "register"
    case login = "login"
    case create_directory = "create_directory"
}

class RequestStore {
    
    var user_token:String!
    
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    //MARK: for json writing/reading only
    let fileManager:FileManager
    private let documentsURL:URL
    init() {
        self.fileManager = FileManager.default
        self.documentsURL = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    
    /* Former:  URLStore Stuff */
    
    var apiBase:APIBase!

    private func callEndpoint(endPoint: EndPoint) -> URL{
        let baseURLString = apiBase.urlString + endPoint.rawValue
        let components = URLComponents(string:baseURLString)!
        return components.url!
    }
    private func callDirectoryEndpoint(endPoint: EndPoint, rincon_id: String) -> URL{
        let baseURLString = apiBase.urlString + endPoint.rawValue + "/\(rincon_id)"
        let components = URLComponents(string:baseURLString)!
        return components.url!
    }

    private func callApiQueryStrings(endPoint:EndPoint, queryStringArray:[String]) -> URL {
        var urlString = apiBase.urlString + endPoint.rawValue
        for queryString in queryStringArray {
            urlString = urlString + "/\(queryString)"
        }
        let components = URLComponents(string:urlString)!
        return components.url!
    }
    
    /*  Former:  URLStore Stuff --- End ----- */
    

    
    
    func createRequestWithBody(endPoint: EndPoint, dictBody:[String:String])->URLRequest? {
        print("- createRequestWithTokenAndBody")
        var jsonData = Data()
        let url = callEndpoint(endPoint: endPoint)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if endPoint == .login {
            guard let email = dictBody["email"],
                  let password = dictBody["password"] else {
                print(RequestStoreError.failedToProvideCredentials)
                return nil
            }
            let loginString = "\(email):\(password)"
            guard let loginData = loginString.data(using: String.Encoding.utf8) else {
                print(RequestStoreError.failedToCodeCredentials)
                return nil
            }
            let base64LoginString = loginData.base64EncodedString()
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
                    
        }else {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            do {
                jsonData = try encoder.encode(dictBody)
                request.httpBody = jsonData
            } catch {
                print("Failed to encode dict_body: \(error)")
                
            }
        }
        print("built request: \(request)")
        return request
    }
    
    func createRequestWithToken(endpoint:EndPoint) ->URLRequest{
        let url = callEndpoint(endPoint: endpoint)
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        request.setValue( user_token, forHTTPHeaderField: "x-access-token")
        return request
    }
    
    func createRequestWithTokenAndQueryString(endpoint: EndPoint, queryString:[String]) -> URLRequest{
        print("- createRequestWithTokenAndQueryString")

        let url = callApiQueryStrings(endPoint: endpoint, queryStringArray: queryString)
        print("url: \(url)")
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        request.setValue( user_token, forHTTPHeaderField: "x-access-token")
        
        return request
    }
    
    func createRequestWithTokenAndDirectoryAndQueryStringAndBody(endpoint: EndPoint, rincon_id:String, queryString:[String], bodyParamDict:[String:String]?) -> URLRequest{
        print("- createRequestWithTokenAndDirectoryAndQueryStringAndBody")
        var jsonData = Data()
//        var url = urlStore.callDirectoryEndpoint(endPoint: .rincon_posts, rincon_id: rincon_id)
        let url = callApiQueryStrings(endPoint: endpoint, queryStringArray: queryString)

        print("url: \(url)")
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
//        print("** DirectoryStore token \(self.token!)")
        request.setValue( user_token, forHTTPHeaderField: "x-access-token")
        
//        print("reques.header: \(request.allHTTPHeaderFields!)")
        if var unwrapped_bodyParamsDict = bodyParamDict{
            unwrapped_bodyParamsDict["ios_flag"] = "true"
            do {
                let jsonEncoder = JSONEncoder()
                jsonData = try jsonEncoder.encode(unwrapped_bodyParamsDict)
            } catch {
                print("- Failed to encode rincon_id ")
            }
            request.httpBody = jsonData
            return request
        }
        return request
    }
    
    func printCallBackToTerminal(){
        let url = callEndpoint(endPoint: .are_we_running)
        let task = self.session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    print(jsonResult)
                } catch {
                    print("Error: \(error)")
                }
            }
        }
        task.resume()
    }
    
    func createRequestWithTokenAndBody(endPoint: EndPoint, dictBody:[String:String])->URLRequest {
        print("- createRequestWithTokenAndBody")
        let url = callEndpoint(endPoint: endPoint)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue( user_token, forHTTPHeaderField: "x-access-token")

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        do {
            let jsonData = try encoder.encode(dictBody)
            request.httpBody = jsonData
        } catch {
            print("Failed to encode dict_body: \(error)")

        }
        print("built request: \(request)")
        return request
    }
    
    
}


