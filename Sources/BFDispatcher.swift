//
//  BFDispatcher.swift
//  BFAstral
//
//  Created by Julio Miguel Alorro on 3/9/18.
//  Copyright © 2018 Julio Alorro Software Development, Inc. All rights reserved.
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
     Creates a URLSessionDataTask from the URLRequest and transforms the Data or Error from the completion handler
     into a Response or NetworkingError. Returns a Future with a Response or NetworkingError.
     - parameter request: The Request instance used to get the Future<Response, NetworkingError> instance.
    */
    open func response(of request: Request) -> Future<Response, NetworkingError> {

        let runningTasks: [URLSessionTask] = self.tasks.filter { $0.state != URLSessionTask.State.running }
        self.removeTasks()

        runningTasks.forEach(self.add)

        let isDebugMode: Bool = self.isDebugMode
        let method: String = request.method.stringValue
        let urlRequest: URLRequest = self.urlRequest(of: request)

        return Future(resolver: { [weak self] (callback: @escaping HTTPRequestResult) -> Void in

            let task: URLSessionDataTask = BaseRequestDispatcher.session.dataTask(with: urlRequest) {
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
