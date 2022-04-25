//
//  Helpers.swift
//  DarkModeDiscovery
//
//  Created by Mikhail Zhigulin on 21.02.2022.
//

import UIKit
import PerseusDarkMode

public let DARK_MODE_SETTINGS_KEY = "dark_mode_preference"

func changeDarkModeManually(_ userChoice: DarkModeOption)
{
    // Change Dark Mode value in settings bundle
    UserDefaults.standard.setValue(userChoice.rawValue, forKey: DARK_MODE_SETTINGS_KEY)
    
    // Change Dark Mode value in Perseus Dark Mode library
    AppearanceService.DarkModeUserChoice = userChoice
    
    // Update appearance in accoring with changed Dark Mode Style
    AppearanceService.makeUp()
}

func isDarkModeSettingsChanged() -> DarkModeOption?
{
    // Load enum int value from settings
    
    let option = UserDefaults.standard.valueExists(forKey: DARK_MODE_SETTINGS_KEY) ?
        UserDefaults.standard.integer(forKey: DARK_MODE_SETTINGS_KEY) : -1
    
    // Try to cast int value to enum
    
    guard option != -1, let settingsDarkMode = DarkModeOption.init(rawValue: option)
    else { return nil }
    
    // Report change
    
    return settingsDarkMode == AppearanceService.DarkModeUserChoice ? nil : settingsDarkMode
}

func registerSettingsBundle()
{
    // Make it easy just for the only one option
    UserDefaults.standard.register(defaults: [DARK_MODE_SETTINGS_KEY: 0])
}

extension UserDefaults
{
    func valueExists(forKey key: String) -> Bool
    {
        return object(forKey: key) != nil
    }
}

extension UIResponder
{
    func nextFirstResponder(where condition: (UIResponder) -> Bool ) -> UIResponder?
    {
        guard let next = next else { return nil }
        
        if condition(next) { return next }
        else { return next.nextFirstResponder(where: condition) }
    }
}

extension UIColor
{
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }
    
    var RGBA255: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red*255, green*255, blue*255, alpha)
    }
}

func rgba255(_ red  : CGFloat,
             _ green: CGFloat,
             _ blue : CGFloat,
             _ alpha: CGFloat = 1.0) -> UIColor
{
    UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
}

func convert_RGBA_to_HEX(_ input: String) -> String?
{
    guard input.isEmpty == false else { return nil }
    
    let array = input.removeWhitespace().split(separator: ",")
    
    guard array.count >= 3 else { return nil }
    
    let red = CGFloat(Int(array[0]) ?? 0)
    let green = CGFloat(Int(array[1]) ?? 0)
    let blue = CGFloat(Int(array[2]) ?? 0)
    
    var alpha: CGFloat = 1
    var color: UIColor
    
    if array.count == 4, let alphaNum = NumberFormatter().number(from: String(array[3]))
    {
        alpha = CGFloat(alphaNum.doubleValue)
        color = rgba255(red, green, blue, alpha)
    }
    else
    {
        color = rgba255(red, green, blue)
    }
    
    return color.hexString()
}

func convert_HEX_to_RGBA(_ input: String) -> String?
{
    guard let colorFromHEX = try? UIColor(cgColor: UIColor(rgba_throws: input).cgColor)
    else { return nil }
    
    return ""
        + "\(Int(colorFromHEX.RGBA255.red)), "
        + "\(Int(colorFromHEX.RGBA255.green)), "
        + "\(Int(colorFromHEX.RGBA255.blue)), "
        + "\(Double(round(100 * colorFromHEX.RGBA255.alpha) / 100))"
}

extension String
{
    func replace(string:String, replacement:String) -> String
    {
        replacingOccurrences(of     : string,
                             with   : replacement,
                             options: NSString.CompareOptions.literal,
                             range  : nil)
    }
    
    func removeWhitespace() -> String
    {
        replace(string: " ", replacement: "")
    }
}