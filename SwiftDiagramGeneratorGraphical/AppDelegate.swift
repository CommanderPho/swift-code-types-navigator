//
//  AppDelegate.swift
//  SwiftDiagramGeneratorGraphical
//
//  Created by Pho Hale on 1/19/21.
//

import Cocoa
import SwiftDiagramComponentsGenerator


@main
class AppDelegate: NSObject, NSApplicationDelegate, MacOSMenuBarExtraProviderProtocol {

	// applicationStatus: should be updated when loading is complete to indicate that it's ready to use.
	var applicationStatus: ApplicationStatus = .Normal {
		didSet {
			print("applicationStatus changed: \(self.applicationStatus)")
			self.updateMenuBarExtra()
		}
	}


	
	////////////////////////////////////////////////////////////////////
	//MARK: -
	//MARK: - MacOSMenuBarExtraProviderProtocol properties
	var menuBarExtraStatusItem: NSStatusItem!
	// The Menu that contains the menuBar Item, displayed in the right side of the macOS MenuBar. (Not the app menu)
	@IBOutlet weak var menuBarExtraMainMenu: NSMenu!



//	var visualizationDirectoryPathString: URL = URL(fileURLWithPath: "/Volumes/Speakhard/Repo/swift-code-types-navigator", isDirectory: true)

	var results: [[String]:URL] = [:]
	
	func application(_ sender: NSApplication, openFile filename: String) -> Bool {
		self.run(filePathStrings: [filename])
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


	func getVisualizationPath() -> URL {
		// Bundle mode:
//		guard let validRootPath = Bundle.init(for: AppDelegate.self).url(forResource: "Visualization", withExtension: nil, subdirectory: nil) else {
//			fatalError()
//		}
//		return validRootPath

		// Hardcoded mode:
		return URL(fileURLWithPath: "/Volumes/Speakhard/Repo/swift-code-types-navigator/Visualization", isDirectory: true)
	}


	
	public func run(filePathStrings: [String]) {
		print("AppDelegate.run(filePathStrings: \(filePathStrings))...")
		let fileSystemItemsPaths = filePathStrings
		let swiftFilePaths = FileSystemHelper.getSwiftFilePaths(inFileSystemItemPaths: fileSystemItemsPaths)
		let result = Generator.generateSwiftDiagramComponents(forSwiftFilesAtPaths: swiftFilePaths)
		let resultJsonString = jsonString(fromObject: result)

		let validRootPath = getVisualizationPath()

		var diagramScriptTemplateFileContents = try! String(contentsOfFile:	validRootPath.appendingPathComponent("diagramScriptTemplate").path)
		diagramScriptTemplateFileContents =
			diagramScriptTemplateFileContents.replacingOccurrences(of: "$entitiesAndRelationships", with: resultJsonString)


		let outputPath = validRootPath.appendingPathComponent("diagram.js")
		try! diagramScriptTemplateFileContents.write(toFile: outputPath.path, atomically: false, encoding: .utf8)


		let outputHtmlPath = validRootPath.appendingPathComponent("diagram.html")
		// add the results to the output results list
		self.results[filePathStrings] = outputHtmlPath

		//DO:
		print("done: result written to outputHtmlPath: \(outputHtmlPath.path)")
		executeShellCommand(arguments: "open", outputHtmlPath.path)
//		print(resultJsonString)
	}

}



extension AppDelegate {

	////////////////////////////////////////////////////////////////////
	//MARK: -
	//MARK: - MacOSMenuBarExtraProviderProtocol: macOS MenuBar Status Item (the agent in the right side of the menubar)


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

		// Set the menu that should appear when the item is clicked
		self.menuBarExtraStatusItem!.menu = self.menuBarExtraMainMenu

		// Set if the item should change color when clicked
		self.menuBarExtraStatusItem!.highlightMode = true
	}




}
