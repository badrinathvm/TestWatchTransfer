//
//  ErrorType.swift
//  TestWatchTransfer
//
//  Created by Rani Badri on 10/21/25.
//

import Foundation

enum ErrorType: String, Codable, CaseIterable, Identifiable {
    case serveError = "Serve Error"
    case lobMiss = "Lob Miss"
    case missedReturn = "Missed Return"
    case overhitReturn = "Overhit Return"
    case kitchenFault = "Kitchen Fault"
    case slowNetTransition = "Slow Net Transition"
    case powerOverControl = "Power Over Control"
    case communicationError = "Communication Error"
    case positioningError = "Positioning Error"
    case recoveryMiss = "Recovery Miss"

    var id: String { rawValue }

    var description: String {
        switch self {
        case .serveError:
            return "Net or out of bounds"
        case .lobMiss:
            return "Attacked or failed to clear"
        case .missedReturn:
            return "Failed serve return"
        case .overhitReturn:
            return "Long or out of bounds"
        case .kitchenFault:
            return "Stepped into non-volley zone"
        case .slowNetTransition:
            return "Failed to advance after return"
        case .powerOverControl:
            return "Excessive force vs placement"
        case .communicationError:
            return "Poor coordination with partner"
        case .positioningError:
            return "Late reaction or flat-footed"
        case .recoveryMiss:
            return "Failed to reset after wide/deep shots"
        }
    }
}

struct ErrorCount: Codable, Identifiable {
    var id: String { errorType.rawValue }
    let errorType: ErrorType
    var count: Int

    init(errorType: ErrorType, count: Int = 0) {
        self.errorType = errorType
        self.count = count
    }
}
