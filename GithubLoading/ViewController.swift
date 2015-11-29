//
//  ViewController.swift
//  GithubLoading
//
//  Created by Nuno Gonçalves on 29/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var table: UITableView!
    
    let cells = ["Cell 1", "Cell 2", "Cell 3", "Cell 4", "Cell 5", "Cell 6"]
    
    var refreshControl: UIRefreshControl!
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idCell", forIndexPath: indexPath) 
        
        cell.textLabel!.text = cells[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    var loadingView: GithubLoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.clearColor()
        refreshControl.tintColor = UIColor.clearColor()
        
        table.addSubview(refreshControl)
        table.layoutIfNeeded()
        
        loadingView = GithubLoadingView(frame: refreshControl.bounds)
        refreshControl.addSubview(loadingView)
    }

    var customView: UIView!
    
    var isAnimating = false
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if refreshControl.refreshing {
            loadingView.setLoading()
        } else {
            let y = scrollView.contentOffset.y
            let perc = y * 100 / 220
            loadingView.setStaticWith(Int(abs(perc)))
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if refreshControl.refreshing {
            if !isAnimating {
                doSomething()
            }
        }
    }
    
    var timer: NSTimer!
    
    func doSomething() {
        timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "endOfWork", userInfo: nil, repeats: true)
    }
    
    
    func endOfWork() {
        refreshControl.endRefreshing()
        
        timer.invalidate()
        timer = nil
    }
    
}

