//
//  ContainerViewController.swift
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

/**
 View holding child views.
 
 Primarily used as hinge when switching between views.
 */
class ContainerViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Main storyboard of this project
        let mainStoryboard: NSStoryboard = NSStoryboard(name: "Main", bundle: nil)
        /// NSViewController of the primary view. Holds the lock screen
        let lockViewController = mainStoryboard.instantiateController(withIdentifier: "lockViewController") as! NSViewController
        
        self.insertChild(lockViewController, at: 0)
    
        self.view.addSubview(lockViewController.view)
        self.view.frame = lockViewController.view.frame
    }
    
    override func viewDidAppear() {
        /**
         Struct containing options for presentation of the view.
         
         In this case the **dock**, **menu bar**, **apple menu**, **toolbar**, and **"hide"** menu item are disabled.
         
         Additionaly the **⌘⌥⎋**, **⌘⇥**, and `Power/Restart/Shut Down/Log Out` hotkeys are disabled.
         */
        let presOptions: NSApplication.PresentationOptions = [
            .disableForceQuit,
            .hideDock,
            .hideMenuBar,
            .disableAppleMenu,
            .disableProcessSwitching,
            .disableSessionTermination,
            .disableHideApplication ]
        
//        let optionsDictionary = [NSView.FullScreenModeOptionKey.fullScreenModeApplicationPresentationOptions: NSNumber(value: presOptions.rawValue)]
        
        let optionsDictionary = [NSView.FullScreenModeOptionKey.fullScreenModeApplicationPresentationOptions: presOptions]
        
        self.view.enterFullScreenMode(NSScreen.main!, withOptions:optionsDictionary)
        self.view.wantsLayer = true
    }
}
