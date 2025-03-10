//
//  AccentEnum.swift
//  Macro
//
//  Created by Yunki on 10/30/24.
//

enum Accent: Int, CaseIterable, Codable {
    case strong
    case medium
    case weak
    case none
    
    func nextAccent() -> Accent {
        switch self {
        case .strong: return .medium
        case .medium: return .weak
        case .weak: return .none
        case .none: return .strong
        }
    }
}

extension Accent: Comparable {
    static func < (lhs: Accent, rhs: Accent) -> Bool {
        switch (lhs, rhs) {
        case (.none, .strong), (.weak, .strong), (.medium, .strong): return true
        case (.none, .medium), (.weak, .medium): return true
        case (.none, .weak): return true
        default: return false
        }
    }
}
