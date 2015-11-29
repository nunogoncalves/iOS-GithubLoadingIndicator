//
//  ViewController.swift
//  GithubLoading
//
//  Created by Nuno Gonçalves on 29/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    var loadingView: GithubLoadingView!
    var refreshControl: UIRefreshControl!
    
    let cells = ["Cell 1", "Cell 2", "Cell 3", "Cell 4", "Cell 5", "Cell 6"]
    
    
    var isAnimating = false
    var timer: NSTimer?
    var loadingDuration: NSTimeInterval = 4.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpRefreshControl()
        addRefreshControl()
    }
    
    private func setUpRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.clearColor()
        refreshControl.tintColor = UIColor.clearColor()
        
        refreshControl.addTarget(self, action: "refresh", forControlEvents:.ValueChanged)
        
        addLoadingView()
    }
    
    private func addLoadingView() {
        loadingView = GithubLoadingView(frame: refreshControl.bounds)
        refreshControl.addSubview(loadingView.view)
    }
    
    private func addRefreshControl() {
        table.addSubview(refreshControl)
        table.layoutIfNeeded()
    }
    
    func refresh() {
        loadingView.setLoading()
    }
    
    func setUpTimer() {
        timer = NSTimer.scheduledTimerWithTimeInterval(
            loadingDuration,
            target: self,
            selector: "endOfWork",
            userInfo: nil,
            repeats: true)
    }
    
    
    func endOfWork() {
        refreshControl.endRefreshing()
        
        timer?.invalidate()
        timer = nil
    }
}

extension ViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idCell", forIndexPath: indexPath)
        
        cell.textLabel!.text = cells[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
}

extension ViewController : UITableViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if refreshControl.refreshing {
            loadingView.setLoading()
        } else {
            let y = scrollView.contentOffset.y
            let perc = y * 100 / 220
            loadingView.setStaticWith(Int(abs(perc)), offset: y)
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if refreshControl.refreshing {
            if !isAnimating {
                setUpTimer()
            }
        }
    }
}

