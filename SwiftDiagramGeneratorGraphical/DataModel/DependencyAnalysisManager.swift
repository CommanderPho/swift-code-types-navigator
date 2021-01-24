//
//  DependencyAnalysisManager.swift
//  SwiftDiagramGeneratorGraphical
//
//  Created by Pho Hale on 1/24/21.
//

import Foundation
import Cocoa
import PhoSwiftClassHierarchyAnalyzer
import SwiftGraph


open class DependencyAnalysisManager: NSObject, AnalyzeImplementorProtocol {


	@IBOutlet weak var txtSymbolSearchField: NSSearchField!

	@objc dynamic var resultText: String = ""

	public var analyzer: PhoSwiftClassHierarchyAnalyzer!
	public var objectsDict: [String : Object]!
	public var graph: UnweightedGraph<String>!

	@objc dynamic var isAnalyzerReady: Bool = false


	open override func awakeFromNib() {
		super.awakeFromNib()
		self.setup()
	}

	public override init() {
		super.init()
		self.setup()
	}

	deinit {
		fatalError()
	}

	public func setup() {
		self.setupAnalyzer()
//		self.txtSymbolSearchField.delegate = self
		if (self.txtSymbolSearchField == nil) {
			return
		}
		self.txtSymbolSearchField.placeholderString = "TEST STRING"
	}


	private func setupAnalyzer() {
		// Do general background graph setup:
		self.isAnalyzerReady = false
		self.analyzer = PhoSwiftClassHierarchyAnalyzer();
		self.objectsDict = self.analyzer.dependencies.objects //  [String : Object]
		self.graph = self.analyzer.dependenciesGraph
		print("loaded analyzer with:\n\t linksCount: \(self.analyzer.dependencies.linksCount)")
		print("\t objects: \(self.objectsDict.keys.count)")
		self.isAnalyzerReady = true
	}


	// main function called to perform a search for the given symbol
	public func performSearch(forText symbolText: String) {
		if (!self.isAnalyzerReady) {
//			fatalError("not ready!")
			print("not ready!")
		}
		else {
			// indicate that we're about to use the parser
			self.isAnalyzerReady = false
		}
		print("performing search: \(symbolText)!!!")
		let representedString: String

		do {
			let foundDependencies = try self.analyzer.findDependencies(className: symbolText, upToOrder: 2)
			representedString = foundDependencies.joined(separator: ", ")

		} catch let error {
			print("error performing analysis for symbolText: \(symbolText). Error: \(error.localizedDescription)")
			representedString = "\(error.localizedDescription)"
		}
		print("done! result: \(representedString)")
		self.resultText = representedString
		self.isAnalyzerReady = true // indicate that we're ready again
	}



	////////////////////////////////////////////////////////////////////
	//MARK: -
	//MARK: - Actions:
	@IBAction func actionSymbolSearchPerformed(_ sender: NSSearchField) {
		let searchString = sender.stringValue
		print("actionSymbolSearchPerformed(searchString: \"\(searchString)\")...")
		self.performSearch(forText: searchString)
	}
}



extension DependencyAnalysisManager: NSSearchFieldDelegate {

	public func searchFieldDidStartSearching(_ sender: NSSearchField) {
		print("searchFieldDidStartSearching(...)")
	}


	public func searchFieldDidEndSearching(_ sender: NSSearchField) {
		let searchString = sender.stringValue
		print("searchFieldDidEndSearching(searchString: \"\(searchString)\")...")
		self.performSearch(forText: searchString)
	}


}
