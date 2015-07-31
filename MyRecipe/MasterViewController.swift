//
//  MasterViewController.swift
//  MyRecipe
//
//  Created by Zhehan Zhang on 2015-07-14.
//  Copyright (c) 2015 AkhalTech. All rights reserved.
//

import UIKit
import CoreData
import Parse

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var detailViewController: DetailViewController? = nil
    var recipeDictionary = Dictionary<String, String>()

    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        queryForRecipe()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        queryForRecipe()
    }
    
    func queryForRecipe() {
        let query = PFQuery(className: "Recipe")
        query.whereKey("status", equalTo: "Active")
        query.orderByDescending("updatedAt")
        query.findObjectsInBackgroundWithBlock { (results: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                if let results = results as? [PFObject] {
                    for result in results {
                        self.recipeDictionary[result.objectId!] = result.objectForKey("title") as? String
                    }
                }
                
                self.tableView.reloadData()
                
                if let split = self.splitViewController {
                    let controllers = split.viewControllers
                    self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
                    if self.detailViewController != nil {
                        var key: String = Array(self.recipeDictionary.keys)[0]
                        self.detailViewController!.recipeName = self.recipeDictionary[key]!
                        self.detailViewController!.objectId = key
                    }
                }
            }
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
                
                var key: String = Array(recipeDictionary.keys)[indexPath.row]
                controller.recipeName = recipeDictionary[key]!
                controller.objectId = key
            }
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeDictionary.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        var key: String = Array(recipeDictionary.keys)[indexPath.row]
        cell.textLabel?.text = recipeDictionary[key]
        return cell
    }

}

