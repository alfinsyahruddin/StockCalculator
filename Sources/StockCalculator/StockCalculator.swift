public class StockCalculator {
    public init() {}
    
    public func calculatePercentage(
        buyPrice: Double,
        sellPrice: Double
    ) -> Double {
        return ((sellPrice - buyPrice) / buyPrice) * 100
    }
}
