//
//  BrokerFee.swift
//  
//
//  Created by Alfin on 07/03/23.
//

import Foundation

/// Broker Fee is a trading fee that charged by broker (in percentage).
public struct BrokerFee: Equatable {
    public let buy: Double
    public let sell: Double
    
    public init(buy: Double, sell: Double) {
        self.buy = buy
        self.sell = sell
    }
}
