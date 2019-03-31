import Foundation
import Vapor

protocol AvailabilityCheckerProtocol {
  func checkProduct(id: UUID, quantity: Int) throws -> Future<ProductDetailsResponse>
  var req: Request? { get set }
}

class AvailabilityChecker: AvailabilityCheckerProtocol {
  var req: Request?
  let availabilityURL = URL(string: "http://localhost:8081/status")!
  
  func checkProduct(id: UUID, quantity: Int) throws -> Future<ProductDetailsResponse> {
    
    guard let request = req else {
      throw Abort(.internalServerError)
    }
    
    let apiURL = availabilityURL.appendingPathComponent(id.uuidString).appendingPathComponent(String(quantity))
    let dataStatus = try request.client().get(apiURL)
    
    return dataStatus.flatMap { status in
      return try status.content.decode(ProductDetailsResponse.self)
    }
  }
}

extension AvailabilityChecker: Service {}
