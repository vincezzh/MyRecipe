//
//  DetailViewController.swift
//  MyRecipe
//
//  Created by Zhehan Zhang on 2015-07-14.
//  Copyright (c) 2015 AkhalTech. All rights reserved.
//

import UIKit
import Parse

class DetailViewController: UIViewController {

    @IBOutlet weak var titleNavItem: UINavigationItem!
    @IBOutlet weak var webView: UIWebView!
    
    var recipeName = ""
    var objectId = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if objectId != "" {
            titleNavItem.title = recipeName
            
            let query = PFQuery(className: "Recipe")
            query.getObjectInBackgroundWithId(objectId, block: { (result: PFObject?, error: NSError?) -> Void in
                if error == nil {
                    self.webView.loadHTMLString(result?.objectForKey("content") as! String, baseURL: nil)
                }
            })
        }
    }


}

