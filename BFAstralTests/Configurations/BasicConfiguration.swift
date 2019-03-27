//
//  BasicConfiguration.swift
//  Astral
//
//  Created by Julio Alorro on 1/27/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Astral

struct BasicConfiguration: RequestConfiguration {

    let scheme: URLScheme = URLScheme.https

    let host: String = "httpbin.org"

    let basePathComponents: [String] = []

    let baseHeaders: Set<Header> = [
        Header(key: Header.Key.contentType, value: Header.Value.mediaType(MediaType.applicationJSON)),
        Header(key: Header.Key.accept, value: Header.Value.mediaType(MediaType.applicationJSON))
    ]
}
