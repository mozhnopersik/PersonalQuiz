//
//  ResultViewController.swift
//  PersonalQuiz
//
//  Created by Вероника Карпова on 24.09.2023.
//

import UIKit

class ResultViewController: UIViewController {
    
    // 2. Передать массив с ответами на экран с результатами
    // 3. Определить наиболее часто встречающийся тип животного
    // 4. Отобразить результаты в соответствии с этим животным

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var definitionLabel: UILabel!
    
    
    
}
