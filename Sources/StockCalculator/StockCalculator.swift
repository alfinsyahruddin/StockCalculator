public class StockCalculator {
    /// Shares per Lot, default = 100
    public var sharesPerLot: Double = 100
    
    public init() {}
    
    public func calculateTradingReturn(
        buyPrice: Double,
        sellPrice: Double,
        lot: Double,
        brokerFee: BrokerFee = BrokerFee(buy: 0, sell: 0)
    ) -> TradingReturn {
        let buyValue = buyPrice * (lot * self.sharesPerLot)
        let buyFee = buyValue * (brokerFee.buy / 100)
        let totalPaid = buyValue + buyFee
        
        let sellValue = sellPrice * (lot * self.sharesPerLot)
        let sellFee = sellValue * (brokerFee.sell / 100)
        let totalReceived = sellValue - sellFee
        
        let tradingReturn = sellValue - buyValue
        let totalFee = buyFee + sellFee
        let netTradingReturn = tradingReturn - totalFee
        
        return TradingReturn(
            calculationResult: TradingReturn.CalculationResult(
                status: tradingReturn > 0 ? .profit : tradingReturn < 0 ? .loss : .bep,
                tradingReturn: tradingReturn,
                tradingReturnPercentage: calculatePercentage(tradingReturn, buyValue),
                netTradingReturn: netTradingReturn,
                netTradingReturnPercentage: calculatePercentage(netTradingReturn, totalPaid),
                totalFee: totalFee,
                totalFeePercentage: calculatePercentage(totalFee, totalPaid)
            ),
            buyDetail: TradingReturn.BuyDetail(
                lot: lot,
                buyPrice: buyPrice,
                buyFee: buyFee,
                buyFeePercentage: brokerFee.buy,
                buyValue: buyValue,
                totalPaid: totalPaid
            ),
            sellDetail: TradingReturn.SellDetail(
                lot: lot,
                sellPrice: sellPrice,
                sellFee: sellFee,
                sellFeePercentage: brokerFee.sell,
                sellValue: sellValue,
                totalReceived: totalReceived
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
        lot: Double,
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
    
    private func calculatePercentage(
        _ a: Double,
        _ b: Double
    ) -> Double {
        return ((a / b) * 100).round()
    }
}

