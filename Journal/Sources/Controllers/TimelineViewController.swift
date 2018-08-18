//
//  TimelineViewController.swift
//  Journal
//
//  Created by JinSeo Yoon on 2018. 8. 18..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {
    @IBOutlet weak var tableview: UITableView!
    
    var environment: Environment!
    private var entries: [Entry] = []
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case "addEntry":
            let entryVC = segue.destination as? EntryViewController
            entryVC?.environment = environment
            entryVC?.delegate = self
            
        case "showEntry":
            if 
                let entryVC = segue.destination as? EntryViewController,
                let selectedIndexPath = tableview.indexPathForSelectedRow {
                entryVC.environment = environment
                let entry = entries[selectedIndexPath.row]
                entryVC.editingEntry = entry
                entryVC.delegate = self
            }
        
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Journal"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        entries = environment.entryRepository.recentEntries(max: environment.entryRepository.numberOfEntries)
        
        tableview.reloadData()
    }
}

extension TimelineViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return environment.entryRepository.numberOfEntries
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableview.dequeueReusableCell(withIdentifier: "EntryTableViewCell", for: indexPath)
        
        let entry = entries[indexPath.row]
        
        tableViewCell.textLabel?.text = entry.text
        tableViewCell.detailTextLabel?.text = DateFormatter.entryDateFormatter.string(from: entry.createdAt)
        
        return tableViewCell
    }
}

extension TimelineViewController: EntryViewControllerDelegate {
    func didRemoveEntry(_ entry: Entry) {
        navigationController?.popViewController(animated: true)
    }
}
