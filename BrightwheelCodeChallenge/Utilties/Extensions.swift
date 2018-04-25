//
//  Extensions.swift
//  BrightwheelCodeChallenge
//
//  Created by Alex Hoff on 4/23/18.
//  Copyright © 2018 Alex Hoff. All rights reserved.
//

import Foundation
import UIKit

extension URL {
    public static func buildUrlWithPath(_ path: String) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.github.com"
        urlComponents.path = path
        guard let url = urlComponents.url else { fatalError("Could not create URL") }
        return url
    }
    
    public static func buildUrlWithPath(_ path: String, _ queryItems: [URLQueryItem]) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.github.com"
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else { fatalError("Could not create URL") }
        return url
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    public static let gradientPink = UIColor(red:0.85, green:0.40, blue:0.55, alpha:1.0)
    public static let gradientPurple = UIColor(red:0.48, green:0.08, blue:0.42, alpha:1.0)
    
    struct Theme {
        static let cellBackground = UIColor(netHex: 0xF8F8F8)
        static let viewBackground = UIColor(netHex: 0x8EC0E0)
        static let titleColor = UIColor(netHex: 0x3972C0)
        static let infoColor = UIColor(netHex: 0xE94E69)
        static let navBarColor = UIColor(netHex: 0xF1B547)

    }
    
}

//fileprivate var request = [ApiContributorRequest]()
//class ContributorString {
//    var requests = [ApiContributorRequest]()
//    
//    static func getContributorWithUrl(_ urlString: String, completion: @escaping (String) -> Void) {
//        guard let url = URL(string: urlString) else { fatalError("Could not create URL") }
//        let apiRequest = ApiContributorRequest(url: url)
//        requests.append(apiRequest)
//        apiRequest.load { (contributor) in
//            guard let topContributor = contributor else { return }
//            
//            completion(topContributor.login)
//        }
//    }
//}
//extension String {
//    static func getContributorWithUrl(_ urlString: String, request: ApiContributorRequest, completion: @escaping (String) -> Void) {
//        guard let url = URL(string: urlString) else { fatalError("Could not create URL") }
//        let apiRequest = ApiContributorRequest(url: url)
//        request = apiRequest
//        apiRequest.load { (contributor) in
//            guard let topContributor = contributor else { return }
//            
//            completion(topContributor.login)
//        }
//    }
//}
