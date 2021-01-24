//  
//  vcCodeDependenciesSearch.swift
//  SwiftDiagramGeneratorGraphical
//
//  Created by Pho Hale on 1/24/21.
//

import Foundation
import Cocoa


// [String]


public protocol ResultsUpdatedTextDelegate {
	func updateText(string: String)
}

public protocol ResultsTableDelegate {
	func needsUpdate()
}


class vcCodeDependenciesResult: NSViewController, ResultsUpdatedTextDelegate {

	@IBOutlet var txtResult: NSTextView!

	weak var mainWc: wcCodeDependenciesSearch? {
		guard let validWC = self.view.window?.windowController as? wcCodeDependenciesSearch else {
			return nil
		}
		return validWC
	}

	func tryConnectToMainWindowWC() {
		guard let validWC = self.mainWc else {
			return;
		}
		validWC.codeDepMan.textUpdateDelegate = self
	}


	override func viewWillAppear() {
		super.viewDidLoad()
		self.setup()
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		self.setup()
	}


	func setup() {
		self.tryConnectToMainWindowWC()
	}



	// ResultsUpdatedTextDelegate:
	func updateText(string: String) {
		self.txtResult.string = string
		self.txtResult.needsDisplay = true
	}



}

class vcCodeDependenciesSearch: NSViewController, ResultsTableDelegate {

    @IBOutlet weak var mainTable: NSTableView!

	weak var mainWc: wcCodeDependenciesSearch? {
		guard let validWC = self.view.window?.windowController as? wcCodeDependenciesSearch else {
//			fatalError("No WC!")
			return nil
		}
		return validWC
	}

	func tryConnectToMainWindowWC() {
		guard let validWC = self.mainWc else {
			return;
		}
		validWC.codeDepMan.tableUpdateDelegate = self
	}

    //static var tableCellIdentifier: String = "tableCellSearchItemClassID"

    var selectionName: String = ""
    private var selectionIndex: Int? = nil


    override func viewDidLoad() {
        super.viewDidLoad()

        //Uncomment if the cell is loaded from a xib file.
        //let nib = UINib(nibName: "tvcCodeSearchItem", bundle: nil)
        // mainTable.register(nib, forCellReuseIdentifier: tableCellIdentifier)

//        mainTable.tableFooterView = NSView(frame: CGRect.zero)
		self.setup()
    }

	override func awakeFromNib() {
		super.awakeFromNib()
		self.setup()
	}


	func setup() {
		self.tryConnectToMainWindowWC()
	}

    func update() {
        self.mainTable.reloadData()
    }

    func reset() {
        self.selectionName = ""
        self.selectionIndex = nil
        self.update()
    }


	// ResultsTableDelegate:
	func needsUpdate() {
		self.update()
	}



    @IBAction func actionMiddleButtonPressed(_ sender: Any) {
        self.update()
    }

}


extension vcCodeDependenciesSearch: NSTableViewDataSource, NSTableViewDelegate {

	func numberOfRows(in tableView: NSTableView) -> Int {
		return self.mainWc?.codeDepMan.getNumOfResults() ?? 0
	}


	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("resultTableCellID"), owner: self) as? NSTableCellView else {
			fatalError()
		}
		guard let validResultsMan = self.mainWc?.codeDepMan else {
			fatalError()
		}
		let symbolsList = validResultsMan.getAnalyzedSymbolsList()
		cell.textField?.stringValue = symbolsList[row]
		return cell
	}

//	func tableView(_ tableView: NSTableView, dataCellFor tableColumn: NSTableColumn?, row: Int) -> NSCell? {
//		let cell = tableView.cell
//
//	}




	func tableViewSelectionDidChange(_ notification: Notification) {
		let selectedIndex = self.mainTable.selectedRow
		print("You selected \(selectedIndex)")
		guard let validResultsMan = self.mainWc?.codeDepMan else {
			fatalError()
		}
		let symbolsList = validResultsMan.getAnalyzedSymbolsList()
		let selectedSymbol = symbolsList[selectedIndex]
		validResultsMan.performSearch(forText: selectedSymbol)
	}



}

