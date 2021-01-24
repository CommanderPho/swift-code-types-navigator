//  
//  vcCodeDependenciesSearch.swift
//  SwiftDiagramGeneratorGraphical
//
//  Created by Pho Hale on 1/24/21.
//

import Foundation
import Cocoa


class vcCodeDependenciesSearch: NSViewController {

    @IBOutlet weak var mainTable: NSTableView!

    //static var tableCellIdentifier: String = "tableCellSearchItemClassID"

    var selectionName: String = ""
    private var selectionIndex: Int? = nil


    override func viewDidLoad() {
        super.viewDidLoad()

        //Uncomment if the cell is loaded from a xib file.
        //let nib = UINib(nibName: "tvcCodeSearchItem", bundle: nil)
        // mainTable.register(nib, forCellReuseIdentifier: tableCellIdentifier)

//        mainTable.tableFooterView = NSView(frame: CGRect.zero)
    }

    func update() {
        self.mainTable.reloadData()
    }

    func reset() {
        self.selectionName = ""
        self.selectionIndex = nil
        self.update()
    }


    @IBAction func actionMiddleButtonPressed(_ sender: Any) {
        self.update()
    }

}



//
//extension vcCodeDependenciesSearch: NSTableViewDataSource, NSTableViewDelegate {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return medsMaster.count
//    }
//
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> TableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath) as! cellType
//
//        let rowMedication = medsMaster[indexPath.row]
//        //cell?.textLabel?.text = rowMedication.name
//        //cell?.textLabel?.font = UIFont .boldSystemFontOfSize(50)
//        cell.lblMedName.text = rowMedication.name
//        cell.lblInfoString.text = rowMedication.getDetailString()
//        cell.imgMedPic?.image = rowMedication.image
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let rowValue = medsMaster[indexPath.row]
//        let message = "You selected \(rowValue.name)"
//        debugInfo(message)
//
//        //            let controller = UIAlertController(title: "Row Selected",
//        //                message: message, preferredStyle: .alert)
//        //            let action = UIAlertAction(title: "Yes I Did",
//        //                style: .default, handler: nil)
//        //            controller.addAction(action)
//        //
//        //            present(controller, animated: true, completion: nil)
//    }
//
//
//
//}
//
