//
//  ViewController.swift
//  SnapMe
//
//  Created by Aaron Kroupa on 11/15/16.
//  Copyright © 2016 Aaron Kroupa. All rights reserved.
//

import UIKit

protocol SnapCellDelegate {
    func showSnap(_ snapCell: SnapCell)
    func hideSnap(_ snap: SnapData)
    func refreshTableAt(_ snap: SnapData)
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate, SnapCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    private var data = [SnapData]()
    private var temp: [SnapData]? = nil
    
    private var searchController: UISearchController?
    private var quitAnimation: Bool = false
    
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
        if temp != nil {
            data = temp!
            temp = nil
            tableView.reloadData()
        }
        
        animateColors(refControl, 0, false)
        //let ran = Int(arc4random_uniform(UInt32(6)) + 3)
        let ran = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(ran), execute: {
            self.data.insert(SnapData(), at: 0)
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, YYY - h:mm a"
            let message = "Last Updated \(dateFormatter.string(from: Date()))"
            let attributed = NSMutableAttributedString(string: message)
            attributed.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: (message as NSString).range(of: message))
            refControl.attributedTitle = attributed
            
            self.quitAnimation = true
        })
    }
    
    private func animateColors(_ refControl: UIRefreshControl, _ color: Int, _ done: Bool) {
        let colors = [ UIColor(red: 190/255, green: 62/255, blue: 62/255, alpha: 1), UIColor(red: 124/255, green: 62/255, blue: 190/255, alpha: 1), UIColor(red: 62/255, green: 62/255, blue: 190/255, alpha: 1), UIColor(red: 62/255, green: 190/255, blue: 190/255, alpha: 1), UIColor(red: 190/255, green: 190/255, blue: 62/255, alpha: 1) ]
        UIView.animate(withDuration: 0.75, delay: 0, options: .curveEaseInOut, animations: {
            refControl.backgroundColor = color == -1 ? UIColor.gray : colors[color]
            self.tableView.backgroundColor = color == -1 ? UIColor.gray : colors[color]
        }, completion: { _ in
            if done { refControl.endRefreshing(); return }
            if self.quitAnimation {
                self.quitAnimation = false
                self.animateColors(refControl, -1, true)
                return
            }
            self.animateColors(refControl, (color + 1) < (colors.count) ? color + 1 : 0, false)
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if temp == nil {
            temp = data
        }
        
        if let text = searchController.searchBar.text {
            if text == "" {
                data = temp!
            } else {
                data = temp!.filter({ x in x.getName().contains(text) })
            }
            
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        data = temp!
        temp = nil
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text!
        searchController?.isActive = false
        
        // Clobber the empty string update
        //       from active = false above
        data = temp!.filter({ x in x.getName().contains(text) })
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSnap" {
            let controller = segue.destination as! SnapViewController
            controller.detailItem = sender as? SnapCell
        }
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
        
        cell.delegate = self
        cell.snapData = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func showSnap(_ snapCell: SnapCell) {
        let snap = snapCell.snapData
        print("show \(snap!.getName())")
        snap?.setStatus(.Opened)
        tableView.reloadRows(at: [IndexPath(row: data.index(of: snap!) ?? 0, section: 0)], with: .automatic)
        performSegue(withIdentifier: "showSnap", sender: snapCell)
    }
    
    func hideSnap(_ snap: SnapData) {
        print("hide \(snap.getName())")
        snap.hide()
        dismiss(animated: true, completion: nil)
        tableView.reloadRows(at: [IndexPath(row: data.index(of: snap) ?? 0, section: 0)], with: .automatic)
    }
    
    func refreshTableAt(_ snap: SnapData) {
        tableView.reloadRows(at: [IndexPath(row: data.index(of: snap) ?? 0, section: 0)], with: .automatic)
    }
}

