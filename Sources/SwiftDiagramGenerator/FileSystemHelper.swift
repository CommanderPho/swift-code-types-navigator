//
//  FileSystemHelper.swift
//  SwiftDiagramGenerator
//
//  Created by Jovan Jovanovski on 12/26/17.
//

import Foundation

struct FileSystemHelper {

	// Recurrsively enumerates the flattened directory structure:
    fileprivate static func getFlattenedSwiftFilePathStrings(inFileSystemItemPaths fileSystemItemPaths: [String]) -> [String] {
        if fileSystemItemPaths.isEmpty {
            return fileSystemItemPaths
        }
        
        return fileSystemItemPaths.flatMap {
            fileSystemItemPath -> [String] in
            if fileSystemItemPath.isDirectory {
                return try! FileManager.default.subpathsOfDirectory(
                    atPath: fileSystemItemPath).filter { $0.isSwiftFile }
                    .map { fileSystemItemPath + "/" + $0 }
            }
			// Otherwise, if it's not a directory, just return the file if it's a .swift file:
            return fileSystemItemPath.isSwiftFile ? [fileSystemItemPath] : []
        }
    }

	public static func getFlattenedSwiftFilePaths(inFileSystemItemPaths fileSystemItemPaths: [URL]) -> [URL] {
		return Self.getFlattenedSwiftFilePathStrings(inFileSystemItemPaths: fileSystemItemPaths.map({ $0.path })).map({ URL(fileURLWithPath: $0) })
	}
    
}

private extension String {
    
    var isDirectory: Bool {
        var isDirectory = ObjCBool(false)
        return FileManager.default.fileExists(
            atPath: self, isDirectory: &isDirectory) ?
                isDirectory.boolValue : false
    }
    
    var isSwiftFile: Bool {
        return (self as NSString).pathExtension == "swift"
    }
    
}
