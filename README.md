# BFAstral
BFAstral is an extension to Astral that uses Futures/Promises to make http networking calls.

BFAstral makes use of the [BrightFutures](https://github.com/Thomvis/BrightFutures) library to flatten the asynchronous calls
associated with networking, making your code base as readable as possible.

[![CI Status](http://img.shields.io/travis/hooliooo/BFAstral.svg?style=flat)](https://travis-ci.org/hooliooo/BFAstral)
[![Version](https://img.shields.io/cocoapods/v/BFAstral.svg?style=flat)](http://cocoapods.org/pods/BFAstral)
[![License](https://img.shields.io/cocoapods/l/BFAstral.svg?style=flat)](http://cocoapods.org/pods/BFAstral)
[![Platform](https://img.shields.io/cocoapods/p/BFAstral.svg?style=flat)](http://cocoapods.org/pods/BFAstral)

## Requirements

BFAstral requires iOS 9.3 or higher and Swift 3.x

## Installation
### [CocoaPods](http://cocoapods.org/)

1. Add the following to your [Podfile](http://guides.cocoapods.org/using/the-podfile.html):

```ruby
pod 'BFAstral'
```
2. Integrate your dependencies using frameworks: add `use_frameworks!` to your Podfile.
3. Run `pod install`.

## A Simple Example
Here's an example using the [Pokemon API](http://pokeapi.co) and the implementations of RequestBuilder and BFDispatcher.

Feel free to build and customize your own implementations. Simply adopt the appropriate protocols.

```swift
struct PokeAPIConfiguration: RequestConfiguration {

    let scheme: URLScheme = URLScheme.http

    let host: String = "pokeapi.co"

    let basePathComponents: [String] = [
        "api",
        "v2"
    ]

    let baseHeaders: Set<Header> = [
        Header(key: Header.Field.contentType, value: Header.Value.mediaType(MediaType.applicationJSON))
    ]
}
```

```swift
struct PokemonRequest: Request {

    let id: Int

    let configuration: RequestConfiguration = PokeAPIConfiguration()

    let method: HTTPMethod = HTTPMethod.get

    let pathComponents: [String] = [
        "pokemon",
        "\(self.id)"
    ]

    let parameters: [String : Any] = [:]

    let headers: Set<Header> = []
}
```

```swift
let queue: DispatchQueue = DispatchQueue(label: "pokeapi", qos: DispatchQoS.utility, attributes: [DispatchQueue.Attributes.concurrent])

let request: Request = PokemonRequest(id: 1)
let dispatcher: BFDispatcher = BFDispatcher()

dispatcher.response(of: request)
    .onSuccess(queue.context) { (response: Response) -> Void in
    // let responseData: Data = response.data
    // Do something with data
    // or
    // let dictionary: [String: Any] = response.json.dictValue
    // Do something with dictionary
    }
    .onFailure(queue.context) { (error: NetworkingError) -> Void in
    // Handle the error
    }
    .onComplete(queue.context) { (result: Result<Data, NetworkingError>) -> Void in
    // Handle the completion of the network request
    // such as clean up of the UI
    }
```

