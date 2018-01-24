//
//  HttpCLass.swift
//  SV Queuer
//
//  Created by Manuela on 23/01/18.
//  Copyright © 2018 Silicon Villas. All rights reserved.
//

import Foundation

class HttpClass {
    
    enum httpMethod: String {
        case POST
        case GET
    }
    
    static func httpRequest(url: String, httpMethod: httpMethod, httpBody: Any?)-> URLRequest {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = httpMethod.rawValue
        if let body = httpBody {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        }
        if let userk = UserDefaults.standard.string(forKey: "apiKey") {
            request.addValue(userk, forHTTPHeaderField: "X-Qer-Authorization")
        }
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        return request
    }
}
