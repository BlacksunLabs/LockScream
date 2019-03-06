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

class ViewController: NSViewController, NSTextFieldDelegate {
    var user = GetCurrentUser()
    var wallpaper = GetWallpaperFromMainDesktop()
    
    @IBOutlet weak var passwordCell: NSSecureTextFieldCell!
    @IBOutlet weak var profileImage: NSImageView!
    @IBOutlet weak var usernameLabel: NSTextField!
    @IBOutlet weak var passwordField: NSSecureTextField!
    @IBOutlet weak var profileImageCell: NSImageCell!
    @IBOutlet weak var backgroundBox: NSBox!
    @IBOutlet weak var passwordBox: NSView!
    @IBOutlet weak var arrowButton: NSButton!
    
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
        let placeholderString = NSAttributedString.init(string: "Enter Password", attributes: [NSAttributedString.Key.foregroundColor: NSColor.secondarySelectedControlColor, NSAttributedString.Key.font: NSFont.systemFont(ofSize: 12)])
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
    
    func controlTextDidChange(_ obj: Notification) {
        let textField = obj.object as! NSTextField
        if textField.stringValue.count < 1 {
            self.arrowButton.isHidden = true
        } else {
            self.arrowButton.isHidden = false
        }
    }
}

