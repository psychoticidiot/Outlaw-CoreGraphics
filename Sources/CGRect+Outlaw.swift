//
//  CGRect+Outlaw.swift
//  OutlawExtensions
//
//  Created by Brian Mullen on 12/11/16.
//  Copyright © 2016 Molbie LLC. All rights reserved.
//

import CoreGraphics
import Outlaw


public extension CGRect {
    public struct ExtractableKeys {
        public static let x = "x"
        public static let y = "y"
        public static let width = "width"
        public static let height = "height"
    }
}

extension CGRect: Value {
    public static func value(from object: Any) throws -> CGRect {
        if let data = object as? Extractable {
            typealias keys = CGRect.ExtractableKeys
            
            let x: CGFloat = try data.value(for: keys.x)
            let y: CGFloat = try data.value(for: keys.y)
            let width: CGFloat = try data.value(for: keys.width)
            let height: CGFloat = try data.value(for: keys.height)
            
            return CGRect(x: x, y: y, width: width, height: height)
        }
        else if let data = object as? IndexExtractable {
            let x: CGFloat = try data.value(for: 0)
            let y: CGFloat = try data.value(for: 1)
            let width: CGFloat = try data.value(for: 2)
            let height: CGFloat = try data.value(for: 3)
            
            return CGRect(x: x, y: y, width: width, height: height)
        }
        else {
            let expectedType = "Extractable or IndexExtractable"
            throw OutlawError.typeMismatch(expected: expectedType, actual: type(of: object))
        }
    }
}

extension CGRect: Serializable {
    public func serialized() -> [String: CGFloat] {
        typealias keys = CGRect.ExtractableKeys
        
        var result = [String: CGFloat]()
        result[keys.x] = self.origin.x
        result[keys.y] = self.origin.y
        result[keys.width] = self.width
        result[keys.height] = self.height
        
        return result
    }
}

extension CGRect: IndexSerializable {
    public func serialized() -> [CGFloat] {
        return [self.origin.x, self.origin.y, self.width, self.height]
    }
}
