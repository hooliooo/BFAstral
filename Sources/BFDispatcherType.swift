//
//  BFDispatcherType.swift
//  BFAstral
//
//  Created by Julio Miguel Alorro on 3/9/18.
//  Copyright © 2018 Julio Alorro Software Development, Inc. All rights reserved.
//

import Foundation
import Astral
import BrightFutures

/**
 The BFDispatcherType type is a type of RequestDispatcher that uses BrightFutures to return a Future instance.
*/
public protocol BFDispatcherType: RequestDispatcher {

    /**
     The type that the Future will return on success.
    */
    associatedtype ResponseType
    /**
     The Error type that the Future will return on failure.
    */
    associatedtype ErrorType: Error

    /**
     Creates a URLSessionDataTask from the URLRequest and transforms the Data or Error from the completion handler
     into a ResponseType or ErrorType. Returns a Future with a ResponseType or ErrorType.
     - parameter request: The Request instance used to get the Future<ResponseType, ErrorType> instance.
    */
    func response(of request: Request) -> Future<ResponseType, ErrorType>

}
