//
//  ViewController.swift
//  Faceit
//
//  Created by Aashita on 9/11/17.
//  Copyright © 2017 aashita. All rights reserved.
//
//gestures: 
//add gesture recognizer (create the specific one in viewcontroller -->  target: notified when gesture recognized + action: method invoked on recognition, then add to the view)
//add handler, each sub class provides methods for handling
//if it affects only view - handle by view, affect model - handle by controller


import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var faceView: FaceView! {
        didSet { //happens only one when iOS links to view
            let handler = #selector(faceView.changeScale(byReactingTo:))
            let pinchRecognizer = UIPinchGestureRecognizer(target: faceView, action: handler)
            faceView.addGestureRecognizer(pinchRecognizer)
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleEyes(byReactingTo:)))
            tapRecognizer.numberOfTapsRequired = 1 //default
            faceView.addGestureRecognizer(tapRecognizer)
            
            let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(increaseHappiness))
            swipeUpRecognizer.direction = .up
            faceView.addGestureRecognizer(swipeUpRecognizer)
            let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(decreaseHappiness))
            swipeDownRecognizer.direction = .down
            faceView.addGestureRecognizer(swipeDownRecognizer)
            
            updateUI()
        }
    }
    
    func toggleEyes(byReactingTo tapRecognizer: UITapGestureRecognizer) //handler, because affecting model
    {
        if tapRecognizer.state == .ended {
            let eyes: FacialExpression.Eyes = (expression.eyes == .closed) ? .open: .closed
            expression = FacialExpression(eyes: eyes, mouth: expression.mouth)
        }
    }
    
    func increaseHappiness() //swipe gesture is discrete, don't need to look at state
    {
        expression = expression.happier
    }
    
    func decreaseHappiness()
    {
        expression = expression.sadder
    }
    
    var expression = FacialExpression(eyes: .closed, mouth: .frown) //primary job of controller is interprety model for the view
    {
        didSet { //property observers, everytime something in model changes you execute this, initializer doesnt call did set
            updateUI()
        }
    }
    
    private func updateUI()
    {
        switch expression.eyes {
        case .open:
            faceView?.eyesOpen = true //optional chaining, if thing which u put question mark on comes to nil, rest of line is ignored
            //to protect against outlet not being set
        case .closed:
            faceView?.eyesOpen = false
        case .squinting:
            faceView?.eyesOpen = false //since u dont have view to represent this part of mdoel
        }
        
        faceView?.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0 //means if can't find expression.mouth in dictionary (returns nil) set it as 0.0
    
    }
    
    
    
    
    private let mouthCurvatures = [FacialExpression.Mouth.grin: 0.5, .frown:-1.0, .smile: 1.0,.neutral: 0.0, .smirk: -0.5] //creating a dictionary, swift infer for other expressions
    

}

