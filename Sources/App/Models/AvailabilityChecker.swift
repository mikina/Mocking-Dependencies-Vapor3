import Foundation
import Vapor

protocol AvailabilityCheckerProtocol {
  func checkProduct(id: UUID, quantity: Int) throws -> ProductDetailsResponse
  var req: Request? { get set }
}

class AvailabilityChecker: AvailabilityCheckerProtocol {
  var req: Request?
  
  func checkProduct(id: UUID, quantity: Int) throws -> ProductDetailsResponse {
    
    let apiURL = URL(string: "http://localhost:8081/status")!.appendingPathComponent(id.uuidString).appendingPathComponent(String(quantity))
    let statusData = try req!.client().get(apiURL).wait()
    
    return try statusData.content.decode(ProductDetailsResponse.self).wait()
  }
}
