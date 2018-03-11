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

public protocol BFDispatcherType: RequestDispatcher {

        /**
         Creates a URLSessionDataTask from the URLRequest and transforms the Data or Error from the completion handler
         into a Response or NetworkingError. Returns a Future with a Response or NetworkingError.
         - parameter request: The Request instance used to get the Future<Response, NetworkingError> instance.
        */
        func response(of request: Request) -> Future<Response, NetworkingError>

}
