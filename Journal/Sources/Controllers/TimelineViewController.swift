//
//  TimelineViewController.swift
//  Journal
//
//  Created by JinSeo Yoon on 2018. 8. 18..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import UIKit
import SnapKit

class TimelineViewController: UIViewController {
    @IBOutlet weak var tableview: UITableView!
    
    private let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    private let searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    var viewModel: TimelineViewViewModel!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case "addEntry":
            let entryVC = segue.destination as? EntryViewController
            entryVC?.viewModel = viewModel.newEntryViewViewModel
            
        case "showEntry":
            if 
                let entryVC = segue.destination as? EntryViewController,
                let selectedIndexPath = tableview.indexPathForSelectedRow {
                entryVC.viewModel = viewModel.entryViewViewModel(for: selectedIndexPath) 
            }
        
        case "showSetting":
            if 
                let settingsVC = segue.destination as? SettingsTableViewController {
                 settingsVC.viewModel = viewModel.settingsViewModel 
            }
        
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Journal"
        tableview.delegate = self
        
        searchController.searchBar.placeholder = "검색어를 입력하세요"
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.autocapitalizationType = .none
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        
        navigationItem.searchController = searchController
        
        definesPresentationContext = true
        
        view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { 
            $0.center.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        tableview.reloadData()
        
        loadingIndicator.startAnimating()
        
        viewModel.refreshEntries { [weak self] in
            self?.tableview.reloadData()
            self?.loadingIndicator.stopAnimating()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if searchController.isActive {
            viewModel.searchText = nil
            searchController.isActive = false
        }
    }
}

extension TimelineViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.title(for: section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section) 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableview.dequeueReusableCell(withIdentifier: "EntryTableViewCell", for: indexPath) as! EntryTableViewCell 
        tableViewCell.viewModel = viewModel.entryTableViewCellViewModel(for: indexPath)
        return tableViewCell
    }
}

extension TimelineViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPosition = scrollView.contentOffset.y
        let cellHeight: CGFloat = 80
        let threshold: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height - cellHeight
        
        if scrollPosition > threshold && viewModel.isLoading == false && viewModel.isLastPage == false {
            loadingIndicator.startAnimating()
            
            viewModel.loadMoreEntries { [weak self] in
                self?.tableview.reloadData()
                self?.loadingIndicator.stopAnimating()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard searchController.isActive == false else { return UISwipeActionsConfiguration(actions: []) }
        
        let deleteAction = UIContextualAction(style: .normal, title:  nil) { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            let isLastRowInSection = self.viewModel.numberOfRows(in: indexPath.section) == 1
            self.viewModel.removeEntry(at: indexPath)
            
            UIView.animate(withDuration: 0.3) {
                
                tableView.beginUpdates()
                
                if isLastRowInSection {
                    
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
        
        return UISwipeActionsConfiguration(actions: 
            [deleteAction]
        )
    }
}

extension TimelineViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        viewModel.searchText = searchText
        tableview.reloadData()
    }
}
