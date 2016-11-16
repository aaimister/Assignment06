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
   // @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var emptyLabel: UILabel!
    
    private var data = [SnapData]()
    
    private var searchController: UISearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Refresh
        let refControl = UIRefreshControl()
        refControl.backgroundColor = UIColor.purple
        refControl.tintColor = UIColor.white
        refControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refControl)
        tableView.layoutMargins = .zero
        tableView.separatorInset = .zero

        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        
        let bar = searchController!.searchBar
        bar.delegate = self
        bar.placeholder = "Search Snaps" 
        bar.sizeToFit()
        tableView.tableHeaderView = bar
    }

    func refresh(_ refControl: UIRefreshControl) {
        data.insert(SnapData(), at: 0)

        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
        emptyLabel.alpha = 0
        
        refControl.endRefreshing()
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
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "snap", for: indexPath) as! SnapCell
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
 
//    override func viewDidLayoutSubviews() {
//        DispatchQueue.main.async {
//            super.updateViewConstraints()
//            self.tableViewHeightConstraint?.constant = self.tableView.contentSize.height
//        }
//    }
    
}

