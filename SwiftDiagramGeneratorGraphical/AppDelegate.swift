//
//  AppDelegate.swift
//  SwiftDiagramGeneratorGraphical
//
//  Created by Pho Hale on 1/19/21.
//

import Cocoa
import SwiftDiagramComponentsGenerator


@main
class AppDelegate: NSObject, NSApplicationDelegate {

//	var visualizationDirectoryPathString: URL = URL(fileURLWithPath: "/Volumes/Speakhard/Repo/swift-code-types-navigator", isDirectory: true)

	var results: [[String]:URL] = [:]
	
	func application(_ sender: NSApplication, openFile filename: String) -> Bool {
		self.run(filePathStrings: [filename])
		return true
	}

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
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

