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
            sellPrice: 1200,
            lot: 1,
            brokerFee: BrokerFee(buy: 0.15, sell: 0.25)
        )
        
        let expectedTradingReturn = TradingReturn(
            calculationResult: TradingReturn.CalculationResult(
                status: .profit,
                tradingReturn: 20_000,
                tradingReturnPercentage: 20,
                netTradingReturn: 19_550,
                netTradingReturnPercentage: 19.52,
                totalFee: 450,
                totalFeePercentage: 0.45
            ),
            buyDetail: TradingReturn.BuyDetail(
                lot: 1,
                buyPrice: 1000,
                buyFee: 150,
                buyFeePercentage: 0.15,
                buyValue: 100_000,
                totalPaid: 100_150
            ),
            sellDetail: TradingReturn.SellDetail(
                lot: 1,
                sellPrice: 1200,
                sellFee: 300,
                sellFeePercentage: 0.25,
                sellValue: 120_000,
                totalReceived: 119_700
            )
        )
        
        XCTAssertEqual(tradingReturn, expectedTradingReturn)
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
            lot: 1,
            brokerFee: BrokerFee(buy: 0, sell: 0)
         )
        
        XCTAssertEqual(profitPerTick.first?.percentage, 1)
    }
}

