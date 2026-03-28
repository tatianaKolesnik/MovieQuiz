//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Татьяна Черныш on 26.03.2026.
//

import Foundation

final class StatisticServiсe:StatisticServiceProtocol {
    private let defaults = UserDefaults.standard
    private let highScoreKey = "highScore"
    private let numberOfQuizzesKey = "numberOfQuizzes"
    private let lastHighScoreDateKey = "lastHighScoreDate"

    func loadStatistic() -> Statistic {
        let highScore = defaults.integer(forKey: highScoreKey)
        let numberOfQuizzes = defaults.integer(forKey: numberOfQuizzesKey)

        if let date = defaults.object(forKey: lastHighScoreDateKey) as? Date {
            return Statistic(
                numberOfQuizzes: numberOfQuizzes,
                highScore: highScore,
                lastHighScoreDate: date
            )
        } else {
            return Statistic(numberOfQuizzes: numberOfQuizzes, highScore: highScore)
        }
    }

    func saveStatistic(_ statistic: Statistic) {
        defaults.set(statistic.highScore, forKey: highScoreKey)
        defaults.set(statistic.numberOfQuizzes, forKey: numberOfQuizzesKey)
        defaults.set(statistic.lastHighScoreDate, forKey: lastHighScoreDateKey)
    }

    func updateHighScoreIfNeeded(statistic: inout Statistic) {
        if statistic.correctAnswers >= statistic.highScore {
           statistic.highScore = statistic.correctAnswers
           statistic.lastHighScoreDate = Date()
        }
    }
}
