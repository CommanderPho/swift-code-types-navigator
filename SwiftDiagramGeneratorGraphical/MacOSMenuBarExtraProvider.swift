//
//  MacOSMenuBarExtraProvider.swift
//  Dose-macOS
//
//  Created by Pho Hale on 11/12/20.
//  Copyright © 2020 Pho Hale. All rights reserved.
//

import Foundation
import AppKit
import Cocoa


/* USAGE:

extend AppDelegate like:

var menuBarExtraStatusItem: NSStatusItem!
// The Menu that contains the menuBar Item, displayed in the right side of the macOS MenuBar. (Not the app menu)
@IBOutlet weak var menuBarExtraMainMenu: NSMenu!


extension AppDelegate: MacOSMenuBarExtraProviderProtocol {


}



*/



// MARK: - protocol MacOSMenuBarExtraProviderProtocol: class
// Implementors define the macOS system menubar item for this app.
protocol MacOSMenuBarExtraProviderProtocol: class {
	// The Menu that contains the menuBar Item, displayed in the right side of the macOS MenuBar. (Not the app menu)
	var menuBarExtraMainMenu: NSMenu! {get set}
	var menuBarExtraStatusItem: NSStatusItem! {get set}

	// @objc
	func setupMenuBarExtra()
	func updateMenuBarExtra()
}


// Represents a state
struct MenuBarStatusItemState {
	var title: String
	var image: NSImage
	var length: CGFloat

	public func apply(_ statusItem: NSStatusItem) {
		// Set the text and image that appears in the passed status item
		statusItem.title = self.title
		statusItem.image = self.image
		// FUTURE NOTE: Settings the title of the button (like the documentation seems to be pushing me towards by depricating setting the .title property) doesn't seem to work!
		//		statusItem.button!.title = self.title
		//		statusItem.button!.image = self.image
		statusItem.length = self.length
	}
}


enum ApplicationStatus {
	case Loading
	case Normal

	fileprivate var statusImage: NSImage {
		guard let img = NSImage(named: "menuBar/macExportBold@22w") else {
			fatalError("Couldn't get image!")
		}
		img.size = NSSize(width: 22, height: 22)
		img.isTemplate = false // BUG: temporarily set to false because it renders white when ThemeKit's theme is set to dark (even if the OS's menu bar isn't dark).
		return img
	}

	public var menuBarStatus: MenuBarStatusItemState {
		switch self {
		case .Loading:
			return MenuBarStatusItemState(title: "Loading...", image: self.statusImage, length: 90)
		case .Normal:
			return MenuBarStatusItemState(title: "SDGen", image: self.statusImage, length: 70)
		default:
			fatalError("Unhandled enum case!")
		}
	}
}


