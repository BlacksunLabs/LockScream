//
//  BlankScreenController.swift
//  LockScream
//
//  Created by n0ncetonic on 3/5/19.
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

import Cocoa

class BlankScreenController: NSViewController {
    var window: NSWindow?
    
    @IBOutlet weak var blankView: NSView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        view.window?.makeFirstResponder(self)
        window = self.view.window!
        
        let presOptions: NSApplication.PresentationOptions = [
            .disableForceQuit ,              // Cmd+Opt+Esc panel is disabled
            .hideDock ,                         //Dock is entirely unavailable. Spotlight menu is disabled.
            .hideMenuBar,                       //Menu Bar is Disabled
            .disableAppleMenu,                  //All Apple menu items are disabled.
            .disableProcessSwitching,           //Cmd+Tab UI is disabled. All Exposé functionality is also disabled.
            .disableSessionTermination,         // PowerKey panel and Restart/Shut Down/Log Out are disabled.
            .disableHideApplication,            // Application "Hide" menu item is disabled.
            .autoHideToolbar ]  // Toolbar is hidden
        
        let optionsDictionary = [NSView.FullScreenModeOptionKey.fullScreenModeApplicationPresentationOptions: NSNumber(value: presOptions.rawValue)]
        
        self.view.enterFullScreenMode(NSScreen.main!, withOptions:optionsDictionary)
        
        self.view.addTrackingArea(NSTrackingArea(rect: self.view.bounds, options:[.mouseEnteredAndExited, .mouseMoved, .activeInActiveApp], owner: view, userInfo: nil))
    }
    
    override func keyDown(with event: NSEvent) {
        print(event.characters!)
        self.wasDisturbed(sender: self)
    }
    
    override func mouseMoved(with event: NSEvent) {
        self.wasDisturbed(sender: self)
    }    
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == "blank2Container" {
            let vc = segue.destinationController as! ContainerViewController
            vc.loadView()
        } else if segue.identifier == "blank2View" {
            let vc = segue.destinationController as! ViewController
            vc.becomeFirstResponder()
        }
    }
    
    func wasDisturbed(sender: AnyObject) {
        print("Inside wasDisturbed")
        self.performSegue(withIdentifier: "blank2View", sender: self)
        self.window?.performClose(self)
    }
}
