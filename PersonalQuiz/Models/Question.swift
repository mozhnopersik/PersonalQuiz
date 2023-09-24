//
//  Question.swift
//  PersonalQuiz
//
//  Created by Вероника Карпова on 24.09.2023.
//

struct Question {
    let title: String
    let responseType: ResponseType
    let answers: [Answer]
    
    static func getQuestions() -> [Question] { // Это метод, который создает и возвращает массив с объектами структуры Question - то есть все свойства выше становятся проинициализированы, но не один, а несколько раз, поэтому это массив. Этот метод можно вызвать для получения этого массива и отображения вопрсов и вариантов ответов.
        [
            Question(
                title: "Какую пищу вы предпочитаете?", // Это строка.
                responseType: .single, // Это берется из перечисления ниже.
                answers: [ // Это свойство было выше записано с типом [Answer] - а это, в свою очередь, отдельная структура ниже.
                    Answer(title: "Стейк", animal: .dog),
                    Answer(title: "Рыба", animal: .cat),
                    Answer(title: "Морковь", animal: .rabbit),
                    Answer(title: "Кукуруза", animal: .turtle)
                ]
            ),
            Question(
                title: "Что вам нравится больше?",
                responseType: .multiple,
                answers: [
                    Answer(title: "Плавать", animal: .dog),
                    Answer(title: "Спать", animal: .cat),
                    Answer(title: "Обниматься", animal: .rabbit),
                    Answer(title: "Есть", animal: .rabbit)
                ]
            ),
            Question(
                title: "Любите ли вы поездки на машине?",
                responseType: .ranged,
                answers: [
                    Answer(title: "Ненавижу", animal: .cat),
                    Answer(title: "Нервничаю", animal: .rabbit),
                    Answer(title: "Не замечаю", animal: .turtle),
                    Answer(title: "Обожаю", animal: .dog)
                ]
            )
        ]
    }
}

enum ResponseType { // Это перечисление, в котором находятся варианты типов вопросов. Если вопросов станет больше - сюда можно добавить еще типы, так как это больше тег, чем реальный тип вопросов.
    case single
    case multiple
    case ranged
}

struct Answer { // Это структура, которая содержит текст заголовка и "отсылку" к перечислению Animal
    let title: String
    let animal: Animal
}

enum Animal: Character {
    case dog = "🐶"
    case cat = "🐱"
    case rabbit = "🐰"
    case turtle = "🐢"
    
    var definition: String {
        switch self {
        case .dog:
            return "Вам нравится быть с друзьями. Вы окружаете себя людьми, которые вам нравятся и всегда готовы помочь."
        case .cat:
            return "Вы себе на уме. Любите гулять сами по себе. Вы цените одиночество."
        case .rabbit:
            return "Вам нравится все мягкое. Вы здоровы и полны энергии."
        case .turtle:
            return "Ваша сила - в мудрости. Медленный и вдумчивый выигрывает на больших дистанциях."
        }
    }
}

struct MostFrequentAnimalData {
    let mostFrequentAnimal: Animal?
    
    func printed() {
        print("Проверка, вот то животное: \(mostFrequentAnimal ?? .dog)")
    }
}

