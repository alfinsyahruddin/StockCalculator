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
    
    func testCalculateTradingReturn() throws {
        let sut = StockCalculator()
        
        let tradingReturn = sut.calculateTradingReturn(
            buyPrice: 1000,
            sellPrice: 2000,
            quantity: 1,
            brokerFee: BrokerFee(buy: 0, sell: 0)
        )
        
        XCTAssertEqual(tradingReturn.calculationResult.status, .profit)
    }
    
    func testCalculateAutoRejects() throws {
        let sut = StockCalculator()
        
        let autoRejects = sut.calculateAutoRejects(
            closePrice: 100,
            type: .asymmetric,
            brokerFee: BrokerFee(buy: 0, sell: 0)
     )
        
        XCTAssertEqual(autoRejects.ara.first?.price, 135)
    }
    
    func testCalculateProfitPerTick() throws {
        let sut = StockCalculator()
        
        let profitPerTick = sut.calculateProfitPerTick(
            price: 100,
            quantity: 1,
            brokerFee: BrokerFee(buy: 0, sell: 0)
         )
        
        XCTAssertEqual(profitPerTick.first?.percentage, 1)
    }
}
