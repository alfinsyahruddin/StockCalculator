//
//  File.swift
//  
//
//  Created by Alfin on 07/03/23.
//

import Foundation

public struct AutoReject: Equatable {
    public let price: Double
    public let priceChange: Double
    public let percentage: Double
    public let totalPercentage: Double
}

public struct AutoRejects: Equatable {
    public let ara: [AutoReject]
    public let arb: [AutoReject]
}
