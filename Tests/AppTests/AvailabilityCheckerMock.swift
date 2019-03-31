import XCTest
@testable import Vapor
@testable import App

class AvailabilityCheckerMock: AvailabilityCheckerProtocol {
  var req: Request?
  
  private let products = [
    ProductDetails(id: UUID(uuidString: "32AAEE05-C84C-4B6D-94F8-78648323807E")!, quantity: 10),
    ProductDetails(id: UUID(uuidString: "596CFCC7-63D8-4123-BF8B-2C598739DB53")!, quantity: 50)
  ]
  
  func checkProduct(id: UUID, quantity: Int) throws -> Future<ProductDetailsResponse> {
    
    guard let request = req else {
      throw Abort(.internalServerError)
    }

    guard let product = products.filter({$0.id == id}).first else {
      return request.eventLoop.newSucceededFuture(result: ProductDetailsResponse(quantity: 0, status: .unavailable))
    }
    
    guard product.quantity >= quantity else {
      return request.eventLoop.newSucceededFuture(result: ProductDetailsResponse(quantity: product.quantity, status: .unavailable))
    }
    
    return request.eventLoop.newSucceededFuture(result: ProductDetailsResponse(quantity: product.quantity, status: .available))
  }
}

extension AvailabilityCheckerMock: Service {}
