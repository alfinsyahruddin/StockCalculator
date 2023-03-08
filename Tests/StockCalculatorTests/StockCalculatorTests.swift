import XCTest
@testable import StockCalculator

final class StockCalculatorTests: XCTestCase {

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
            brokerFee: BrokerFee(buy: 0, sell: 0),
            limit: 3
         )
        
        
        let expectedProfitPerTick = [
            ProfitPerTick(price: 97, percentage: -3, value: -300),
            ProfitPerTick(price: 98, percentage: -2, value: -200),
            ProfitPerTick(price: 99, percentage: -1, value: -100),
            ProfitPerTick(price: 100, percentage: 0, value: 0),
            ProfitPerTick(price: 101, percentage: 1, value: 100),
            ProfitPerTick(price: 102, percentage: 2, value: 200),
            ProfitPerTick(price: 103, percentage: 3, value: 300),
        ]
        
        XCTAssertEqual(profitPerTick, expectedProfitPerTick)
    }
    
    
    func testCalculateProfitPerTickWithBrokerFee() throws {
        let sut = StockCalculator()
        
        let profitPerTick = sut.calculateProfitPerTick(
            price: 100,
            lot: 1,
            brokerFee: BrokerFee(buy: 0.15, sell: 0.25),
            limit: 3
         )
        
        
        let expectedProfitPerTick = [
            ProfitPerTick(price: 97, percentage: -3.39, value: -339),
            ProfitPerTick(price: 98, percentage: -2.39, value: -240),
            ProfitPerTick(price: 99, percentage: -1.4, value: -140),
            ProfitPerTick(price: 100, percentage: -0.4, value: -40),
            ProfitPerTick(price: 101, percentage: 0.6, value: 60),
            ProfitPerTick(price: 102, percentage: 1.59, value: 160),
            ProfitPerTick(price: 103, percentage: 2.59, value: 259),
        ]
        
        XCTAssertEqual(profitPerTick, expectedProfitPerTick)
    }
}

