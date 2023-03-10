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
                status: netTradingReturn > 0 ? .profit : netTradingReturn < 0 ? .loss : .bep,
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
        price: Double,
        type: AutoRejectType,
        limit: Int = 5
    ) -> AutoRejects {
        var ara: [AutoReject] = []
        var arb: [AutoReject] = []

        // ARA
        for _ in 0..<limit {
            let lastPrice = ara.last?.price ?? price
            
            let newPrice = self.getTickerByPercentage(lastPrice, percentage: type.getPercentage(price: lastPrice).ara)
            let percentage = self.calculatePercentage(newPrice - lastPrice, lastPrice)
                    
            ara.append(
                AutoReject(
                    price: newPrice,
                    priceChange: newPrice - lastPrice,
                    percentage: percentage,
                    totalPercentage: self.calculatePercentage(newPrice - price, price)
                )
            )
        }
        
        
        // ARB
        for _ in 0..<limit {
            let lastPrice = arb.last?.price ?? price
            
            let newPrice = self.getTickerByPercentage(lastPrice, percentage: type.getPercentage(price: lastPrice).arb)
            let percentage = self.calculatePercentage(newPrice - lastPrice, lastPrice)
                    
            arb.append(
                AutoReject(
                    price: newPrice,
                    priceChange: newPrice - lastPrice,
                    percentage: percentage,
                    totalPercentage: self.calculatePercentage(newPrice - price, price)
                )
            )
        }
        
       
        
        return AutoRejects(
            ara: ara,
            arb: arb.filter { $0.price >= 0 && ($0.price >= 50 || type == .acceleration) }
        )
    }
    
    
    public func calculateProfitPerTick(
        price: Double,
        lot: Double,
        brokerFee: BrokerFee = BrokerFee(buy: 0, sell: 0),
        limit: Int = 5
    ) -> [ProfitPerTick] {
        let tickers = self.generateTickers(price, limit: limit)
        
        let results: [ProfitPerTick] = tickers.map { tick in
            let tradingReturn = self.calculateTradingReturn(buyPrice: price, sellPrice: tick, lot: lot, brokerFee: brokerFee)
            return ProfitPerTick(
                price: tick,
                percentage: tradingReturn.calculationResult.netTradingReturnPercentage,
                value: tradingReturn.calculationResult.netTradingReturn.rounded()
            )
        }
       
        return results.filter { $0.price >= 0 }
    }
    
    // MARK: - Private Methods
    
    private func getTickerByPercentage(_ lastPrice: Double, percentage: Double) -> Double {
        let price = (lastPrice * (percentage / 100)) + lastPrice
        
        
        if price.truncatingRemainder(dividingBy: self.getFraction(price)) == 0 {
            return price
        }
        
        var ticker: Double = 0
        
        while self.calculatePercentage(
            (percentage < 0 ? ticker : ticker + self.getFraction(ticker)) - lastPrice,
            lastPrice
        ) < percentage {
            ticker += self.getFraction(ticker)
        }
        
        return ticker
    }
    
    private func generateTickers(_ price: Double, limit: Int) -> [Double] {
        // Generate Tickers
        var tickers: [Double] = [price]
        
        // 1. Profit
        for _ in 0..<limit {
            let prevPrice = tickers.last!
            let newPrice = prevPrice + self.getFraction(prevPrice)
            tickers.append(newPrice)
        }
        
        // 2. Loss
        for _ in 0..<limit {
            let prevPrice = tickers.first!
            let newPrice = prevPrice - self.getFraction(prevPrice)
            tickers.insert(newPrice, at: 0)
        }
        
        return tickers
    }
    
    private func getFraction(_ price: Double) -> Double {
        switch price {
        case 0..<200:
            return 1
        case 200..<500:
            return 2
        case 500..<2000:
            return 5
        case 2000..<5000:
            return 10
        default:
            return 25
        }
    }
    
    private func calculatePercentage(
        _ value: Double,
        _ total: Double
    ) -> Double {
        return ((value / total) * 100).round()
    }
}


