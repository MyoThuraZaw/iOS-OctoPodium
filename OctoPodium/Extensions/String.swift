//
//  String.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 01/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Foundation

extension String {
    func urlEncoded() -> String {
        let charSet = CharacterSet.urlQueryAllowed
        return self.addingPercentEncoding(withAllowedCharacters: charSet)!
    }
    
    func base64Encoded() -> String {
        let data: Foundation.Data = self.data(using: String.Encoding.ascii)!
        return data.base64EncodedString(options: Foundation.Data.Base64EncodingOptions.lineLength64Characters)
//        return data.base64EncodedString(options: .encoding64CharacterLineLength)
    }

    func withoutSpaces() -> String {
        return replace(" ", with: "")
            .replace("\n", with: "")
    }
    
    func replace(_ str: String, with w: String) -> String {
        return replacingOccurrences(of: str, with: w)
    }
    
    func substringBetween(_ from: String, and to: String) -> String? {
        guard let range = self.range(of: "(?<=\(from))(.*?)(?=\(to))", options: .regularExpression) else { return nil }
        return String(self[range])
    }

    func substringUntil(_ until: String) -> String? {
        guard let range = self.range(of: until) else { return nil }
        return String(self[..<range.lowerBound])
    }

    func substring(after: String) -> String? {
        guard let range = self.range(of: after) else { return nil }
        return String(self[range.upperBound...])
    }

    /** Joins two strings with a separator charecter. If at least one of them is nil, the seperator character is not added. */
     /// * join(" | ", "hello", "world") produces "hello | world"
     /// * join(" | ", "hello", nil) produces "hello"
     /// * join(" | ", nil, "world") produces "world"
     /// * join(" | ", nil, nil) produces ""
    static func join(_ separator: String, _ str1: String?, _ str2: String?) -> String {
        if (str1 != nil && !str1!.isEmpty && str2 != nil && !str2!.isEmpty) {
            return "\(str1!)\(separator)\(str2!)"
        }
        if (str1 != nil) { return str1! }
        if (str2 != nil) { return str2! }
        
        return ""
    }
}
