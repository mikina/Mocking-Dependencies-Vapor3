import Vapor
import Foundation

final class AvailabilityController {
  
  var availabilityChecker: AvailabilityCheckerProtocol
  
  init(availabilityChecker: AvailabilityCheckerProtocol) {
    self.availabilityChecker = availabilityChecker
  }
  
  func checkAvailability(_ req: Request) throws -> Future<Response> {
    let promise = req.eventLoop.newPromise(Response.self)
    availabilityChecker.req = req
    
    let productID = try req.parameters.next(UUID.self)
    let quantity = try req.parameters.next(Int.self)
    
    DispatchQueue.global().async {
      do {
        let productDetails = try self.availabilityChecker.checkProduct(id: productID, quantity: quantity)
        
        _ = productDetails.encode(status: (productDetails.quantity >= quantity ? .ok : .notFound), for: req).map {
          promise.succeed(result: $0)
        }
      }
      catch {
        promise.fail(error: error)
      }
    }
    
    return promise.futureResult
  }
}
