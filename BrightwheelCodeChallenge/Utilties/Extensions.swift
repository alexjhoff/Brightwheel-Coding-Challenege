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
    // Function to build github api url from string
    public static func buildUrlWithPath(_ path: String) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.github.com"
        urlComponents.path = path
        guard let url = urlComponents.url else { fatalError("Could not create URL") }
        return url
    }
    
    // Overloaded function to add query items
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
    
    // Function to convert hex into rgb
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    // Color theme for app taken off randomly generated colors from colormind.io
    struct Theme {
        static let cellBackground = UIColor(netHex: 0xF8F8F8)
        static let viewBackground = UIColor(netHex: 0x8EC0E0)
        static let titleColor = UIColor(netHex: 0x3972C0)
        static let infoColor = UIColor(netHex: 0xE94E69)
        static let navBarColor = UIColor(netHex: 0xF1B547)

    }
    
}
