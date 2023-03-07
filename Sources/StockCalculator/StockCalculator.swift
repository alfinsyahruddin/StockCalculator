public class StockCalculator {
    public init() {}
    
    public func calculatePercentage(
        buyPrice: Double,
        sellPrice: Double
    ) -> Double {
        return ((sellPrice - buyPrice) / buyPrice) * 100
    }
    
    public func calculateTradingReturn(
        buyPrice: Double,
        sellPrice: Double,
        quantity: Double,
        brokerFee: BrokerFee = BrokerFee(buy: 0, sell: 0)
    ) -> TradingReturn {
        return TradingReturn(
            calculationResult: TradingReturn.CalculationResult(
                status: .bep,
                tradingReturn: 0,
                tradingReturnPercentage: 0,
                netTradingReturn: 0,
                netTradingReturnPercentage: 0,
                totalFee: 0,
                totalFeePercentage: 0
            ),
            buyDetail: TradingReturn.BuyDetail(
                quantity: 0,
                buyPrice: 0,
                buyFee: 0,
                buyFeePercentage: 0,
                buyValue: 0,
                totalPaid: 0
            ),
            sellDetail: TradingReturn.SellDetail(
                quantity: 0,
                sellPrice: 0,
                sellFee: 0,
                sellFeePercentage: 0,
                buyValue: 0,
                totalReceived: 0
            )
        )
    }
    
    public func calculateAutoRejects(
        closePrice: Double,
        type: AutoRejectType,
        brokerFee: BrokerFee = BrokerFee(buy: 0, sell: 0)
    ) -> (ara: [AutoReject], arb: [AutoReject]) {
        return (
            ara: [
                AutoReject(
                    price: 0,
                    priceChange: 0,
                    percentage: 0,
                    totalPercentage: 0
                )
            ],
            arb: [
                AutoReject(
                    price: 0,
                    priceChange: 0,
                    percentage: 0,
                    totalPercentage: 0
                )
            ]
        )
    }
    
    
    public func calculateProfitPerTick(
        price: Double,
        quantity: Double,
        brokerFee: BrokerFee = BrokerFee(buy: 0, sell: 0)
    ) -> [ProfitPerTick] {
        return [
            ProfitPerTick(
                value: 0,
                percentage: 0,
                price: 0
            )
        ]
    }
}
