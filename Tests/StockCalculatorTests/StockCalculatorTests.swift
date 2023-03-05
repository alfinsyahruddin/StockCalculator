import XCTest
@testable import StockCalculator

final class StockCalculatorTests: XCTestCase {
    func testCalculatePercentage() throws {
        let sut = StockCalculator()
        
        let percentage = sut.calculatePercentage(
            buyPrice: 1000,
            sellPrice: 1500
        )
        
        XCTAssertEqual(percentage, 50)
    }
}
