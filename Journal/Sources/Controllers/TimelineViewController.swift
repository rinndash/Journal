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
    
    private var dates: [Date] = []
    private var entries: [Entry] {
        return environment.entryRepository.recentEntries(max: environment.entryRepository.numberOfEntries)
    }
    private func entries(for day: Date) -> [Entry] {
        return entries.filter { $0.createdAt.hmsRemoved == day }
    }
    private func entry(for indexPath: IndexPath) -> Entry {
        return entries(for: dates[indexPath.section])[indexPath.row]
    }
    
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
                vc.entry = entry(for: selectedIP)
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
        
        dates = entries
            .compactMap { $0.createdAt.hmsRemoved }
            .unique()
        tableview.reloadData()
    }
    
    @IBAction func returnToTimeline(segue: UIStoryboardSegue) { }
}

extension TimelineViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dates.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return DateFormatter.entryDateFormatter.string(from: dates[section])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries(for: dates[section]).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryTableViewCell
        let entry = self.entry(for: indexPath)
        
        cell.entryTextLabel.text = "\(entry.text)"
        cell.detailTextLabel?.text = DateFormatter.timeFormatter.string(from: entry.createdAt)
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let deleteAction = UIContextualAction(style: .normal, title:  nil) { [weak self] (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
//            guard let `self` = self else { success(false); return }
//
//            let date = self.environment.entryRepository.datesWithEntry()[indexPath.section]
//            let entries = self.environment.entryRepository.entries(of: date)
//            self.environment.entryRepository.delete(entries[indexPath.row])
//
//            UIView.animate(withDuration: 0.3) {
//                tableView.beginUpdates()
//                if entries.count == 1 {
//                    tableView.deleteSections(IndexSet.init(integer: indexPath.section), with: .automatic)
//                } else {
//                    tableView.deleteRows(at: [indexPath], with: .automatic)
//                }
//                tableView.endUpdates()
//            }
//
//            success(true)
//        }
//
//        deleteAction.image = #imageLiteral(resourceName: "baseline_delete_white_24pt")
//        deleteAction.backgroundColor = UIColor.gradientEnd
//
//        return UISwipeActionsConfiguration(actions: [deleteAction])
//    }
}
