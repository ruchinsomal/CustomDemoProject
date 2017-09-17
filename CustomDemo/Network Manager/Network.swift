//
//  Network.swift
//  CustomDemo
//
//  Created by Ruchin Somal on 17/09/17.
//  Copyright © 2017 Ruchin Somal. All rights reserved.
//

import Foundation
import UIKit

func getRequest(_ urlStr: String, result: @escaping (R_JSON?, _ error: NSError?, _ statuscode: Int) -> ()) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    let esc_url = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    let url = URL(string:esc_url!)
    var request = URLRequest(url: url!)
    request.httpMethod = "GET"
    URLSession.shared.dataTask(with: url!, completionHandler: {
        (data, response, error) in
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        if(error != nil){
            result(nil, error as NSError?, 300)
        } else {
            let httpResponse = response as! HTTPURLResponse
                let jsonResponse = R_JSON(data:data!)
                result(jsonResponse, nil, httpResponse.statusCode)
        }
    }).resume()
}
