//
//  CodeDiagramGenerator.swift
//  SwiftDiagramGeneratorGraphical
//
//  Created by Pho Hale on 1/24/21.
//

import Foundation
import SwiftDiagramComponentsGenerator


public protocol CodeDiagramGeneratingProtocol {

	var lastActiveFilePaths: [URL]? {get set}
	var results: [[URL]:GenerateResultTupleType] {get set}

	func getVisualizationPath() -> URL

	mutating func run(filePaths: [URL])
//	func run(filePathStrings: [String])

	// regenerates for the last used fileUrls
	mutating func rerun()
}


public typealias GenerateResultTupleType = (outputJavascriptPath: URL, outputHtmlPath: URL)

public struct CodeDiagramGenerator: CodeDiagramGeneratingProtocol {


	public var lastActiveFilePaths: [URL]? = nil
	public var results: [[URL]:GenerateResultTupleType] = [:]


	public func getVisualizationPath() -> URL {
		// Hardcoded mode:
		return URL(fileURLWithPath: "/Volumes/Speakhard/Repo/swift-code-types-navigator/Visualization", isDirectory: true)
	}


	fileprivate mutating func run(filePathStrings: [String]) {
		let fileSystemItemsPaths = filePathStrings.map({ URL(fileURLWithPath: $0) })
		self.run(filePaths: fileSystemItemsPaths)
	}


	// Main run function. When complete, the result is stored in results[lastActiveFilePaths]
	public mutating func run(filePaths: [URL]) {
		print("AppDelegate.run(filePaths: \(filePaths))...")

		self.lastActiveFilePaths = filePaths

		let swiftFilePaths = FileSystemHelper.getFlattenedSwiftFilePaths(inFileSystemItemPaths: filePaths)
//		let result = Generator.generateSwiftDiagramComponents(forSwiftFilesAtPaths: swiftFilePaths)
		let result = Generator.generateSwiftDiagramComponents(forSwiftFilesAtPathURLs: swiftFilePaths)
		let resultJsonString = jsonString(fromObject: result)

		let validRootPath = getVisualizationPath()

		var diagramScriptTemplateFileContents = try! String(contentsOfFile:	validRootPath.appendingPathComponent("diagramScriptTemplate").path)
		diagramScriptTemplateFileContents =
			diagramScriptTemplateFileContents.replacingOccurrences(of: "$entitiesAndRelationships", with: resultJsonString)


		let outputJavascriptPath = validRootPath.appendingPathComponent("diagram.js")
		try! diagramScriptTemplateFileContents.write(toFile: outputJavascriptPath.path, atomically: false, encoding: .utf8)

		let outputHtmlPath = validRootPath.appendingPathComponent("diagram.html")
		// add the results to the output results list
		self.results[filePaths] = (outputJavascriptPath, outputHtmlPath)

		//DO:
		print("done: result written to outputHtmlPath: \(outputHtmlPath.path)")
		executeShellCommand(arguments: "open", outputHtmlPath.path)
//		print(resultJsonString)
	}

	public mutating func rerun() {
		guard let validLastUrls = self.lastActiveFilePaths else {
			fatalError()
		}
		self.run(filePaths: validLastUrls)
	}


	init() {
		self.results = [:]

	}

}
