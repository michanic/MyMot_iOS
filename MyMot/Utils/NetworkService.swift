//
//  NetworkManager.swift
//  MyMot
//
//  Created by Michail Solyanic on 02/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import Alamofire
import SwiftyJSON

class NetworkService {
    
    static let shared : NetworkService = NetworkService()
    
    func getJsonData(endpoint: Endpoint, result: ((JSON?, Error?) -> ())?) {
        //print(endpoint.url)
        Alamofire.request(endpoint.url, method: endpoint.method, parameters: nil, encoding: URLEncoding.default, headers: getHeaders()).apiResponse { (json, error) in
            result?(json, error)
        }
    }
    
    func getJsonData(url: URL, method: HTTPMethod, headers: HTTPHeaders, result: ((JSON?, Error?) -> ())?) {
        //print(endpoint.url)
        Alamofire.request(url, method: method, parameters: nil, encoding: URLEncoding.default, headers: headers).apiResponse { (json, error) in
            result?(json, error)
        }
    }
    
    func getHtmlData(url: URL, result: ((String?, Error?) -> ())?) {
        //print(url)
        Alamofire.request(url, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: nil).htmlResponse { (html, cookies, error) in
            if let cookies = cookies {
                for cookie in cookies {
                    if cookie.name == "_csrf_token" {
                        print(cookie.value)
                        ConfigStorage.saveCsrfToken(cookie.value)
                    }
                }
            }
            result?(html, error)
        }
    }
    
    private func getHeaders() -> HTTPHeaders? {
        if ConfigStorage.developerMode {
            return ["develop" : "true"]
        } else {
            return nil
        }
    }
}

extension DataRequest {
    
    func apiResponse(handler: @escaping (JSON?, Error?) -> Void) {
        response(queue: nil, responseSerializer: DataRequest.apiResponseSerializer()) { (result) in
            switch result.result {
            case .success(let json):
                handler(json, nil)
            case .failure(let error as NSError):
                handler(nil, error)
            }
        }
    }
    
    func htmlResponse(handler: @escaping (String?, [HTTPCookie]?, Error?) -> Void) {
        response(queue: nil, responseSerializer: DataRequest.apiResponseSerializer()) { (response) in
            var cookies: [HTTPCookie]?
            if let headerFields = response.response?.allHeaderFields as? [String: String], let URL = response.request?.url {
                cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: URL)
            }
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                handler(utf8Text, cookies, nil)
            } else {
                handler(nil, cookies, NSError.notValidLink)
            }
        }
    }
    
    private static func apiResponseSerializer() -> DataResponseSerializer<JSON> {
        
        return DataResponseSerializer { req, res, data, error in
            
            guard let _ = req, let res = res else {
                let reason = "error_no_connection"
                return .failure(NSError(domain: Bundle.main.bundleIdentifier!, code: 430, userInfo: [NSLocalizedDescriptionKey : reason]))
            }
            
            if let error = error {
                return .failure(error)
            }
            
            guard let data = data else {
                let reason = "error_no_serialized"
                return .failure(NSError(domain: Bundle.main.bundleIdentifier!, code: res.statusCode, userInfo: [NSLocalizedDescriptionKey : reason]))
            }
            
            if let error = parseErrors(for: res, data: data) {
                return .failure(error)
            } else {
                do {
                    let json = try JSON(data: data)
                    return .success(json)
                } catch {
                    if let jsonString = String(data: data, encoding: String.Encoding.utf8) {
                        return .success(JSON(parseJSON: jsonString))
                    }
                    return .success(JSON())
                }
            }
        }
    }
    
    private static func parseErrors(for res: HTTPURLResponse, data: Data?) -> NSError? {
        var reason: String?
        if let data = data, let json = try? JSON(data: data), let message = json.dictionary?["message"]?.string {
            reason = message
        }
        
        switch res.statusCode {
        case 400:
            let reason = reason ?? "error_bad_request"
            return NSError(domain: Bundle.main.bundleIdentifier!, code: res.statusCode, userInfo: [NSLocalizedDescriptionKey : reason])
        default:
            return nil
        }
    }
    
}
