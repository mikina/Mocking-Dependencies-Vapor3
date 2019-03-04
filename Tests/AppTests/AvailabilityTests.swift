import XCTest
@testable import Vapor
@testable import App

final class AvailabilityTests: XCTestCase {
  
  var app: Application?
  
  override func setUp() {
    super.setUp()
    
    app = try! Application.makeTest(routes: testRoutes)
  }
  
  override func tearDown() {
    super.tearDown()
    
    app = nil
  }
  
  private func testRoutes(_ router: Router) throws {
    let availabilityVC = AvailabilityController(availabilityChecker: AvailabilityCheckerMock())
    router.get("status", UUID.parameter, Int.parameter,
               use: availabilityVC.checkAvailability)
  }
  
  func testCheckProductAvailabilityWithSuccess() throws {
    
    let expectation = self.expectation(description: "Availability")
    var responseData: Response?
    var productDetails: ProductDetailsResponse?
    
    try app?.test(.GET, "/status/32AAEE05-C84C-4B6D-94F8-78648323807E/5") { response in
      responseData = response
      let decoder = JSONDecoder()
      productDetails = try decoder.decode(ProductDetailsResponse.self, from: response.http.body.data!)

      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
    
    XCTAssertEqual(responseData?.http.status, .ok)
    XCTAssertEqual(responseData?.http.contentType, MediaType.json)
    XCTAssertEqual(productDetails?.quantity, 10)
    XCTAssertEqual(productDetails?.status, .available)
  }
  
  func testCheckProductAvailabilityNotEnough() throws {
    
    let expectation = self.expectation(description: "Availability")
    var responseData: Response?
    var productDetails: ProductDetailsResponse?
    
    try app?.test(.GET, "/status/596CFCC7-63D8-4123-BF8B-2C598739DB53/51") { response in
      responseData = response
      let decoder = JSONDecoder()
      productDetails = try decoder.decode(ProductDetailsResponse.self, from: response.http.body.data!)
      
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
    
    XCTAssertEqual(responseData?.http.status, .notFound)
    XCTAssertEqual(responseData?.http.contentType, MediaType.json)
    XCTAssertEqual(productDetails?.quantity, 50)
    XCTAssertEqual(productDetails?.status, .unavailable)
  }
  
  func testCheckProductAvailabilityDontExists() throws {
    
    let expectation = self.expectation(description: "Availability")
    var responseData: Response?
    var productDetails: ProductDetailsResponse?
    
    try app?.test(.GET, "/status/B3ADB53A-1FB5-44A0-83CB-F518CA79C9DC/5") { response in
      responseData = response
      let decoder = JSONDecoder()
      productDetails = try decoder.decode(ProductDetailsResponse.self, from: response.http.body.data!)
      
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
    
    XCTAssertEqual(responseData?.http.status, .notFound)
    XCTAssertEqual(responseData?.http.contentType, MediaType.json)
    XCTAssertEqual(productDetails?.quantity, 0)
    XCTAssertEqual(productDetails?.status, .unavailable)
  }
}
