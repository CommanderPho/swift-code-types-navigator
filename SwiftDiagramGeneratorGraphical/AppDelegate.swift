//
//  AppDelegate.swift
//  SwiftDiagramGeneratorGraphical
//
//  Created by Pho Hale on 1/19/21.
//

import Cocoa



@main
class AppDelegate: NSObject, NSApplicationDelegate, MacOSMenuBarExtraProviderProtocol {

	// applicationStatus: should be updated when loading is complete to indicate that it's ready to use.
	var applicationStatus: ApplicationStatus = .Normal {
		didSet {
			print("applicationStatus changed: \(self.applicationStatus)")
			self.updateMenuBarExtra()
		}
	}


	var diagramGenerator: CodeDiagramGenerator = CodeDiagramGenerator()


	////////////////////////////////////////////////////////////////////
	//MARK: -
	//MARK: - MacOSMenuBarExtraProviderProtocol properties
	var menuBarExtraStatusItem: NSStatusItem!
	// The Menu that contains the menuBar Item, displayed in the right side of the macOS MenuBar. (Not the app menu)
	@IBOutlet weak var menuBarExtraMainMenu: NSMenu!

	@IBOutlet weak var menuBarExtra_MenuItem_Rebuild: NSMenuItem!
	@IBOutlet weak var menuBarExtra_MenuItem_SelectNewTarget: NSMenuItem!


//	var visualizationDirectoryPathString: URL = URL(fileURLWithPath: "/Volumes/Speakhard/Repo/swift-code-types-navigator", isDirectory: true)

	var results: [[String]:URL] = [:]
	
	func application(_ sender: NSApplication, openFile filename: String) -> Bool {
		self.performTryRun(filePathStrings: [filename])
		return true
	}

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
		// Setup the persistant menuBar status Item on the right side of the macOS menubar
		self.setupMenuBarExtra() // I don't need to explicitly call setup since it's called in updateMenuBarExtra() if it isn't already done, but I do anyway.
		self.updateMenuBarExtra()
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}



	// [String] convenience version
	public func performTryRun(filePathStrings: [String]) {
//		self.diagramGenerator.run(filePathStrings: filePathStrings)
		self.performTryRun(filePaths: filePathStrings.map({ URL(fileURLWithPath: $0) }))
	}

	public func performTryRun(filePaths: [URL]) {
		self.diagramGenerator.run(filePaths: filePaths)
	}



	@IBAction func actionPerformRebuild(_ sender: Any) {
//		self.performTryRun(filePaths: self.diagramGenerator.)

	}

	@IBAction func actionPerformChangeTarget(_ sender: Any) {
		//TODO: Show a file selector

	}


}



extension AppDelegate: NSWindowDelegate {

	////////////////////////////////////////////////////////////////////
	//MARK: -
	//MARK: - MacOSMenuBarExtraProviderProtocol: macOS MenuBar Status Item (the agent in the right side of the menubar)

	public var acceptedDraggedFileExtensions: [String] { return ["swift", ""];}  // allow .swift files and folders

	func updateMenuBarExtra() {
		let menuBarExtra: NSStatusItem
		if let validMenuBarExtra = self.menuBarExtraStatusItem {
			menuBarExtra = validMenuBarExtra
		}
		else {
			// Initialize a new one
			self.setupMenuBarExtra()
			guard let validMenuBarExtra = self.menuBarExtraStatusItem else {
				fatalError("No valid menu status bar extra exists even though setupMenuBarExtra() was called!")
			}
			menuBarExtra = validMenuBarExtra
		}

		// Apply the status state to the menuBarExtra, updating the text and image if needed
		self.applicationStatus.menuBarStatus.apply(menuBarExtra)
	}

	// called only once at launch
	func setupMenuBarExtra() {
		// Make a status bar that has variable length (as opposed to being a standard square size)
		// -1 to indicate "variable length"
		self.menuBarExtraStatusItem = NSStatusBar.system.statusItem(withLength: -1)

		// register with an array of types you'd like to accept
		guard let validButton = self.menuBarExtraStatusItem.button,
			  let validWindow = validButton.window else {
			fatalError()
		}
		validWindow.registerForDraggedTypes([.fileURL])
		validWindow.delegate = self


//		self.menuBarExtraStatusItem.button = NSStatusBarButton(title: self.applicationStatus.menuBarStatus.title, image: self.applicationStatus.menuBarStatus.image, target: self, action: nil)


		// Set the menu that should appear when the item is clicked
		self.menuBarExtraStatusItem!.menu = self.menuBarExtraMainMenu

		// Set if the item should change color when clicked
//		self.menuBarExtraStatusItem!.highlightMode = true
//		self.menuBarExtraStatusItem!.button!.cell!.highlight(<#T##flag: Bool##Bool#>, withFrame: <#T##NSRect#>, in: <#T##NSView#>)
	}





}


extension AppDelegate: NSDraggingDestination {

//	public func color(to color: NSColor)
//	{
//		guard let validButton = self.menuBarExtraStatusItem.button else {
//			fatalError()
//		}
//		validButton.wantsLayer = true
//		validButton.layer?.backgroundColor = color.cgColor
//	}
//
//
//	////////////////////////////////////////////////////////////////////
//	//MARK: -
//	//MARK: - NSWindowDelegate functions for Drag/Dropping to custom Status Item (macOS MenuBarExtra)
//	public func draggingEntered(_ draggingInfo: NSDraggingInfo) -> NSDragOperation {
//		var containsMatchingFiles = false
//		draggingInfo.draggingPasteboard.readObjects(forClasses: [NSURL.self], options: nil)?.forEach
//		{
//			eachObject in
//			if let eachURL = eachObject as? URL
//			{
//				containsMatchingFiles = containsMatchingFiles || acceptedDraggedFileExtensions.contains(eachURL.pathExtension.lowercased())
//				if containsMatchingFiles { print(eachURL.path) }
//			}
//		}
//
//		switch (containsMatchingFiles)
//		{
//			case true:
//				color(to: .secondaryLabelColor)
//				return .copy
//			case false:
//				color(to: .disabledControlTextColor)
//				return .init()
//		}
//	}
//
//	public func performDragOperation(_ draggingInfo: NSDraggingInfo) -> Bool {
//		// Collect URLs.
//		var matchingFileURLs: [URL] = []
//		draggingInfo.draggingPasteboard.readObjects(forClasses: [NSURL.self], options: nil)?.forEach
//		{
//			eachObject in
//			if
//				let eachURL = eachObject as? URL,
//				acceptedDraggedFileExtensions.contains(eachURL.pathExtension.lowercased())
//			{ matchingFileURLs.append(eachURL) }
//		}
//
//		// Only if any,
//		guard matchingFileURLs.count > 0
//		else { return false }
//
//		// Perform the run!
//		self.performTryRun(filePaths: matchingFileURLs)
//		return true
//	}
//
//	public func draggingExited(_ sender: NSDraggingInfo?) {
//		color(to: .clear)
//	}
//
//	public func draggingEnded(_ sender: NSDraggingInfo) {
//		color(to: .clear)
//	}

}
