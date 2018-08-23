//
//  SettingsTableViewController.swift
//  Journal
//
//  Created by 윤진서 on 2018. 8. 20..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    var viewModel: SettingsTableViewViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectOption(at: indexPath)
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionModels.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sectionModels[section].title
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sectionModels[section].cellModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
        let cellModel = viewModel.sectionModels[indexPath.section].cellModels[indexPath.row]
        cell.textLabel?.text = cellModel.title
        cell.textLabel?.font = cellModel.titleFont
        cell.accessoryType = cellModel.isChecked ? .checkmark : .none
        return cell
    }
}
