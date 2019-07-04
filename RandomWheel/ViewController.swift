//
//  ViewController.swift
//  RandomWheel
//
//  Created by Antoine Proux on 01/07/2019.
//  Copyright © 2019 Antoine Proux. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var wheelImageView: UIImageView!
    @IBOutlet weak var cursor: UIImageView!
    @IBOutlet weak var sliderControl: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var activityLabelBackground: UIImageView!
    @IBOutlet weak var categoryBanner: UIImageView!
    @IBOutlet weak var instructionLabel: UILabel!
    // FOR DATA
    var actualAngle: Double! = 0.0
    var randomNumber: Int!
    var position: Int! = 1
    var activityIsHidden: Bool = false
    var numberOfTurns: Int! = 0
    var category: String!
    var activity: String!
    let categories: [String] = ["Jeux de société", "Compétition", "Reflexion", "Sciences", "Arts créatifs", "Sport", "Bricolage", "Cuisine"]
    let activities: [String: Array<String>] = [
        "Jeux de société":
            ["Jeux de société 1", "Jeux de société 2", "Jeux de société 3", "Jeux de société 4","Jeux de société 5", "Jeux de société 6", "Jeux de société 7", "Jeux de société 8","Jeux de société 9", "Jeux de société 10", "Jeux de société 11", "Jeux de société 12","Jeux de société 13", "Jeux de société 14", "Jeux de société 15", "Jeux de société 16"],
        "Compétition": ["Compétition 1", "Compétition 2", "Compétition 3", "Compétition 4","Compétition 5", "Compétition 6", "Compétition 7", "Compétition 8","Compétition 9", "Compétition 10", "Compétition 11", "Compétition 12","Compétition 13", "Compétition 14", "Compétition 15", "Compétition 16"],
        "Reflexion": ["Réflexion 1", "Réflexion 2", "Réflexion 3", "Réflexion 4","Réflexion 5", "Réflexion 6", "Réflexion 7", "Réflexion 8","Réflexion 9", "Réflexion 10", "Réflexion 11", "Réflexion 12","Réflexion 13", "Réflexion 14", "Réflexion 15", "Réflexion 16"],
        "Sciences": ["Sciences 1", "Sciences 2", "Sciences 3", "Sciences 4","Sciences 5", "Sciences 6", "Sciences 7", "Sciences 8","Sciences 9", "Sciences 10", "Sciences 11", "Sciences 12","Sciences 13", "Sciences 14", "Sciences 15", "Sciences 16"],
        "Arts créatifs": ["Arts créatifs 1", "Arts créatifs 2", "Arts créatifs 3", "Arts créatifs 4","Arts créatifs 5", "Arts créatifs 6", "Arts créatifs 7", "Arts créatifs 8","Arts créatifs 9", "Arts créatifs 10", "Arts créatifs 11", "Arts créatifs 12","Arts créatifs 13", "Arts créatifs 14", "Arts créatifs 15", "Arts créatifs 16"],
        "Sport": ["Sport 1", "Sport 2", "Sport 3", "Sport 4","Sport 5", "Sport 6", "Sport 7", "Sport 8","Sport 9", "Sport 10", "Sport 11", "Sport 12","Sport 13", "Sport 14", "Sport 15", "Sport 16"],
        "Bricolage": ["Bricolage 1", "Bricolage 2", "Bricolage 3", "Bricolage 4","Bricolage 5", "Bricolage 6", "Bricolage 7", "Bricolage 8","Bricolage 9", "Bricolage 10", "Bricolage 11", "Bricolage 12","Bricolage 13", "Bricolage 14", "Bricolage 15", "Bricolage 16"],
        "Cuisine": ["Cuisine 1", "Cuisine 2", "Cuisine 3", "Cuisine 4","Cuisine 5", "Cuisine 6", "Cuisine 7", "Cuisine 8","Cuisine 9", "Cuisine 10", "Cuisine 11", "Cuisine 12","Cuisine 13", "Cuisine 14", "Cuisine 15", "Cuisine 16"],
        
                                        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cursorStartRotation()
        hiddenCategoriesLabelAndImage()
    }

    
    

    
    // MARK: - UI Methods
    func hiddenCategoriesLabelAndImage() {
        if !activityIsHidden {
            categoryBanner.fadeOut()
            categoryLabel.fadeOut()
            resultImage.fadeOut()
            activityLabel.fadeOut()
            activityLabelBackground.fadeOut()
            activityIsHidden = true
        }
    }
        
    func showCategoriesLabel(){
        if activityIsHidden {
            categoryBanner.fadeIn(0.8)
            categoryLabel.fadeIn(0.8)
            resultImage.image = UIImage(named: String(position))
            resultImage.fadeIn(0.8)
            activityLabel.fadeIn(delay: 0.8)
            activityLabelBackground.fadeIn()
            activityIsHidden = false
        }
    }
    
    func displayCategoryResult() {
        getTheCategory()
        categoryLabel.text = category
        showCategoriesLabel()
        displayActivityResult()
    }
    
    func displayActivityResult(){
        if var array = activities[category] {
            array.shuffle()
            let activityChoosen: Int = getRandomNumber(array.count)
            self.activityLabelAnimation(0, array, 20, 0, activityChoosen: activityChoosen)
        }
    }
    
    func getTheCategory(){
        let newPosition = position + numberOfTurns
        let posTemp = newPosition % 8
        position = (posTemp != 0) ? posTemp : 8
        category = categories[position - 1]
    }
    
    
    // MARK: - Utils Method
    
    func getRandomNumber(_ max: Int, _ min: Int = 0) -> Int {
        return Int.random(in: min ..< max)
    }
    
    
    
    
    // MARK: - GESTURE RECOGNIZER METHODS
    
    
    @IBAction func handlePan(recognizer: UIPanGestureRecognizer){
        hiddenCategoriesLabelAndImage()
        instructionLabel.fadeOut()
        let minPosition = CGPoint(x: self.sliderControl.center.x, y: self.sliderControl.center.y - 128)
        let maxPosition = CGPoint(x: self.sliderControl.center.x, y: self.sliderControl.center.y + 128)
        var distances: [CGFloat] = []
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x: view.center.x, y: min(max(minPosition.y, view.center.y + translation.y), maxPosition.y))
            distances.append(view.center.y - 85.0)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        
        // Deceleration
        if recognizer.state == UIGestureRecognizer.State.ended {
            // 1
            let velocity = recognizer.velocity(in: self.view)
            let maxDistance = distances.max()
            let distanceFactor = maxDistance! / 10
            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
            let slideMultiplier = magnitude * distanceFactor / 200
            print("slideMultiplier: \(slideMultiplier)")
            
            
            let turns = Int(slideMultiplier)
            numberOfTurns = (turns == 0) ? 1 : (turns < 10) ? turns : (turns < 100) ? turns / 4 : (turns < 300) ? turns / 6 : (turns < 400) ? turns / 8 : (turns < 650) ? turns / 10 : (turns < 1250) ? turns / 15 : turns / 23
            // 2
            let slideFactor = 0.1 * Double(numberOfTurns)
            
            let finalPoint = CGPoint(x:recognizer.view!.center.x ,
                                    y: minPosition.y)
            
            
            
            UIView.animate(withDuration: Double(slideFactor),
                           delay: 0,
                           options: UIView.AnimationOptions.curveEaseOut,
                           animations: {recognizer.view!.center = finalPoint },
                           completion: nil)
            wheelRotation(Int(numberOfTurns))
        }
    }
    
    // MARK: - Rotations methods
    func activityLabelAnimation(_ count: Int, _ array: Array<String>, _ repeatTime: Int, _ labelPosition: Int, _ duration:TimeInterval = 0.12, activityChoosen: Int){
        var mCount = count
        var durationSet: TimeInterval = duration
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            mCount += 1
            let newPosition = labelPosition + 1 < array.count ? labelPosition + 1 : 0
            if (mCount < repeatTime - 4) {
                self.activityLabelAnimation(mCount, array, repeatTime, newPosition,activityChoosen: activityChoosen)
            } else if (mCount < repeatTime){
                durationSet += 0.04
                self.activityLabelAnimation(mCount, array, repeatTime, newPosition, durationSet, activityChoosen: activityChoosen)
            } else if (mCount == repeatTime){
                durationSet += 0.08
                self.activityLabelAnimation(mCount, array, repeatTime, activityChoosen, durationSet, activityChoosen: activityChoosen)
            } else {
                return
            }
        })
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype.fromBottom
        animation.duration = duration
        self.activityLabel.layer.add(animation, forKey: CATransitionType.push.rawValue)
        CATransaction.commit()
        self.activityLabel.text = array[labelPosition]
    }
    
    
    func cursorStartRotation(){
        self.cursor.transform = CGAffineTransform(rotationAngle: -308.55)
    }
    
    func cursorRotation(){
        UIView.animate(
            withDuration: 0.2,
            delay: 0.0,
            options: [.curveEaseOut],
            animations: {
                self.cursor.transform = CGAffineTransform(rotationAngle: -45.0)
        }, completion: { (finished: Bool) in
            UIView.animate(
                withDuration: 0.2,
                delay: 0.0,
                options: [.curveEaseInOut],
                animations: {
                    self.cursor.transform = CGAffineTransform(rotationAngle: -308.0)
            }, completion: { (finished: Bool) in
                UIView.animate(
                    withDuration: 0.2,
                    delay: 0.0,
                    options: [.curveEaseOut],
                    animations: {
                        self.cursor.transform = CGAffineTransform(rotationAngle: -308.55)
                }, completion: nil
                )}
            )}
        )
    }
    
    func cursorRotationWithOutReturn() {
        UIView.animate(
            withDuration: 0.1,
            delay: 0.0,
            options: [.curveEaseInOut],
            animations: {
                self.cursor.transform = CGAffineTransform(rotationAngle: -45.0)
        }, completion: { (finished: Bool) in
            UIView.animate(
                withDuration: 0.05,
                delay: 0.0,
                options: [.curveEaseOut],
                animations: {
                    self.cursor.transform = CGAffineTransform(rotationAngle: -308.55)
            }, completion: nil
        )}
        )
    }
    
    func wheelRotation(_ number: Int){
        var index = number
        if index > 1 {
            actualAngle += .pi/4
            let actualAngleCGFloat = CGFloat(actualAngle)
            UIView.animate(
                withDuration: 0.1,
                delay: 0.0,
                options: [],
                animations: {
                    self.wheelImageView.transform = CGAffineTransform(rotationAngle: actualAngleCGFloat)
            },
                completion: { (finished: Bool) in
                    index -= 1
                    self.cursorRotation()
                    self.wheelRotation(index)
            }
            )
        } else {
            wheelRotationOut()
        }
    }
    
    
    func wheelRotationOut(){
        actualAngle += .pi/4
        let actualAngleCGFloat = CGFloat(actualAngle)
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            options: [.curveEaseOut],
            animations: {
                self.wheelImageView.transform = CGAffineTransform(rotationAngle: actualAngleCGFloat)
                
        },
            completion: {(finished: Bool) in
                self.displayCategoryResult()
                self.cursorRotationWithOutReturn()
                
        }
        )
    }
}
