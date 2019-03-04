import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
  
  let availabilityController = AvailabilityController(availabilityChecker: AvailabilityChecker())
  router.get("status", UUID.parameter, Int.parameter, use: availabilityController.checkAvailability)
}
