//
//  BFAstral
//  Copyright (c) 2018 Julio Miguel Alorro
//  Licensed under the MIT license. See LICENSE file
//

import struct Foundation.URL
import struct Foundation.URLRequest
import class Foundation.URLSessionTask
import protocol Astral.Response
import enum Astral.NetworkingError
import class Astral.BaseRequestDispatcher
import protocol Astral.DataStrategy
import struct Astral.JSONStrategy
import struct Astral.BaseHTTPBodyRequestBuilder
import protocol Astral.RequestBuilder
import protocol Astral.Request
import struct Astral.JSONResponse
import class BrightFutures.Future

public typealias HTTPRequestResult = (Result<Response, NetworkingError>) -> Void

/**
 The BFDispatcher is an implementation of a BFDispatcherType that returns a Future<Response, NetworkingError>
*/
//open class BFDispatcher: AstralRequestDispatcher, BFDispatcherType {
open class BFDispatcher: BaseRequestDispatcher, BFDispatcherType {

    /**
     BFDispatcher is a type of RequestDispatcher that returns a Future<Response, NetworkingError> instance.
     It leverages BrightFutures as the abstraction over asynchronous programming
     - parameter strategy: The DataStrategy used to create the httpBody of the URLRequest.
       The RequestBuilder used is the BaseRequestBuilder. The default value is a JSONStrategy instance.
     - parameter isDebugMode: If true, will print out information related to the http network request. If false, prints nothing.
       Default value is true.
    */
    public init(strategy: DataStrategy = JSONStrategy(), isDebugMode: Bool = true) {
        super.init(builder: BaseHTTPBodyRequestBuilder(strategy: strategy), isDebugMode: isDebugMode)
    }

    /**
     Creates a URLSessionDataTask from the Request and transforms the Data or Error from the completion handler
     into a Response or NetworkingError, respectively.

     Returns a Future with a Response or NetworkingError.
     - parameter request: The Request instance used to get the Future<Response, NetworkingError> instance.
    */
    open func response(of request: Request) -> Future<Response, NetworkingError> {
        let urlRequest: URLRequest = self.builder.urlRequest(of: request)
        return self.response(of: urlRequest)
    }

    /**
     Creates a URLSessionDataTask from the URLRequest and transforms the Data or Error from the completion handler
     into a Response or NetworkingError, respectively.

     Returns a Future with a Response or NetworkingError.
     - parameter request: The URLRequest instance used to get the Future<Response, NetworkingError> instance.
    */
    open func response(of request: URLRequest) -> Future<Response, NetworkingError> {
        return Future(resolver: { [weak self] (callback: @escaping HTTPRequestResult) -> Void in
            self?.response(
                of: request,
                onComplete: { (result: Result<Response, NetworkingError>) -> Void in
                    switch result {
                        case .success(let response):
                            callback(
                                Result<Response, NetworkingError>.success(
                                    response
                                )
                            )
                        case .failure(let error):
                            callback(Result<Response, NetworkingError>.failure(error))
                    }
                }
            )
        })
    }

    /**
     Creates a URLSessionDataTask from the URL and transforms the Data or Error from the completion handler
     into a Response or NetworkingError, respectively.

     Returns a Future with a Response or NetworkingError.
     - parameter request: The URL instance used to get the Future<Response, NetworkingError> instance.
    */
    open func response(of url: URL) -> Future<Response, NetworkingError> {
        let urlRequest: URLRequest = URLRequest(url: url)
        return self.response(of: urlRequest)
    }

}
