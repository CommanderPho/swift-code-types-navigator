//
//  ViewController.swift
//  SwiftDiagramGeneratorGraphical
//
//  Created by Pho Hale on 1/19/21.
//

import Cocoa
import DragDroppableViewLib

class ViewController: NSViewController {

	@IBOutlet weak var dragDropView: DragView!


	override func viewDidLoad() {
		super.viewDidLoad()
		dragDropView.fileExtensions = ["swift", ""] // allow .swift files and folders
		// Do any additional setup after loading the view.
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}

}


extension ViewController: DragViewDelegate {

	func dragViewDidReceive(fileURLs: [URL]) {
		print("didRecieve: fileURLs: \(fileURLs)")
		guard let validAppDelegate = NSApp.delegate as? AppDelegate else {
			fatalError()
		}
		// tell the AppDelegate to run, which will generate the file
		validAppDelegate.performTryRun(filePaths: fileURLs)
	}

	



}

