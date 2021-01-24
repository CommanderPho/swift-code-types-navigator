//
//  main.swift
//  SwiftDiagramGenerator
//
//  Created by Jovan Jovanovski on 12/25/17.
//

import Foundation
import SwiftDiagramComponentsGenerator

let arguments = CommandLine.arguments
let numArgs = arguments.count
if (numArgs < 3) {
	fatalError("./SwiftDiagramGenerator outputDir inputDirs ...")
}
let visualizationDirectoryPath = arguments[1] + "/Visualization/"
let fileSystemItemsPaths = Array(arguments[2...])
let fileSystemItemsUrlPaths = fileSystemItemsPaths.map({ URL(fileURLWithPath: $0) })
let swiftFilePaths = FileSystemHelper.getFlattenedSwiftFilePaths(inFileSystemItemPaths: fileSystemItemsUrlPaths)

let result = Generator.generateSwiftDiagramComponents(forSwiftFilesAtPaths: swiftFilePaths.map({ $0.path }))
let resultJsonString = jsonString(fromObject: result)

var diagramScriptTemplateFileContents = try! String(contentsOfFile:
    visualizationDirectoryPath + "diagramScriptTemplate")
diagramScriptTemplateFileContents =
    diagramScriptTemplateFileContents.replacingOccurrences(
        of: "$entitiesAndRelationships", with: resultJsonString)
try! diagramScriptTemplateFileContents.write(
    toFile: visualizationDirectoryPath + "diagram.js",
    atomically: false,
    encoding: .utf8)

executeShellCommand(arguments: "open", visualizationDirectoryPath + "diagram.html")

print(resultJsonString)
