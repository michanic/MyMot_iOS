//
//  NetworkManager.swift
//  MyMot
//
//  Created by Michail Solyanic on 02/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import Alamofire
import SwiftyJSON

class NetworkManager {

    static let shared : NetworkManager = NetworkManager()
    
    func getJsonData(endpoint: Endpoint, result: ((JSON?, Error?) -> ())?) {
        
        Alamofire.request(endpoint.url, method: endpoint.method, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (data) in
            
        }
        
    }
    
    
}
