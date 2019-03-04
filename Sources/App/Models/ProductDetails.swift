import Foundation
import Vapor

enum ProductStatus: String, Codable {
  case available
  case unavailable
}

struct ProductDetails: Content {
  let id: UUID
  let quantity: Int
}

struct ProductDetailsResponse: Content {
  let quantity: Int
  let status: ProductStatus
}
