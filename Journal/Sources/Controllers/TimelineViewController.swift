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
    
    var environment: Environment!
    
    private var entries: [Entry] = []
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case .some("addEntry"):
            if let vc = segue.destination as? EntryViewController {
                vc.environment = environment
            }
            
        case .some("showEntry"):
            if
                let vc = segue.destination as? EntryViewController,
                let selectedIP = tableview.indexPathForSelectedRow {
                
                vc.environment = environment
                vc.entry = entries[selectedIP.row]
            }
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Journal"
        tableview.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        entries = environment.entryRepository.recentEntries(max: environment.entryRepository.numberOfEntries)
        tableview.reloadData()
    }
}

extension TimelineViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
        
        let entry = entries[indexPath.row]
        cell.textLabel?.text = "\(entry.text)"
        cell.detailTextLabel?.text = DateFormatter.entryDateFormatter.string(from: entry.createdAt)
        
        return cell
    }
}
