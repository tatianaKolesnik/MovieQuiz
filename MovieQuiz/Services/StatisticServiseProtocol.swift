//
//  StatisticServiseProtocol.swift
//  MovieQuiz
//
//  Created by Татьяна Черныш on 28.03.2026.
//

import Foundation
protocol StatisticServiceProtocol {
    func loadStatistic() -> Statistic
    func saveStatistic(_ statistic: Statistic)
    func updateHighScoreIfNeeded(statistic: inout Statistic)
}
