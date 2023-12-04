//
//  ViewController.swift
//  bingoGame
//
//  Created by Machir on 2023/11/20.
//

import UIKit

class ViewController: UIViewController {
    
    var randomNumberData: [Int]!
    var buttons: [UIButton]!
    var randomNumberButton: UIButton!
    var basicNumber = 3
    var bingoNumber = 2

    override func viewDidLoad() {
        super.viewDidLoad()
        getRandomNumber()
        setupButton()
        setupButtonView()
        setupRandomNumberButton()
    }
    
}

extension ViewController {
    func getRandomNumber() {
        var numberRanger = [Int](1...25)
        numberRanger.shuffle()
        var data: [Int] = []
        
        for index in 0..<(basicNumber*basicNumber) {
            let number = numberRanger[index]
            data.append(number)
        }
        randomNumberData = data
    }
    
    func setupRandomNumberButton() {
        let button = UIButton()
        button.setTitle("填入隨機數字", for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 44)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 22
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapRandomNumber), for: .touchUpInside)
        view.addSubview(button)
        
        randomNumberButton = button
        NSLayoutConstraint.activate([
            randomNumberButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            randomNumberButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            randomNumberButton.widthAnchor.constraint(equalToConstant: 200),
            randomNumberButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc func didTapRandomNumber() {
        getRandomNumber()
        resetNumberButtons()
    }
    
    func resetNumberButtons() {
        guard !buttons.isEmpty else { return }
        for (index, button) in buttons.enumerated() {
            button.setTitle("\(randomNumberData[index])", for: .normal)
            button.isSelected = false
            button.backgroundColor = nil
        }
    }
    
    func setupButton() {
        guard !randomNumberData.isEmpty else { return }
        var buttons: [UIButton] = []
        for index in 0..<randomNumberData.count {
            let button = UIButton()
            button.setTitle("\(self.randomNumberData[index])", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.layer.cornerRadius = CGFloat((300/basicNumber/2))
            button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
            buttons.append(button)
        }
        self.buttons = buttons
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.backgroundColor = sender.isSelected ? .systemGray : nil
        var bingoLine = 0
        for i in 0..<basicNumber {
            let startIndex = i * basicNumber
            let endIndex = startIndex + (basicNumber-1)
            
            var horizontalButtons: [UIButton] = []
            for index in startIndex...endIndex {
                let button = self.buttons[index]
                if button.isSelected {
                    horizontalButtons.append(button)
                }
            }
            if horizontalButtons.count == basicNumber {
                bingoLine += 1
            }
            
            var verticalButtons: [UIButton] = []
            for verticalIndex in stride(from: i, through: i + (basicNumber*basicNumber-basicNumber), by: basicNumber) {
                let button = self.buttons[verticalIndex]
                if button.isSelected {
                    verticalButtons.append(button)
                }
            }
            if verticalButtons.count == basicNumber {
                bingoLine += 1
            }
            
        }
        
        var slashButtons1: [UIButton] = []
        for i in stride(from: 0, through: (basicNumber*basicNumber), by: (basicNumber+1)) {
            let button = buttons[i]
            if button.isSelected {
                slashButtons1.append(button)
            }
        }
        if slashButtons1.count == basicNumber {
            bingoLine += 1
        }
        
        var slashButtons2: [UIButton] = []
        for i in stride(from: (basicNumber-1), through: (basicNumber*basicNumber-basicNumber), by: (basicNumber-1)) {
            let button = buttons[i]
            if button.isSelected {
                slashButtons2.append(button)
            }
        }
        if slashButtons2.count == basicNumber {
            bingoLine += 1
        }
        
        if bingoLine >= bingoNumber {
            print("遊戲結束")
            let alert = UIAlertController(title: "遊戲結束", message: "恭喜獲勝", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "重新開始", style: .default, handler: { _ in
                self.didTapRandomNumber()
            }))
            present(alert, animated: true)
        }
    }
    
    func setupButtonView() {
        guard !buttons.isEmpty else { return }
        var horizontalStackViews: [UIView] = []
        
        for index in 0..<basicNumber {
            let horizontalStackView = UIStackView()
            horizontalStackView.axis = .horizontal
            horizontalStackView.alignment = .fill
            horizontalStackView.distribution = .fillProportionally
            horizontalStackView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            horizontalStackViews.append(horizontalStackView)
            
            let startIndex = index * basicNumber
            let endIndex = startIndex + (basicNumber-1)
            for index in startIndex...endIndex {
                let button = self.buttons[index]
                horizontalStackView.addArrangedSubview(button)
            }
            
        }
        
        
        let verticalStackView = UIStackView(arrangedSubviews: horizontalStackViews)
        verticalStackView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .fill
        verticalStackView.center = view.center
        verticalStackView.backgroundColor = .secondarySystemBackground
        verticalStackView.distribution = .fillProportionally
        view.addSubview(verticalStackView)
        
    }
}
