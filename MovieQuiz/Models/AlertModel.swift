//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Татьяна Черныш on 22.03.2026.
//

import Foundation


struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    var completion: () -> Void
} 
