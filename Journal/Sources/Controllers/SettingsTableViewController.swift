//
//  SettingsTableViewController.swift
//  Journal
//
//  Created by 윤진서 on 2018. 8. 20..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import UIKit

class SettingsViewViewModel {
    let environment: Environment
    
    init(environment: Environment) {
        self.environment = environment
    }
}

class SettingsTableViewController: UITableViewController {
    var viewModel: SettingsViewViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reloadData()
        
        DateFormatOption.all.enumerated().forEach { idx, dateFormat in
            let cell = tableView.cellForRow(at: IndexPath(row: idx, section: 0))
            cell?.accessoryType = dateFormat == viewModel.environment.settings.dateFormat ? .checkmark : .none
        }
        
        FontSizeOption.all.enumerated().forEach { idx, fontSize in
            let cell = tableView.cellForRow(at: IndexPath(row: idx, section: 1))
            cell?.accessoryType = fontSize == viewModel.environment.settings.fontSize ? .checkmark : .none
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let numberOfRows = self.tableView(tableView, numberOfRowsInSection: indexPath.section)
        
        for row in (0..<numberOfRows) {
            let cell = tableView.cellForRow(at: IndexPath(row: row, section: indexPath.section))
            cell?.accessoryType = indexPath.row == row ? .checkmark : .none
        }
    }
}
