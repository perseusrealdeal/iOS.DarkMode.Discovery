//
//  DarkModeFunctions.swift
//  DarkModeDiscovery
//
//  Created by Mikhail Zhigulin in 7530.
//
//  Copyright © 7530 Mikhail Zhigulin of Novosibirsk.
//  All rights reserved.
//
//
//  MIT License
//
//  Copyright © 7530 Mikhail Zhigulin of Novosibirsk, where 7530 is
//  the year from the creation of the world according to a Slavic calendar.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit
import PerseusDarkMode

/// Dark Mode option key used in Settings bundle.
let DARK_MODE_SETTINGS_KEY = "dark_mode_preference"

/// Changes Dark Mode with the value required
///
/// Changes AppearanceService.DarkModeUserChoice value.
/// Also, changes Dark Mode option value in settings bundle.
///
/// - Parameter userChoice: The Dark Mode value required to be setted.
func changeDarkModeManually(_ userChoice: DarkModeOption)
{
    // Change Dark Mode value in settings bundle
    UserDefaults.standard.setValue(userChoice.rawValue, forKey: DARK_MODE_SETTINGS_KEY)

    // Change Dark Mode value in Perseus Dark Mode library
    AppearanceService.DarkModeUserChoice = userChoice

    // Update appearance in accoring with changed Dark Mode Style
    AppearanceService.makeUp()
}

/// Checks whether the Dark Mode option in Settings app has changed.
///
/// Report DarkModeOption value if the difference between the app's Dark Mode in Settings app
/// and AppearanceService.DarkModeUserChoice takes place.
///
/// - Returns: Nil if no changes or Dark Mode value that is different to AppearanceService.DarkModeUserChoice.
func isDarkModeSettingsChanged() -> DarkModeOption?
{
    // Load enum int value from settings

    let option = UserDefaults.standard.valueExists(forKey: DARK_MODE_SETTINGS_KEY) ?
        UserDefaults.standard.integer(forKey: DARK_MODE_SETTINGS_KEY) : -1

    // Try to cast int value to enum

    guard option != -1, let settingsDarkMode = DarkModeOption.init(rawValue: option)
    else { return nil } // Should throw exception if init gives nil

    // Report change

    return settingsDarkMode != AppearanceService.DarkModeUserChoice ? settingsDarkMode : nil
}
