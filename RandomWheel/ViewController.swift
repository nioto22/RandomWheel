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
    
    
    
    // FOR DATA
    var actualAngle: Double! = 0.0
    var randomNumber: Int!
    var position: Int! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func startButtonClicked(_ sender: Any) {
        randomNumber = getRandomNumber()
        displayRandomTurnsNumber(randomNumber)
        if (randomNumber == 1) {
            wheelRotationInAndOut()
        } else if (randomNumber == 2) {
            wheelTwoRotations()
        } else {
           wheelOverTwoRotations(randomNumber)
        }
    }
    
    
    @IBAction func testCursorButton(_ sender: Any) {
        cursorRotation()
    }
    
    // MARK: - UI Methods
    
    func displayRandomTurnsNumber(_ number: Int){
        numberOfTurnsLabel.text = String(number)
    }
    
    func displayResultText(){
        let number = position + randomNumber
        let modulo = number % 8
        position = (modulo == 0 ) ? 8 : (modulo/100 * 8) + 2
        resultLabel.text = String(position)
    }
    
    // MARK: - Utils Method
    
    func getRandomNumber() -> Int {
        return Int.random(in: 16 ... 64)  // between 2 and 8 turns
    }
    
    func getPositionOfTheWheel() -> Int!{
       return 1
    }
    
    
    // MARK: - Rotations methods
    
    func cursorRotation(){
        UIView.animate(
            withDuration: 0.2,
            delay: 0.0,
            options: [.curveEaseOut],
            animations: {
                self.cursor.transform = CGAffineTransform(rotationAngle: 45.0)
        }, completion: { (finished: Bool) in
            UIView.animate(
                withDuration: 0.2,
                delay: 0.0,
                options: [.curveEaseInOut],
                animations: {
                    self.cursor.transform = CGAffineTransform(rotationAngle: -45.0)
            }, completion: { (finished: Bool) in
                UIView.animate(
                    withDuration: 0.2,
                    delay: 0.0,
                    options: [.curveEaseOut],
                    animations: {
                        self.cursor.transform = CGAffineTransform(rotationAngle: 0.0)
                }, completion: nil
                )}
            )}
        )
    }
    
    
    func wheelTwoRotations() {
        actualAngle -= .pi/4
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
        actualAngle -= .pi/4
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
        if index > 2 {
            actualAngle -= .pi/4
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
        actualAngle -= .pi/4
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
        actualAngle -= .pi/4
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
        actualAngle -= .pi/4
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
        }
        )
    }
}

