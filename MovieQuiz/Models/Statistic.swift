//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Татьяна Черныш on 24.03.2026.
//

import Foundation
import UIKit



struct Statistic {
    
    var currentQuestionIndex: Int = 0
    var correctAnswers: Int = 0
    var numberOfQuizzes: Int = 0
    var highScore: Int = 0
    var lastHighScoreDate: Date = Date()

   
    var averageAccuracy: Double {
        guard currentQuestionIndex > 0 else { return 0 }
        return Double(correctAnswers) / Double(currentQuestionIndex) * 100
    }

    
    var formattedAverageAccuracy: String {
        let accuracy = averageAccuracy
        return String(format: "%.2f%%", accuracy)
    }
}
