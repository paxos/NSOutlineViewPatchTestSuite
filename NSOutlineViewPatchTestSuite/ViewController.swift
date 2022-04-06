//
//  ViewController.swift
//  NSOutlineViewPatchTestSuite
//
//  Created by Patrick Dinger on 4/4/22.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet var tableView: NSTableView!
    var data = ["1", "2", "3"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func runScenarioCustomSO(from: [String], to: [String]) -> [String] {
        let patches = to.difference(from: from).steps
        data = to
        tableView.beginUpdates()
        for step in patches {
            switch step {
            case let .remove(_, index):
                print("Remove ", index)
                tableView.removeRows(at: [index])
            case let .insert(_, index):
                print("Insert ", index)
                tableView.insertRows(at: [index])
            case let .move(_, from, to):
                print("Move ", from, to)
                tableView.moveRow(at: from, to: to)
            }
        }

        tableView.endUpdates()
        return dataFromTableState()
    }

    func dataFromTableState() -> [String] {
        var data = [String]()
        if tableView.numberOfRows > 0 {
            for row in 0 ... tableView.numberOfRows - 1 {
                if let valueOfView = (tableView.view(atColumn: 0, row: row, makeIfNecessary: false) as? NSTableCellView)?.textField?.objectValue as? String {
                    data.append(valueOfView)
                } else {
                    print("Did not find a value for row ", row)
                }
            }
        }
        return data
    }
}

extension ViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return data.count
    }
}

extension ViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
//        print("viewFor:row", row, data[row])
        let view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "view"), owner: tableView) as! NSTableCellView
        view.textField?.stringValue = data[row]
        return view
    }
}
