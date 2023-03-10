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
    
    func testCalculateAutoRejectsAsymmetric() throws {
        let sut = StockCalculator()
        
        let autoRejects = sut.calculateAutoRejects(
            price: 100,
            type: .asymmetric,
            limit: 3
         )
        
        let expectedAutoRejects = AutoRejects(
            ara: [
                AutoReject(price: 135, priceChange: 35, percentage: 35, totalPercentage: 35),
                AutoReject(price: 182, priceChange: 47, percentage: 34.81, totalPercentage: 82),
                AutoReject(price: 244, priceChange: 62, percentage: 34.07, totalPercentage: 144)
            ],
            arb: [
                AutoReject(price: 93, priceChange: -7, percentage: -7, totalPercentage: -7),
                AutoReject(price: 87, priceChange: -6, percentage: -6.45, totalPercentage: -13),
                AutoReject(price: 81, priceChange: -6, percentage: -6.9, totalPercentage: -19)
            ]
        )
        
        XCTAssertEqual(autoRejects, expectedAutoRejects)
    }
    
    func testCalculateAutoRejectsSymmetric() throws {
        let sut = StockCalculator()
        
        let autoRejects = sut.calculateAutoRejects(
            price: 150,
            type: .symmetric,
            limit: 2
         )
        
        let expectedAutoRejects = AutoRejects(
            ara: [
                AutoReject(price: 202, priceChange: 52, percentage: 34.67, totalPercentage: 34.67),
                AutoReject(price: 252, priceChange: 50, percentage: 24.75, totalPercentage: 68)
            ],
            arb: [
                AutoReject(price: 98, priceChange: -52, percentage: -34.67, totalPercentage: -34.67),
                AutoReject(price: 64, priceChange: -34, percentage: -34.69, totalPercentage: -57.33)
            ]
        )
        
        XCTAssertEqual(autoRejects, expectedAutoRejects)
    }
    
    func testCalculateAutoRejectsAcceleration() throws {
        let sut = StockCalculator()
        
        let autoRejects = sut.calculateAutoRejects(
            price: 5000,
            type: .acceleration,
            limit: 2
         )
        
        let expectedAutoRejects = AutoRejects(
            ara: [
                AutoReject(price: 5500, priceChange: 500, percentage: 10, totalPercentage: 10),
                AutoReject(price: 6050, priceChange: 550, percentage: 10, totalPercentage: 21)
            ],
            arb: [
                AutoReject(price: 4500, priceChange: -500, percentage: -10, totalPercentage: -10),
                AutoReject(price: 4050, priceChange: -450, percentage: -10, totalPercentage: -19)
            ]
        )
        
        XCTAssertEqual(autoRejects, expectedAutoRejects)
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

