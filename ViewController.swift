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
    @IBOutlet weak var burgerKingLabel: UILabel!
    @IBOutlet weak var headerButton: UIButton!
    
    var refreshControl: UIRefreshControl!
    var initialTimelineViewCenterY = CGFloat(0)
    var initialTimelineViewOriginX = CGFloat(0)
    var initialTimelineViewWidth = CGFloat(0)
    var initialBurgerKingCenterX = CGFloat(0)
    var rangeForTransition = CGFloat(0)
    var paddingFromTop = CGFloat(16)
    
    
    var isAtTop: Bool {
        get {
            return timelineViewCenterY == self.view.center.y + paddingFromTop ? true : false
        }
    }
    
    var timelineViewCenterY: CGFloat {
        get {
            return timelineView.center.y
        } set {
            timelineView.center.y = newValue
            updateFrames(withValue: newValue)
        }
    }
    
    func updateFrames(withValue center: CGFloat) {
        let transition = (initialTimelineViewCenterY - center) / (rangeForTransition)
        backView.alpha = transition
        headerButton.alpha = transition
        /*
        let newOrigin = initialTimelineViewOriginX - 8 * transition
        let newWidth = initialTimelineViewWidth + 16 * transition
        
        var frameForTimelineView = self.timelineView.frame
        var frameForHeaderView = self.timelineView.viewWithTag(101)?.frame
        var frameForTableView = self.timelineView.viewWithTag(102)?.frame

        frameForTimelineView.origin.x = newOrigin
        frameForTimelineView.size.width = newWidth
        self.timelineView.frame = frameForTimelineView
        
        frameForHeaderView?.origin.x = newOrigin
        frameForHeaderView?.size.width = newWidth
        self.timelineView.viewWithTag(101)?.frame = frameForHeaderView!
        
        frameForTableView?.origin.x = newOrigin
        frameForTableView?.size.width = newWidth
        self.timelineView.viewWithTag(102)?.frame = frameForTableView!
        */
        
        self.burgerKingLabel.center.x = initialBurgerKingCenterX + transition * (self.view.center.x - initialBurgerKingCenterX) //+ 8.0 * transition
        //timelineViewWidth.constant = self.view.frame.width - 32 * (timelineViewCenterY - self.view.center.y) / (rangeForTransition)
    }
    
    var timelineViewTopY: CGFloat {
        get {
            return timelineViewCenterY - timelineView.frame.height/2
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("Non Updated Center: \(timelineViewCenterY)")
        timelineView.center.y = backgroundView.frame.height + timelineView.frame.height / 2
        print("Updated Center: \(timelineViewCenterY)")
        
        initialTimelineViewCenterY = timelineViewCenterY
        initialTimelineViewOriginX = timelineView.frame.origin.x
        initialTimelineViewWidth = timelineView.frame.width
        
        rangeForTransition = initialTimelineViewCenterY - self.view.center.y
        initialBurgerKingCenterX = burgerKingLabel.center.x
        headerButton.isEnabled = false
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
        
        //print(timelineViewCenterY)
        //print("Trigger: \(timelineViewTopY - (self.view.center.y - paddingFromViewsCenter))")
        
        if gestureRecognizer.state == .ended {
            //print(timelineViewTopY)
            if timelineViewTopY <= self.view.center.y - paddingFromViewsCenter {
                moveToTop(view: timelineView)
            } else {
                moveBack(view: timelineView)
            }
            
        }
        
        
        let translation = gestureRecognizer.translation(in: self.view).y
        timelineViewCenterY += translation
        
        if timelineViewCenterY >= initialTimelineViewCenterY {
            timelineViewCenterY = initialTimelineViewCenterY
        } else if timelineViewCenterY <= self.view.center.y {
            timelineViewCenterY = self.view.center.y + paddingFromTop
        }
        gestureRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)

    }
    
    func refresh() {
        moveBack(view: timelineView)
        refreshControl.endRefreshing()
    }
    
    func moveToTop(view: UIView) {
        UIView.animate(withDuration: 0.3 , delay: 0.0, options: .curveEaseOut, animations: {
            view.center.y = self.view.center.y + self.paddingFromTop
            self.updateFrames(withValue: self.timelineViewCenterY)
            self.headerButton.isEnabled = true
        })
    }
    
    func moveBack(view: UIView) {
        UIView.animate(withDuration: 0.4 , delay: 0.0, options: .curveEaseOut, animations: {
            view.center.y = self.initialTimelineViewCenterY
            self.updateFrames(withValue: self.timelineViewCenterY)
            self.headerButton.isEnabled = false
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
        
