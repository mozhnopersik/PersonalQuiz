//
//  ViewController.swift
//  PersonalQuiz
//
//  Created by Вероника Карпова on 24.09.2023.
//

import UIKit

class QuestionViewController: UIViewController {
    
    @IBOutlet var questionLabel: UILabel! // Текст самого вопроса
    @IBOutlet var questionProgressView: UIProgressView! // Прогресс бар
    
    @IBOutlet var singleStackView: UIStackView! // Стек для первого вопроса
    @IBOutlet var singleButtons: [UIButton]! // Все кнопки для первого вопроса
    
    @IBOutlet var multipleStackView: UIStackView! // Стек для второго вопроса
    @IBOutlet var multipleLabels: [UILabel]! // Все лейблы для второго вопроса
    @IBOutlet var multipleSwitches: [UISwitch]! // Все свичи для второго вопроса
    
    @IBOutlet var rangedStackView: UIStackView! // Стек для третьего вопроса
    @IBOutlet var rangedLabels: [UILabel]! // Все лейблы для третьего вопроса
    @IBOutlet var rangedSlider: UISlider! { // Слайдер для третьего вопроса
        didSet { // Типа доп. настройки для этого @IBOutlet
            let answerCount = Float(currentAnswers.count - 1) // Создаем константу, в которой лежит общее количество ответов - в данном случае их всего три, потом появляется экран с результатами
            rangedSlider.maximumValue = answerCount // Максимальное значение равняется той константе (значит равняется кол-ву вопросов)
            rangedSlider.value = answerCount / 2 // Ползунок слайдера помещается на его середину за счет того, что количество вопросов делится на 2
        }
    }
    
    private let questions = Question.getQuestions() // это экземпляр фуцнкции getQuestions() из структуры Question
    private var answersChosen: [Answer] = [] // Это массив, куда сохраняются выбранные ответы
    private var currentAnswers: [Answer] { // это свойство с типом структуры Answer, но в виде массива
        questions[questionIndex].answers // оно выберет один из вариантов answers из массива Question из функции getQuestions() по индексу questionIndex
    }
    
    private var questionIndex = 0 // изначально questionIndex равен 0
    
    var mostFrequentAnimal: Animal?
    var mostFrequentDefinition: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        mostFrequentAnimal = findMostFrequentAnimal()
        mostFrequentDefinition = mostFrequentAnimal?.definition
    }
    

    @IBAction func singleAnswerButtonPressed(_ sender: UIButton) { // это метод для кнопки который вызывается при нажатии на любую из кнопок из первого вопроса
        guard let buttonIndex = singleButtons.firstIndex(of: sender) else { return } // Здесь мы получаем индекс нажатой кнопки из массива и сохраняем его в buttonIndex. Если будет нажата кнопка "А", то сохранится индекс кнопки "А", если "Б", то кнопки "Б". А если к этому методу добавлены кнопки не из массива singleButtons, то функция завершит выполнение - return.
        
        let currentAnswer = currentAnswers[buttonIndex] //когда кнопка была нажата, извлекается выбранный ответ из массива и сохраняется в currentAnswer
        answersChosen.append(currentAnswer) // выбранный сохраненный в currentAnswer ответ добавляется в массив answersChosen
        
        nextQuestion() // вызывается метод, который показывает следующий вопрос
    }
    
    @IBAction func multipleAnswerButtonPressed() { // это метод для кнопки "ответить" из второго вопроса
        for (multipleSwitch, answer) in zip(multipleSwitches, currentAnswers) { // это цикл, который перебирает пары свичей и ответов (multipleSwitch, answer) из массивов multipleSwitches и currentAnswers.
            if multipleSwitch.isOn { // и если свич включен
                answersChosen.append(answer) // то добавить answer, связанный с этим свичем, в массив answersChosen
            }
        }
        
        nextQuestion()// вызывается метод, который показывает следующий вопрос
    }
    
    @IBAction func rangedAnswerButtonPressed() { // это метод для кнопки "ответить" из второго вопроса
        let index = lrintf(rangedSlider.value) // значение слайдера округляется в бОльшую или меньшую сторону и сохраняется в константу
        answersChosen.append(currentAnswers[index]) // добавляется округленное значение в массив answersChosen
        nextQuestion() // вызывается метод, который показывает следующий вопрос
    }
    
    
}
// MARK: - Private Methods

private extension QuestionViewController { // расширения для этого класса

    func updateUI() {
        for stackView in [singleStackView, multipleStackView, rangedStackView] { // эта штука выполняет цикл по массиву стеков и скрывает каждый из них
            stackView?.isHidden = true // потом это меняет .toggle
        }
        
        // Get current question - получаем текущий вопрос по индексу - переменной, число в которой меняется при появлении следующего вопроса
        let currentQuestion = questions[questionIndex]
        
        // Set current question for question label - текст вопроса меняется на тайтл текущего вопроса
        questionLabel.text = currentQuestion.title
        
        // Calculate progress - шутка, которая считает количество пройденных вопросов для прогресс бара
        let totalProgress = Float(questionIndex) / Float(questions.count)
        
        // Set progress for questionProgressView - устанавливает заполненность прогресс бара в зависимости от значения totalProgress
        questionProgressView.setProgress(totalProgress, animated: true)
        
        // Set navigation title - устанавливает тайтл navigation controller'а
        title = "Вопрос № \(questionIndex + 1) из \(questions.count)"
        
        // Show stack corresponding to question type - показывает текущий вопрос в зависимости от responseType текущего вопроса
        showCurrentAnswers(for: currentQuestion.responseType)
    }
    
    func showCurrentAnswers(for type: ResponseType) { // функция, которая показывает текст текущего вопроса
        switch type { // и тут есть разные варианты:
        case .single: showSingleStackView(with: currentAnswers)
        case .multiple: showMultipleStackView(with: currentAnswers)
        case .ranged: showRangedStackView(with: currentAnswers)
        }
    }
    
    func showSingleStackView(with answers: [Answer]) { // метод, который содержит "отсылку" к структуре Question и его свойству answers с типом [Answer].
        singleStackView.isHidden.toggle() // вот тут включает (toggle переключает true на false и обратно) все элементы для первого вопорса - их становится видно.
        
        for (button, answer) in zip(singleButtons, answers) { // это цикл, который перебирает пары кнопок и ответов (button, answer) из массивов singleButtons и answers. Button будет содержать кнопку из массива singleButtons, а answer будет содержать элемент типа Answer из массива answers.
            button.setTitle(answer.title, for: .normal) // и внутри этого цисла для каждой кнопки из массива устанавливается текст из свойства .title из массива answer.
        }
    }
    
    func showMultipleStackView(with answers: [Answer]) { // метод, который включает скрытый стек multipleStackView, где лежат все элементы для второго вопроса
        multipleStackView.isHidden.toggle() // вот тут включает (toggle переключает true на false и обратно)
        
        for (label, answer) in zip(multipleLabels, answers) { // см. выше, примерно такой же принцип
            label.text = answer.title
        }
    }
    
    func showRangedStackView(with answers: [Answer]) { // метод, который включает скрытый стек rangedStackView, где лежат все элементы для третьего вопроса
        rangedStackView.isHidden.toggle() // вот тут включает (toggle переключает true на false и обратно)
        
        rangedLabels.first?.text = answers.first?.title // в массиве лейблов лейблы идут по порядку, поэтому здесь для первого лейбла этого массива устанавливается первый заголовок (title) из массива answers
        rangedLabels.last?.text = answers.last?.title // а здесь для последнего лейбла последний тайтл
    }
    
    func nextQuestion() { // метод, включающий следующий вопрос
        print("Был выбран вот этот ответ: \(answersChosen)")
        questionIndex += 1 // меняет индекс вопроса, увеличивая его на 1 (изначально он был 0), это может быть нужно для прогресс бара.
        
        if questionIndex < questions.count { // если индекс вопроса меньше, чем количество вопросов, то вызывается метод updateUI()
            updateUI()
            return
        }
        
        _ = countAnimals()

        let mostFrequentAnimalData = MostFrequentAnimalData(mostFrequentAnimal: findMostFrequentAnimal())

        if let mostFrequent = mostFrequentAnimalData.mostFrequentAnimal {
            print("Самое часто упоминаемое животное: \(mostFrequent.rawValue)")
        }
        
        performSegue(withIdentifier: "showResult", sender: nil) // в противном случае вызывается переход на экран с результатами
    }
    
    func gatherAnswers() -> [Answer] {
        return answersChosen
    }
    
    func countAnimals() -> [Animal: Int] {
        var animalCounts: [Animal: Int] = [:]

        for answer in answersChosen {
            let animal = answer.animal
            animalCounts[animal, default: 0] += 1
            
        }
        
        return animalCounts
    }
    
    func findMostFrequentAnimal() -> Animal? {
        let animalCounts = countAnimals()
        var mostFrequentAnimal: Animal?
        var maxCount = 0

        for (animal, count) in animalCounts {
            if count > maxCount {
                mostFrequentAnimal = animal
                maxCount = count
            }
        }

        return mostFrequentAnimal
    }


}
