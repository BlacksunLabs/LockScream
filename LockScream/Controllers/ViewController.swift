//
//  ViewController.swift
//  LockScream
//
//  Created by n0ncetonic on 3/2/19.
//  Copyright 2019 Blacksun Research Labs
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

import Cocoa

/// Main ViewController, displays fake lock screen
class ViewController: NSViewController, NSTextFieldDelegate {
    /// Full username of current user with console session
    var user = GetCurrentUser()
    
    /// URL to the user-defined wallpaper applied to the main desktop
    var wallpaper = GetWallpaperFromMainDesktop()
    
    /// Wraps `passwordField` and `arrowButton` for animation later
    @IBOutlet weak var passwordWrapperBox: NSBox!
    
    /// Text field holding masked input of user password
    @IBOutlet weak var passwordCell: NSSecureTextFieldCell!
    
    /// NSImageView holding the current user's login avatar
    @IBOutlet weak var profileImage: NSImageView!
    
    /// Label which holds current user's full name
    @IBOutlet weak var usernameLabel: NSTextField!
    
    /// Text field for `passwordCell`
    @IBOutlet weak var passwordField: NSSecureTextField!
    
    /// `profileImage`'s cell
    @IBOutlet weak var profileImageCell: NSImageCell!
    
    /// View which contains user's wallpaper
    @IBOutlet weak var backgroundBox: NSBox!
    
    /// Wraps `passwordField`. UI Hack to allow creating a rounded bezel with background color rendering
    @IBOutlet weak var passwordBox: NSView!
    
    /// Button with right facing arrow used to submit `passwordField` on click
    @IBOutlet weak var arrowButton: NSButton!
    
    /**
     Deletes the value of `passwordCell` and launches screensaver
     
     - Parameters:
        - sender: NSButton caller
     
     - Returns:
        - None
    */
    @IBAction func cancelButtonClicked(_ sender: NSButton) {
        self.passwordCell.stringValue = ""
        launchScreenSaver()
    }
    
    /**
     Intercepts `passwordField` submission.
     
     Validates submitted password is valid for user. If the password is valid further processing continues, otherwise do nothing.
     
     TODO: Implement another method for outputting password
     - Parameters:
        - None
     
     - Returns:
        - None
     */
    @IBAction func passwordFieldSubmitted(_ sender: Any) {
        let password = passwordCell.stringValue
        if ValidatePassword(password: password) {
            let alert = NSAlert()
            alert.messageText = "Lockscream"
            alert.informativeText = "Oops. Looks like you just gave away your password \(password)"
            alert.alertStyle = .warning
            alert.addButton(withTitle: "OK")
            alert.addButton(withTitle: "Cancel")
            alert.runModal()
            NSApp.terminate(nil)
        } else {
            self.passwordWrapperBox.shake()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordField.delegate = self
        
        passwordBox.wantsLayer = true
        passwordBox.layer?.borderWidth = 0
        passwordBox.layer?.cornerRadius = 5
        passwordBox.layer?.masksToBounds = true
        passwordBox.layer?.backgroundColor = NSColor.keyboardFocusIndicatorColor.cgColor
        let placeholderString = NSAttributedString.init(string: "Enter Password", attributes: [NSAttributedString.Key.foregroundColor: NSColor.controlTextColor, NSAttributedString.Key.font: NSFont.systemFont(ofSize: 12)])
        passwordCell.placeholderAttributedString = placeholderString
        
        let image = NSImage.init(contentsOfFile: wallpaper.path)
        backgroundBox.wantsLayer = true
        backgroundBox.layer?.contents = image
        
        usernameLabel.stringValue = user.fullName
        
        profileImage.wantsLayer = true
        profileImage.canDrawSubviewsIntoLayer = true
        profileImage.layer?.cornerRadius = 14.0
        profileImage.layer?.masksToBounds = true
        profileImage.image = user.image?.oval()
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear() {
        /**
         Struct containing options for presentation of the view.
         
         In this case the **dock**, **menu bar**, **apple menu**, **toolbar**, and **"hide"** menu item are disabled.
         
         Additionaly the **⌘⌥⎋**, **⌘⇥**, and `Power/Restart/Shut Down/Log Out` hotkeys are disabled.
         */
        let presOptions: NSApplication.PresentationOptions = [
            .disableForceQuit ,            // Cmd+Opt+Esc panel is disabled
            .hideDock ,                         //Dock is entirely unavailable. Spotlight menu is disabled.
            .hideMenuBar,                       //Menu Bar is Disabled
            .disableAppleMenu,                  //All Apple menu items are disabled.
            .disableProcessSwitching,           //Cmd+Tab UI is disabled. All Exposé functionality is also disabled.
            .disableSessionTermination,         // PowerKey panel and Restart/Shut Down/Log Out are disabled.
            .disableHideApplication,            // Application "Hide" menu item is disabled.
            .autoHideToolbar ]
        
        let optionsDictionary = [NSView.FullScreenModeOptionKey.fullScreenModeApplicationPresentationOptions: NSNumber(value: presOptions.rawValue)]
        self.view.enterFullScreenMode(NSScreen.main!, withOptions:optionsDictionary)
        
        self.passwordField.window?.makeFirstResponder(passwordField)
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    /**
     Monitors change to `passwordField` adding `arrowButton` when length of input > 0
     
     - Parameter obj: Object which sent Notification
     
     - Preconditon: obj.object.stringValue.count must be larger than 0
     
     */
    func controlTextDidChange(_ obj: Notification) {
        let textField = obj.object as! NSTextField
        if textField.stringValue.count < 1 {
            self.arrowButton.isHidden = true
        } else {
            self.arrowButton.isHidden = false
        }
    }
}

