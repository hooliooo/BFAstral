import XCTest
import BrightFutures
import Astral
@testable import BFAstral_iOS

class ResponseTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        super.tearDown()
    }

    func transform<U: Decodable>(response: Response) -> U {
        do {

            return try self.decoder.decode(U.self, from: response.data)

        } catch {
            XCTFail("Failed to get args or url")
            fatalError(error.localizedDescription)
        }
    }

    let decoder: JSONDecoder = JSONDecoder()

    func testHeaders() {
        let expectation: XCTestExpectation = self.expectation(description: "Post Request Query")

        let request: BasicGetRequest = BasicGetRequest()

        BFDispatcher().response(of: request)
            .map { [unowned self] (response: Response) -> GetResponse in

                do {

                    return try self.decoder.decode(GetResponse.self, from: response.data)

                } catch {
                    XCTFail("Failed to get args or url")
                    fatalError(error.localizedDescription)
                }

            }
            .onSuccess { (response: GetResponse) -> Void in

                let accept: Header = request.headers.filter { $0.key == .accept }.first!
                let contentType: Header = request.headers.filter { $0.key == .contentType }.first!
                let custom: Header = request.headers.filter { $0.key == Header.Key.custom("Get-Request") }.first!

                XCTAssertTrue(response.headers.accept == accept.value.stringValue)
                XCTAssertTrue(response.headers.contentType == contentType.value.stringValue)
                XCTAssertTrue(response.headers.custom == custom.value.stringValue)
                expectation.fulfill()
            }
            .onFailure { (error: NetworkingError) -> Void in
                XCTFail(error.localizedDescription)
            }

        self.waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testGetRequest() {

        let expectation: XCTestExpectation = self.expectation(description: "Get Request Query")

        let request: Request = BasicGetRequest()

        let dispatcher: BFDispatcher = BFDispatcher()

        dispatcher.response(of: request)
            .map { (response: Response) -> GetResponse in

                do {

                    return try self.decoder.decode(GetResponse.self, from: response.data)

                } catch {
                    XCTFail("Failed to get args or url")
                    fatalError(error.localizedDescription)
                }

            }
            .onSuccess { (response: GetResponse) -> Void in

                XCTAssertTrue(response.url == dispatcher.urlRequest(of: request).url!)

                switch request.parameters {
                    case .dict(let parameters):
                        XCTAssertTrue(response.args.this == parameters["this"]! as! String)
                        XCTAssertTrue(response.args.what == parameters["what"]! as! String)
                        XCTAssertTrue(response.args.why == parameters["why"]! as! String)

                    case .array, .none:
                        XCTFail()
                }

                expectation.fulfill()

            }
            .onFailure { (error: NetworkingError) -> Void in

                XCTFail(error.localizedDescription)

            }

        self.waitForExpectations(timeout: 5.0, handler: nil)

    }

    /**
     PUT and DELETE http methods produce identical results with POST request
    */
    func testPostRequest() {
        let expectation: XCTestExpectation = self.expectation(description: "Post Request Query")

        let request: Request = BasicPostRequest()

        let dispatcher: BFDispatcher = BFDispatcher()

        dispatcher.response(of: request)
            .map { (response: Response) -> PostResponse in
                do {

                    return try self.decoder.decode(PostResponse.self, from: response.data)

                } catch {
                    XCTFail("Failed to get json or url")
                    fatalError(error.localizedDescription)
                }
            }
            .onSuccess { (response: PostResponse) -> Void in
                XCTAssertTrue(response.url == dispatcher.urlRequest(of: request).url!)
                switch request.parameters {
                    case .dict(let parameters):
                        XCTAssertTrue(response.json.this == parameters["this"]! as! String)
                        XCTAssertTrue(response.json.what == parameters["what"]! as! String)
                        XCTAssertTrue(response.json.why == parameters["why"]! as! String)

                    case .array, .none:
                        XCTFail()
                }

                expectation.fulfill()
            }
            .onFailure { (error: NetworkingError) -> Void in
                XCTFail(error.localizedDescription)
            }

        self.waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testFormURLEncodedRequest() {
        let expectation: XCTestExpectation = self.expectation(description: "Post Request Query")

        let request: Request = FormURLEncodedPostRequest()

        let dispatcher: BFDispatcher = BFDispatcher(strategy:  FormURLEncodedStrategy())

        dispatcher.response(of: request)
            .map { (response: Response) -> FormURLEncodedResponse in
                do {

                    return try self.decoder.decode(FormURLEncodedResponse.self, from: response.data)

                } catch {
                    XCTFail("Failed to get form or url")
                    fatalError(error.localizedDescription)
                }
            }
            .onSuccess { (response: FormURLEncodedResponse) -> Void in

                XCTAssertTrue(response.url == dispatcher.urlRequest(of: request).url!)

                switch request.parameters {
                    case .dict(let parameters):
                        XCTAssertTrue(response.form.this == parameters["this"]! as! String)
                        XCTAssertTrue(response.form.what == parameters["what"]! as! String)
                        XCTAssertTrue(response.form.why == parameters["why"]! as! String)

                    case .array, .none:
                        XCTFail()
                }


                expectation.fulfill()
            }
            .onFailure { (error: NetworkingError) -> Void in
                XCTFail(error.localizedDescription)
            }

        self.waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testMultiPartFormDataRequest() {

        let expectation: XCTestExpectation = self.expectation(description: "Post Request Query")

        let request: MultiPartFormDataRequest = BasicMultipartFormDataRequest()

        let dispatcher: BFDispatcher = BFDispatcher(
            strategy: MultiPartFormDataStrategy()
        )

        dispatcher.response(of: request)
            .map { (response: Response) -> MultipartFormDataResponse in
                do {

                    return try self.decoder.decode(MultipartFormDataResponse.self, from: response.data)

                } catch {
                    XCTFail("Failed to get form or url")
                    fatalError(error.localizedDescription)
                }
            }
            .onSuccess { (response: MultipartFormDataResponse) -> Void in
                XCTAssertTrue(response.url == dispatcher.urlRequest(of: request).url!)

                switch request.parameters {
                    case .dict(let parameters):
                        XCTAssertTrue(response.form.this == parameters["this"]! as! String)
                        XCTAssertTrue(response.form.what == parameters["what"]! as! String)
                        XCTAssertTrue(response.form.why == parameters["why"]! as! String)

                    case .array, .none:
                        XCTFail()
                }

                XCTAssertFalse(response.files.isEmpty)
                expectation.fulfill()
            }
            .onFailure { (error: NetworkingError) -> Void in
                XCTFail(error.localizedDescription)
            }

        self.waitForExpectations(timeout: 5.0, handler: nil)

    }

}
