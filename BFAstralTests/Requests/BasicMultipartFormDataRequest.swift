//
//  BasicMultipartFormDataRequest.swift
//  AstralTests
//
//  Created by Julio Alorro on 1/28/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Astral

struct BasicMultipartFormDataRequest: MultiPartFormDataRequest {

    let configuration: RequestConfiguration = MultiPartFormConfiguration()

    let method: HTTPMethod = .post

    let pathComponents: [String] = [
        "post"
    ]

    let parameters: Parameters = Parameters.dict([
        "this": "that",
        "what": "where",
        "why": "what"
    ])

    var headers: Set<Header> {
        return [
            Header(key: Header.Key.custom("Get-Request"), value: Header.Value.custom("Yes")),
            Header(key: Header.Key.contentType, value: Header.Value.mediaType(MediaType.multipartFormData(Astral.shared.boundary)))
        ]
    }

    let fileName: String = "Sample"

    let components: [MultiPartFormDataComponent] = [
        MultiPartFormDataComponent(
            name: "file1",
            fileName: "image1.png",
            contentType: "image/png",
            file: MultiPartFormDataComponent.File.data(Data())
        ),
        MultiPartFormDataComponent(
            name: "file2",
            fileName: "image2.png",
            contentType: "image/png",
            file: MultiPartFormDataComponent.File.data(Data())
        )
    ]
}
