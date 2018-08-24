//
//  TimelineViewController.swift
//  Journal
//
//  Created by 윤진서 on 2018. 8. 11..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {
    @IBOutlet weak var tableview: UITableView!
    
    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    var viewModel: TimelineViewControllerModel!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case .some("addEntry"):
            if let vc = segue.destination as? EntryViewController {
                vc.viewModel = viewModel.newEntryViewViewModel()
            }
            
        case .some("showEntry"):
            if
                let vc = segue.destination as? EntryViewController,
                let selectedIP = tableview.indexPathForSelectedRow {
                vc.viewModel = viewModel.entryViewModel(for: selectedIP)
            }
            
        case .some("showSetting"):
            if
                let vc = segue.destination as? SettingsTableViewController {
                vc.viewModel = viewModel.settingsViewModel
            }
            
        default:
            break
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.title
        tableview.dataSource = self
        tableview.delegate = self
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "일기 검색"
        searchController.searchBar.tintColor = .white
        searchController.searchBar.autocapitalizationType = .none
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableview.reloadData()
    }
}

extension TimelineViewController: UITableViewDataSource {
    var isSearchingEntries: Bool {
        return searchController.isActive && searchController.searchBar.text?.isEmpty == false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard isSearchingEntries == false else { return 1}
        return viewModel.numberOfDates
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard isSearchingEntries == false else { return nil }
        return viewModel.headerTitle(of: section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard isSearchingEntries == false else { return viewModel.filteredEntryCellModels.count }
        return viewModel.numberOfItems(of: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryTableViewCell
        cell.viewModel = isSearchingEntries
            ? viewModel.filteredEntryCellModels[indexPath.row]
            : viewModel.entryTableViewCellModel(for: indexPath)
        
        return cell
    }
}

extension TimelineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  nil) { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let isLastEntryInSection = self.viewModel.numberOfItems(of: indexPath.section) == 1
            self.viewModel.removeEntry(at: indexPath)
            
            UIView.animate(withDuration: 0.3) {
                tableView.beginUpdates()
                if isLastEntryInSection {
                    tableView.deleteSections(IndexSet.init(integer: indexPath.section), with: .automatic)
                } else {
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
                tableView.endUpdates()
            }
            
            success(true)
        }
        
        deleteAction.image = #imageLiteral(resourceName: "baseline_delete_white_24pt")
        deleteAction.backgroundColor = UIColor.gradientEnd
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension TimelineViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.searchEntries(contains: searchText)
        tableview.reloadData()
    }
}
