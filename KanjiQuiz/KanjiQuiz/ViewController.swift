//
//  ViewController.swift
//  KanjiQuizz
//
//  Created by Syah Riza on 3/16/15.
//  Copyright (c) 2015 Kii. All rights reserved.
//

import UIKit
import AppLogic


class ViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        func prepareQuiz(type : QuizType){
            let destination = segue.destinationViewController as QuizViewController
            
            let quiz = Quiz(type: type, level: .N5)
            quiz.setup()
            destination.currentQuiz = quiz
            destination.problems = quiz.problems
            
        }
        println(segue.identifier)
        if let segueID = segue.identifier {
            switch segueID {
            case "Meaning":
                prepareQuiz(QuizType.Meaning)
            case "Spelling":
                prepareQuiz(QuizType.Spelling)
            default:
                break
            }
        }
    }
    
}

