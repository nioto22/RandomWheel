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
    @IBOutlet weak var startButtoon: UIButton!
   
    @IBOutlet weak var numberOfTurnsLabel: UILabel!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var cursor: UIImageView!
    
    
    @IBOutlet weak var sliderControl: UIImageView!

    
    
    
    // FOR DATA
    var actualAngle: Double! = 0.0
    var randomNumber: Int!
    var position: Int! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cursorStartRotation()
        // Do any additional setup after loading the view.
    }

    @IBAction func startButtonClicked(_ sender: Any) {
        randomNumber = 16 //getRandomNumber()
        displayRandomTurnsNumber(randomNumber)
        wheelOverTwoRotations(randomNumber)
    }
    
    
    @IBAction func testCursorButton(_ sender: Any) {
        cursorRotation()
    }
    
    // MARK: - UI Methods
    
    func displayRandomTurnsNumber(_ number: Int){
        numberOfTurnsLabel.text = String(number)
    }
    
    func displayResultText(){
//        let number = position + randomNumber
//        let modulo = number % 8
//        position = (modulo == 0 ) ? 8 : (modulo/100 * 8) + 2
//        resultLabel.text = String(position)
    }
    
    // MARK: - Utils Method
    
    func getRandomNumber() -> Int {
        return Int.random(in: 16 ... 64)  // between 2 and 8 turns
    }
    
    func getPositionOfTheWheel() -> Int!{
       return 1
    }
    
    
    // MARK: - GESTURE RECOGNIZER METHODS
    
    
    @IBAction func handlePan(recognizer: UIPanGestureRecognizer){
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
            let numberOfTurns = (turns < 10) ? turns : (turns < 100) ? turns / 4 : (turns < 300) ? turns / 6 : (turns < 400) ? turns / 8 : (turns < 650) ? turns / 10 : (turns < 1250) ? turns / 15 : turns / 23
            // 2
            let slideFactor = 0.1 * Double(numberOfTurns)     //Increase for more of a slide
            // 3
            //var finalPoint = CGPoint(x:recognizer.view!.center.x ,
            //                           y:recognizer.view!.center.y + (velocity.y * slideFactor))
            // put out : + (velocity.x * slideFactor)
            // 4
            //finalPoint.x = min(max(finalPoint.x, 0), self.view.bounds.size.width)
            //finalPoint.y = min(max(finalPoint.y, 0), self.view.bounds.size.height)
            
            let finalPoint = CGPoint(x:recognizer.view!.center.x ,
                                    y: minPosition.y)
            
            
            // 5
            UIView.animate(withDuration: Double(slideFactor),  //*2
                           delay: 0,
                           // 6
                options: UIView.AnimationOptions.curveEaseOut,
                animations: {recognizer.view!.center = finalPoint },
                completion: nil)
            

            displayRandomTurnsNumber(numberOfTurns)
            wheelOverTwoRotations(Int(numberOfTurns))
        }
    }
    
    // MARK: - Rotations methods
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
                    self.cursor.transform = CGAffineTransform(rotationAngle: 45.0)
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
                    self.cursor.transform = CGAffineTransform(rotationAngle: -308.45)
            }, completion: nil
        )}
        )
    }
    
    
    func wheelTwoRotations() {
        actualAngle += .pi/4
        let actualAngleCGFloat = CGFloat(actualAngle)
        UIView.animate(
            withDuration: 1,
            delay: 0.0,
            options: [.curveEaseIn],
            animations: {
                self.wheelImageView.transform = CGAffineTransform(rotationAngle: actualAngleCGFloat)
        },
            completion: { (finished: Bool) in
                self.cursorRotation()
                self.wheelRotationOut()
        }
        )
    }
    
    func wheelOverTwoRotations(_ number: Int){
        actualAngle += .pi/4
        let actualAngleCGFloat = CGFloat(actualAngle)
        let index = number
        UIView.animate(
            withDuration: 0.2,
            delay: 0.0,
            options: [],
            animations: {
                self.wheelImageView.transform = CGAffineTransform(rotationAngle: actualAngleCGFloat)
        },
            completion: { (finished: Bool) in
                self.cursorRotation()
                self.wheelRotation(index)
        }
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
    
    func wheelRotationIn(){
        actualAngle += .pi/4
        let actualAngleCGFloat = CGFloat(actualAngle)
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            options: [.curveEaseIn],
            animations: {
                self.wheelImageView.transform = CGAffineTransform(rotationAngle: actualAngleCGFloat)
            },
            completion: nil
        )
        
    }
    
    func wheelRotationInAndOut(){
        actualAngle += .pi/4
        let actualAngleCGFloat = CGFloat(actualAngle)
        UIView.animate(
            withDuration: 1.0,
            delay: 0.0,
            options: [.curveEaseInOut],
            animations: {
                self.wheelImageView.transform = CGAffineTransform(rotationAngle: actualAngleCGFloat)
        },
            completion: {(finished: Bool) in
                self.cursorRotation()
                self.displayResultText()
        }
        )
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
                self.displayResultText()
                self.cursorRotationWithOutReturn()
                
        }
        )
    }
}

