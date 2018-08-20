//
//  SettingsTableViewController.swift
//  Journal
//
//  Created by 윤진서 on 2018. 8. 20..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let numberOfRows = self.tableView(tableView, numberOfRowsInSection: indexPath.section)
        
        for row in (0..<numberOfRows) {
            let cell = tableView.cellForRow(at: IndexPath(row: row, section: indexPath.section))
            cell?.accessoryType = indexPath.row == row ? .checkmark : .none
        }
    }
}
