//
//  The MIT License (MIT)
//
//  Copyright (c) 2017 Srdan Rasic (@srdanrasic)
//  https://github.com/ReactiveKit/ReactiveAPI
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

public protocol RequestParameters {
    func apply(urlRequest: URLRequest) -> URLRequest
}

public struct FormParameters: RequestParameters, ExpressibleByDictionaryLiteral {
    public let data: [String: Any]

    public init(_ data: [String: Any]) {
        self.data = data
    }
    
    public init(dictionaryLiteral elements: (String, Any)...) {
        self.data = Dictionary(uniqueKeysWithValues: elements)
    }

    public func apply(urlRequest: URLRequest) -> URLRequest {
        var request = urlRequest
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = data.keyValuePairs.data(using: .utf8)
        return request
    }
}

public struct EncodableParameters: RequestParameters {
    public let jsonData: Data
    
    public init<T>(_ encodable: T) throws where T: Encodable {
        jsonData = try JSONEncoder().encode(encodable)
    }
    
    public func apply(urlRequest: URLRequest) -> URLRequest {
        var request = urlRequest
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        return request
    }
}

public struct JSONParameters: RequestParameters {

    public let json: Any

    public init(_ json: Any) {
        self.json = json
    }

    public func apply(urlRequest: URLRequest) -> URLRequest {
        var request = urlRequest
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let json = json as? [Any] {
            request.httpBody = json.jsonString.data(using: .utf8)
        } else if let json = json as? [String: Any] {
            request.httpBody = json.jsonString.data(using: .utf8)
        }

        return request
    }
}

public struct QueryParameters: RequestParameters, ExpressibleByArrayLiteral, ExpressibleByDictionaryLiteral {
    public let query: [URLQueryItem]

    public init(_ query: [String: String]) {
        self.query = query.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
    
    public init(_ queryItems: [URLQueryItem]) {
        self.query = queryItems
    }
    
    public init(arrayLiteral elements: URLQueryItem...) {
        self.query = elements
    }
    
    public init(dictionaryLiteral elements: (String, String)...) {
        self.query = elements.map(URLQueryItem.init)
    }

    public func apply(urlRequest: URLRequest) -> URLRequest {
        var request = urlRequest
        var urlComponents = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)!
        var items = urlComponents.queryItems ?? []
        items.append(contentsOf: query)
        urlComponents.queryItems = items
        request.url = urlComponents.url
        return request
    }
}

public struct RawBodyParameters: RequestParameters {
    public let data: Data?
    public let contentType: String
    
    public init(data: Data?, contentType: String) {
        self.data = data
        self.contentType = contentType
    }
    
    public func apply(urlRequest: URLRequest) -> URLRequest {
        var request = urlRequest
        request.setValue(self.contentType, forHTTPHeaderField: "Content-Type")
        request.httpBody = self.data
        return request
    }
}
