import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate{
    
    
    
    
    // MARK: - IBOutlets
    
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    
    // MARK: - Properties
    private var statistic = Statistic()
    private let statisticManager = StatisticServise()
    
    private let questionsAmount: Int = 10
        private var questionFactory: QuestionFactoryProtocol?
        private var currentQuestion: QuizQuestion?
        private var alertPresenter = AlertPresenter()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let questionFactory = QuestionFactory()
        questionFactory.setup(delegate: self)
        self.questionFactory = questionFactory
        imageView.layer.cornerRadius = 20
        
        self.questionFactory?.requestNextQuestion()
        
        statistic.numberOfQuizzes += 1
        
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer: Bool = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer: Bool = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // MARK: - Private Methods
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(statistic.currentQuestionIndex + 1)/\(questionsAmount)")
        imageView.layer.cornerRadius = 20
        
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect { statistic.correctAnswers += 1 }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if statistic.currentQuestionIndex == questionsAmount - 1 {
            statisticManager.updateHighScoreIfNeeded(statistic: &statistic)
            
            let text = statistic.correctAnswers == questionsAmount ?
            "Поздравляем, вы ответили на 10 из 10!" :
            "Вы ответили на \(statistic.correctAnswers) из 10, попробуйте ещё раз!"
            
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            
            imageView.layer.borderWidth = 0
            
            show(quiz: viewModel)
        } else {
            statistic.currentQuestionIndex += 1
            imageView.layer.borderWidth = 0
            
            questionFactory?.requestNextQuestion()
        }
    }
    
    func show(quiz result: QuizResultsViewModel) {
        func message() -> String {
            let scorePercent = Double(statistic.correctAnswers) / Double(questionsAmount) * 100
            _ = String(format: "%.2f", scorePercent)
            let date = UserDefaults.standard.object(forKey: "bestGame.date") as? Date ?? Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yy, HH:mm"
            return "Вы ответили на \(statistic.correctAnswers) из 10, попробуйте ещё раз!\nКоличество сыгранных квизов: \(statistic.numberOfQuizzes) \nРекорд: \(statistic.highScore)/10  (\(formatter.string(from: date)))\nСредняя точность: \(scorePercent)%"
                
        }
       
        
        
        
        let model = AlertModel(
                title: result.title,
                message: message(),
                buttonText: result.buttonText
            ) { [weak self] in
                guard let self = self else { return }

               
                self.statisticManager.saveStatistic(self.statistic)

               
                self.statistic.currentQuestionIndex = 0
                self.statistic.correctAnswers = 0
                self.statistic.numberOfQuizzes += 1

                UserDefaults.standard.set(Date(), forKey: "bestGame.date")
                self.questionFactory?.requestNextQuestion()
            }

            alertPresenter.show(in: self, model: model)
        }
    
   
    
   
}
