//
//  ViewController.swift
//  SnapMe
//
//  Created by Aaron Kroupa on 11/15/16.
//  Copyright © 2016 Aaron Kroupa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    private var data = [SnapData]()
    
    private var searchController: UISearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Refresh
        let refControl = UIRefreshControl()
        refControl.backgroundColor = UIColor.gray
        refControl.tintColor = UIColor.white
        refControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        let message = "Last Updated Never"
        let attributed = NSMutableAttributedString(string: message)
        attributed.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: (message as NSString).range(of: message))
        refControl.attributedTitle = attributed
        tableView.addSubview(refControl)

        // Search
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        
        let bar = searchController!.searchBar
        bar.delegate = self
        bar.placeholder = "Search Snaps"
        bar.sizeToFit()
        tableView.tableHeaderView?.backgroundColor = UIColor.purple
        tableView.tableHeaderView = bar
        
        tableView.backgroundColor = UIColor.gray
        // Remove tableview margins (they give weird left indents)
        tableView.layoutMargins = .zero
        tableView.separatorInset = .zero
    }

    func refresh(_ refControl: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(arc4random_uniform(UInt32(6)) + 3)), execute: {
            self.data.insert(SnapData(), at: 0)
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, YYY - h:mm a"
            let message = "Last Updated \(dateFormatter.string(from: Date()))"
            let attributed = NSMutableAttributedString(string: message)
            attributed.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: (message as NSString).range(of: message))
            refControl.attributedTitle = attributed
            
            refControl.endRefreshing()
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print("Updating")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancelled")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Button CLicked")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = data.count
        // Display empty label if there are no snaps otherwise remove it
        tableView.backgroundView = count == 0 ? emptyLabel : nil
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "snap", for: indexPath) as! SnapCell
        // Remove cell margins as well because they also attribute to left indents
        cell.contentView.layoutMargins = .zero
        cell.layoutMargins = .zero
        
        let snap = data[indexPath.row]
        cell.icon.image = snap.isConsumed() ? #imageLiteral(resourceName: "viewed") : #imageLiteral(resourceName: "received")
        cell.nameLabel.text = snap.getName()
        cell.statusLabel.text = snap.getStatus()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

