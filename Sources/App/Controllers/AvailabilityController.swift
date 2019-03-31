import Vapor
import Foundation

final class AvailabilityController {
  
  func checkAvailability(_ req: Request) throws -> Future<Response> {
    // Create instance of AvailabilityCheckerProtocol type
    var availabilityChecker = try req.make(AvailabilityCheckerProtocol.self)
    availabilityChecker.req = req
    
    let productID = try req.parameters.next(UUID.self)
    let quantity = try req.parameters.next(Int.self)
    
    do {
      return try availabilityChecker.checkProduct(id: productID, quantity: quantity).flatMap { details in
        return details.encode(status: (details.quantity >= quantity ? .ok : .notFound), for: req)
      }
    }
    catch {
      throw Abort(.badRequest, headers: [:], reason: error.localizedDescription)
    }
  }
}
