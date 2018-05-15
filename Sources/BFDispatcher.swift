//
//  BFAstral
//  Copyright (c) 2018 Julio Miguel Alorro
//  Licensed under the MIT license. See LICENSE file
//

import Foundation
import Astral
import BrightFutures
import Result

public typealias HTTPRequestResult = (Result<Response, NetworkingError>) -> Void

/**
 The BFDispatcher is an implementation of a BFDispatcherType that returns a Future<Response, NetworkingError>
*/
open class BFDispatcher: AstralRequestDispatcher, BFDispatcherType {

    /**
     BFDispatcher is a type of RequestDispatcher that returns a Future<Response, NetworkingError> instance.
     It leverages BrightFutures as the abstraction over asynchronous programming
     - parameter strategy: The DataStrategy used to create the httpBody of the URLRequest.
       The RequestBuilder used is the BaseRequestBuilder. The default value is a JSONStrategy instance.
     - parameter isDebugMode: If true, will print out information related to the http network request. If false, prints nothing.
       Default value is true.
    */
    public init(strategy: DataStrategy = JSONStrategy(), isDebugMode: Bool = true) {
        super.init(builder: BaseRequestBuilder(strategy: strategy), isDebugMode: isDebugMode)
    }

    /**
     BFDispatcher is a type of RequestDispatcher that returns a Future<Response, NetworkingError> instance.
     It leverages BrightFutures as the abstraction over asynchronous programming.
     - parameter builder: The RequestBuilder used to create the URLRequest instance.
     - parameter isDebugMode: If true, will print out information related to the http network request.
    */
    public required init(builder: RequestBuilder, isDebugMode: Bool = true) {
        super.init(builder: builder, isDebugMode: isDebugMode)
    }

    /**
     Creates a URLSessionDataTask from the URLRequest and transforms the Data or Error from the completion handler
     into a Response or NetworkingError.

     Returns a Future with a Response or NetworkingError.
     - parameter request: The Request instance used to get the Future<Response, NetworkingError> instance.
    */
    open func response(of request: Request) -> Future<Response, NetworkingError> {

        self.tasks = self.tasks.filter {
            $0.state == URLSessionTask.State.running ||
            $0.state == URLSessionTask.State.suspended
        }

        let isDebugMode: Bool = self.isDebugMode
        let method: String = request.method.stringValue
        let urlRequest: URLRequest = self.urlRequest(of: request)
        let session: URLSession = self.session

        return Future(resolver: { [weak self] (callback: @escaping HTTPRequestResult) -> Void in

            let task: URLSessionDataTask = session.dataTask(with: urlRequest) {
                (data: Data?, response: URLResponse?, error: Error?) -> Void in
                // swiftlint:disable:previous closure_parameter_position

                if let error = error {

                    callback(
                        Result.failure(
                            NetworkingError.connection(error)
                        )
                    )

                } else if let data = data, let response = response as? HTTPURLResponse {

                    switch isDebugMode {
                        case true:
                            print("HTTP Method: \(method)")
                            print("Response: \(response)")

                        case false:
                            break
                    }

                    switch response.statusCode {
                        case 200...399:
                            callback(
                                Result.success(
                                    JSONResponse(httpResponse: response, data: data)
                                )
                            )

                        case 400...599:
                            callback(
                                Result.failure(
                                    NetworkingError.response(
                                        JSONResponse(httpResponse: response, data: data)
                                    )
                                )
                            )

                        default:
                            callback(
                                Result.failure(
                                    NetworkingError.unknownResponse(
                                        JSONResponse(httpResponse: response, data: data),
                                        "Unhandled status code: \(response.statusCode)"
                                    )
                                )
                            )
                    }
                } else {

                    callback(
                        Result.failure(
                            NetworkingError.unknown("Unknown error occured")
                        )
                    )

                }
            }

            task.resume()

            self?.add(task: task)
        })
    }

}
