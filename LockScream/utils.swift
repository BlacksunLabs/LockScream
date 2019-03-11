//
//  utils.swift
//  LockScream
//
//  Created by n0ncetonic on 3/2/19.
//  Copyright 2019 Blacksun Research Labs
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.


import Foundation
import Collaboration
import AppKit

/// Extends NSImage methods
extension NSImage {
    /**
     Turns NSImage into a circular masked copy of itself.
     
     - Returns
        - NSImage
     */
    func oval() -> NSImage {
        let image = NSImage(size: size)
        image.lockFocus()
        
        NSGraphicsContext.current?.imageInterpolation = .high
        let frame = NSRect(origin: .zero, size: size)
        NSBezierPath(ovalIn: frame).addClip()
        draw(at: .zero, from: frame, operation: .sourceOver, fraction: 1)
        
        image.unlockFocus()
        return image
    }
}

/**
 Gets an object containing information about the current user
 
 - Returns:
    - CBIdentity of current user
 */
func GetCurrentUser() -> CBIdentity {
    let qcu = CSIdentityQueryCreateForCurrentUser(kCFAllocatorDefault)?.takeRetainedValue()
    let flags = CSIdentityQueryFlags(kCSIdentityQueryGenerateUpdateEvents)
    CSIdentityQueryExecute(qcu, flags, nil)
    
    let results = CSIdentityQueryCopyResults(qcu)?.takeRetainedValue() as NSArray?
    
    let rawIdentity = results as? Array<CSIdentity>
    let identity = rawIdentity?.first
    let rawName = CSIdentityGetPosixName(identity).takeRetainedValue()
    
    let name = rawName as String
    return CBIdentity(name: name, authority: .local())!
}

/**
 Validates password against Core Service's Identity Service.
 
 - Parameters:
    - password: String containing password to test
 - Returns:
    - bool: True if valid password.
 */
func ValidatePassword(password: String) -> Bool {
    let qcu = CSIdentityQueryCreateForCurrentUser(kCFAllocatorDefault)?.takeRetainedValue()
    let flags = CSIdentityQueryFlags(kCSIdentityQueryGenerateUpdateEvents)
    CSIdentityQueryExecute(qcu, flags, nil)
    
    let results = CSIdentityQueryCopyResults(qcu)?.takeRetainedValue() as NSArray?
    
    let rawIdentity = results as? Array<CSIdentity>
    let identity = rawIdentity?.first
    let userIdentity = CBUserIdentity.init(posixUID: CSIdentityGetPosixID(identity), authority: .local())
    
    return userIdentity!.authenticate(withPassword: password)
}

/**
 Gets wallpaper of main desktop
 
 - Returns:
    - wallpaperURL: URL to image set as main desktop's wallpaper
 */
func GetWallpaperFromMainDesktop() -> URL {
    let MainScreen = NSScreen.main
    let wallpaperURL = NSWorkspace.shared.desktopImageURL(for: MainScreen!)
    return wallpaperURL!
}

/**
 Launches screensaver.
 
 Bypasses triggering real lock screen by utilizing the `ScreenSaverPreview` application normally reserved for preference panels.
 
 - Returns:
    - None
 */
func launchScreenSaver() {
    // Found the this path while poking at the Desktop and Wallpaper prefpanes.
    let _ = Process.launchedProcess(launchPath: "/System/Library/PreferencePanes/DesktopScreenEffectsPref.prefPane/Contents/Resources/ScreenEffects.prefPane/Contents/Resources/ScreenSaverPreview.app/Contents/MacOS/ScreenSaverPreview", arguments: [""])
}
