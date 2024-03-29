//
//  HexColorConverter.swift
//  DarkModeDiscovery
//
//  Copied and edited by Mikhail Zhigulin on 04.04.2022.
//
//  Firstly copied and edited by Sergey Pugach on 2/2/18.
//  Copyright © 2018 P.D.Q. All rights reserved.
//
//  LINK to copied one: https://github.com/SeRG1k17/UIColor-Hex-Swift.git
//  LINK to origin one: https://github.com/yeahdongcn/UIColor-Hex-Swift

import UIKit

/// Represents the list of HEX convertion errors.
public enum PlatformColorInputError: Error {
    case unableToScanHexValue
    case mismatchedHexStringLength
    case unableToOutputHexString
}

extension UIColor {

    /// The six-digit hexadecimal representation of color with alpha of the form #RRGGBBAA.
    /// - parameter hex8: Eight-digit hexadecimal value.
    public convenience init(hex8: UInt32) {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex8 & 0xFF000000) >> 24) / divisor
        let green   = CGFloat((hex8 & 0x00FF0000) >> 16) / divisor
        let blue    = CGFloat((hex8 & 0x0000FF00) >>  8) / divisor
        let alpha   = CGFloat( hex8 & 0x000000FF       ) / divisor

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    /// The rgba in form #RRGGBBAA/#RRGGBB, throws error.
    /// - parameter rgba: String value.
    public convenience init(rgba_throws rgba: String) throws {
        var hexString = rgba

        if hexString.hasPrefix("#") { hexString = String(hexString.dropFirst()) }

        var hexValue: UInt32 = 0

        guard Scanner(string: hexString).scanHexInt32(&hexValue) else {
            throw PlatformColorInputError.unableToScanHexValue
        }

        guard hexString.count == 8 else {
            throw PlatformColorInputError.mismatchedHexStringLength
        }

        self.init(hex8: hexValue)
    }

    /// Hex string of a PlatformColor instance, throws error.
    /// - parameter includeAlpha: Whether the alpha should be included.
    public func hexStringThrows(_ includeAlpha: Bool = true) throws -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        guard red >= 0 && red <= 1 && green >= 0 && green <= 1 && blue >= 0 && blue <= 1 else {
            throw PlatformColorInputError.unableToOutputHexString
        }

        return includeAlpha ? String(format: "#%02X%02X%02X%02X",
                                     Int(round(red * 255)), Int(round(green * 255)),
                                     Int(round(blue * 255)), Int(round(alpha * 255))) :
        String(format: "#%02X%02X%02X",
               Int(round(red * 255)),
               Int(round(green * 255)), Int(round(blue * 255)))
    }

    /// Hex string of a PlatformColor instance, fails to empty string.
    /// - parameter includeAlpha: Whether the alpha should be included.
    public func hexString(_ includeAlpha: Bool = true) -> String {
        guard let hexString = try? hexStringThrows(includeAlpha) else {
            return ""
        }

        return hexString
    }
}
