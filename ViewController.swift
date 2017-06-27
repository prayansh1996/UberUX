//
//  ViewController.swift
//  UberUX
//
//  Created by Pawan on 05/06/17.
//  Copyright © 2017 Pawan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var backView: UIView!
    @IBOutlet var timelineView: UIView!
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var tableV: UITableView!
    @IBOutlet weak var timelineViewWidth: NSLayoutConstraint!
    
    var refreshControl: UIRefreshControl!
    var initialTimelineViewCenterY = CGFloat(0)
    var rangeForTransition = CGFloat(0)
    
    var isAtTop: Bool {
        get {
            return timelineViewYCenter == self.view.center.y ? true : false
        }
    }
    
    var timelineViewYCenter: CGFloat {
        get {
            return timelineView.center.y
        } set {
            timelineView.center.y = newValue
            updateFrames(withValue: newValue)
        }
    }
    
    func updateFrames(withValue value: CGFloat) {
        backView.alpha = (initialTimelineViewCenterY - value) / (rangeForTransition)
        //timelineViewWidth.constant = self.view.frame.width - 32 * (timelineViewYCenter - self.view.center.y) / (rangeForTransition)
    }
    
    var timelineViewYTop: CGFloat {
        get {
            return timelineViewYCenter - timelineView.frame.height/2
        }
    }
    
    override func viewDidLayoutSubviews() {
        print("Non Updated Center: \(timelineViewYCenter)")
        timelineView.center.y = backgroundView.frame.height + timelineView.frame.height / 2
        initialTimelineViewCenterY = timelineViewYCenter
        rangeForTransition = initialTimelineViewCenterY - self.view.center.y
        timelineViewWidth.constant = self.view.frame.width - 32.0
        print("Updated Center: \(timelineViewYCenter)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableV.dataSource = self
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.clear
        refreshControl.addTarget(self, action: #selector(ViewController.refresh), for: UIControlEvents.valueChanged)
        tableV.addSubview(refreshControl) // not required when using UITableViewController
    }

    let paddingFromViewsCenter = CGFloat(50)
    
    @IBAction func didTapOnTimelineHeader(_ sender: UITapGestureRecognizer) {
        if isAtTop {
            moveBack(view: timelineView)
        } else {
            moveToTop(view: timelineView)
        }
    }
    
    @IBAction func performPanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        //print(timelineViewYCenter)
        //print("Trigger: \(timelineViewYTop - (self.view.center.y - paddingFromViewsCenter))")
        
        if gestureRecognizer.state == .ended {
            //print(timelineViewYTop)
            if timelineViewYTop <= self.view.center.y - paddingFromViewsCenter {
                moveToTop(view: timelineView)
            } else {
                moveBack(view: timelineView)
            }
            
        }
        
        
        let translation = gestureRecognizer.translation(in: self.view).y
        timelineViewYCenter += translation
        
        
        if timelineViewYCenter >= initialTimelineViewCenterY {
            timelineViewYCenter = initialTimelineViewCenterY
        } else if timelineViewYCenter <= self.view.center.y {
            timelineViewYCenter = self.view.center.y
        }
        gestureRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)

    }
    
    func refresh() {
        moveBack(view: timelineView)
        refreshControl.endRefreshing()
    }
    
    func moveToTop(view: UIView) {
        UIView.animate(withDuration: 0.3 , delay: 0.0, options: .curveEaseOut, animations: {
            view.center.y = self.view.center.y
            self.backView.alpha = 1
        })
    }
    
    func moveBack(view: UIView) {
        UIView.animate(withDuration: 0.4 , delay: 0.0, options: .curveEaseOut, animations: {
            view.center.y = self.initialTimelineViewCenterY
            self.backView.alpha = 0
        })
    }
    
    //TableView Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Cell: \(indexPath.row)"
        return cell
    }
}






//    enum TranslateDirections {
//        case up
//        case down
//        case none
//    }
//
//    var translateDirection = TranslateDirections.none

//        let heightConstraint = NSLayoutConstraint(item: timelineView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height)
//        view.addConstraints([heightConstraint])



//
//        if gestureRecognizer.state == UIGestureRecognizerState.began || gestureRecognizer.state == UIGestureRecognizerState.changed {
//
//            let translation = gestureRecognizer.translation(in: self.view)
//
//            if(gestureRecognizer.view!.center.y < 555) {
//                timelineView.center = CGPoint(x: gestureRecognizer.view!.center.x, y: gestureRecognizer.view!.center.y + translation.y)
//            }else {
//                timelineView.center = CGPoint(x: gestureRecognizer.view!.center.x, y: 554)
//            }
//
//            gestureRecognizer.setTranslation(CGPoint(x: 0, y: 0),  in: self.view)
//
//        }
//

//      let location = gestureRecognizer.location(in: self.view)
//        backView.alpha = 1.0 - ((location.y - 100) / 520)
//        print(timelineView.center.y - location.y)
//        timelineView.transform = CGAffineTransform(translationX: 0, y: -(timelineView.center.y - location.y))

//        backView.alpha = 1.0 - ((timelineViewOriginY - 100) / 520)
//        print(timelineView.center)
//        print(gestureRecognizer.translation(in: self.view).y)
        
