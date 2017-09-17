//
//  EmotionsViewController.swift
//  Faceit
//
//  Created by Aashita on 9/13/17.
//  Copyright © 2017 aashita. All rights reserved.
//

import UIKit

class EmotionsViewController: VCLLoggingViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //what segue (identifier) and what MVC destination

        var destinationViewController = segue.destination
        if let navigationController = destinationViewController as? UINavigationController {
            destinationViewController = navigationController.visibleViewController ?? destinationViewController //default
        }
        //works whether it goes to navigation controller or straight to face view 
        
        if let faceViewController = destinationViewController as? FaceViewController, //check if it is of that type, if not nothing
            let identifier = segue.identifier,  //in case forgot to set identifier
                let expression = emotionalFaces[identifier] //if let in case it comes out nil
                {
                    faceViewController.expression = expression //connecting the two controllers
                    faceViewController.navigationItem.title = "I am \(((sender as? UIButton)?.currentTitle)!)"
                }

        
    }
    
    
    private let emotionalFaces: Dictionary<String, FacialExpression> = [
        "sad" : FacialExpression(eyes: .closed, mouth: .frown),
        "happy" : FacialExpression(eyes: .open, mouth: .smile),
        "worried" : FacialExpression(eyes: .open, mouth: .smirk)
    ] //square brackets for dictionary
}
