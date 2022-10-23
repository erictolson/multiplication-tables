//
//  ContentView.swift
//  MultiplicationTables
//
//  Created by Eric Tolson on 10/20/22.
//

import SwiftUI

struct Question {
    var text: String
    var answer: Int
    
    mutating func setText(for num1: Int, for num2: Int) {
        text = "What is \(num1) x \(num2)?"
    }
    
    mutating func setAnswer(for num1: Int, for num2: Int) {
        answer = num1 * num2
    }
}

struct ContentView: View {
    @State private var tableChoice = 2
    @State private var questionAmount = 5
    @State private var questionAmounts = [5, 10, 20]
    @State private var correctAnswer = 0
    @State private var userAnswer = ""
    @State private var question = ""
    @State private var questions = []
    @State private var userScore = 0
    @State private var userTurn = 0
    @State private var turnDisplay = 0
    @State private var gameOver = false
    @State private var showQuestion = false
    @State private var showScore = false
    @State private var lastQuestion = false
    @State private var scoreTitle = ""
    @State private var endMessage = ""
    @State private var showTables = false
    @State private var buttonNumber = -1
    
    var body: some View {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                    VStack {
                        if !showQuestion && !showTables {
                            Text("Multiplication Tables")
                                .font(.largeTitle.weight(.bold))
                                .foregroundColor(.white)
                                .padding()
                            
                            Text("Pick a Times Table!")
                                .font(.title)
                                .foregroundColor(.white)
                                
                                
                            Picker("\(tableChoice) Times Table", selection: $tableChoice) {
                                ForEach(2..<13, id: \.self) {
                                    Text("\($0)")
                                        .foregroundColor(.white)
                                }
                            }
                            .pickerStyle(.segmented)
                            .padding()
                            
                            Text("How Many Quiz Questions?")
                                .font(.title)
                                .foregroundColor(.white)
                            
                            HStack {
                                ForEach(0..<3) { number in
                                    Button {
                                        questionAmount = questionAmounts[number]
                                        
                                    } label : {
                                        Text("\(questionAmounts[number])")
                                            .frame(width: 50, height: 50)
                                            .background(.mint)
                                            .foregroundColor(.white)
                                            .clipShape(Capsule())
                                            .animation(.default, value: buttonNumber)
                                            .opacity(questionAmount == questionAmounts[number] || questionAmount == 0 ? 1.0 : 0.25)
                                    }
                                }
                            }
                            .padding()
                            
                            Button("Quiz Me!") {
                                makeQuestions(tableChoice: tableChoice)
                                pickQuestion()
                                    }
                                .padding(50)
                                .background(.pink)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                            
                            Text("Or")
                                .font(.title)
                                .foregroundColor(.white)
                            
                            Button("Study!") {
                                showTables.toggle()
                                    }
                                .padding(50)
                                .background(.pink)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                            }
                        
                        else if showQuestion && !showTables {
                            Text(" \(tableChoice) Times Table Quiz")
                                .font(.largeTitle.weight(.bold))
                                .foregroundColor(.white)
                                .padding()
                            
                            Text("Question \(turnDisplay)")
                                .font(.title)
                                .foregroundColor(.white)
                            
                            Text(question)
                                .font(.title2)
                                .foregroundColor(.white)

                            TextField("Answer: ", text: $userAnswer)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.leading, 125)
                                .padding(.trailing, 125)
                                .font(.title2)
                                .padding()
                            
                            Text("Score: \(userScore)")
                                .font(.title)
                                .foregroundColor(.white)
                        
                            Button("Make a New \n Quiz") {
                                reset()
                                }
                                .padding(50)
                                .background(.pink)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                        
                        else {
                            Text(" \(tableChoice) Times Table")
                                .font(.largeTitle.weight(.bold))
                                .foregroundColor(.white)
                                .padding()
                            
                            ForEach(1...12, id: \.self) {
                                Text("\(tableChoice) x \($0) = \(tableChoice * $0)")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                }
                    
                            Button("End Study") {
                                showTables = false
                                }
                                .padding(50)
                                .background(.pink)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .padding()
                        }
                    }
                    .alert(scoreTitle, isPresented: $showScore){
                        Button("Continue", action: pickQuestion)
                    }
                    .alert(scoreTitle, isPresented: $lastQuestion){
                        Button("Continue", role: .cancel) { }
                    }
                    .alert(endMessage, isPresented: $gameOver){
                        Button("Reset", action: reset)
                    }
                    .onSubmit {
                        playerAnswers()
            }
        }
    }
    
    func makeQuestions(tableChoice: Int) {
        // generate potential questions for chosen times table
        questions = []
        userScore = 0
        userTurn = 1
        question = ""
        userAnswer = ""
        showQuestion = true
        
        for i in 1...12 {
            var question: Question
            question = Question(text: "temp",answer: 1)
            
            question.setText(for: tableChoice, for: i)
            question.setAnswer(for: tableChoice, for: i)
            
            questions.append(question)
        }
    }
    
    func pickQuestion() {
        var choice: Int
        choice = Int.random(in: 0...11)
        var selection: Question
        selection = questions[choice] as! Question
        question = selection.text
        correctAnswer = selection.answer
        turnDisplay += 1
    }
    
    func playerAnswers() {
        
        if Int(userAnswer) == correctAnswer {
            userScore += 1
            scoreTitle = "Correct!"
        } else {
            scoreTitle = "So close! The correct answer is \(correctAnswer)."

        }
        
        if userTurn <= questionAmount - 1 {
            showScore = true
        }
        
        else if userTurn == questionAmount {
            if userScore > questionAmount / 2 {
                endMessage = "\(scoreTitle) \n \n You got \(userScore)/\(questionAmount) right! Great job! 😃"
            } else {
                endMessage = "\(scoreTitle) \n \n You got \(userScore)/\(questionAmount) right! Keep practicing! 😃"
            }
            gameOver = true
        }
        
        userTurn += 1
        userAnswer = ""
    }
    
    
    func reset() {
        question = ""
        userScore = 0
        userTurn = 0
        questions = []
        userAnswer = ""
        showQuestion = false
        questionAmount = 5
        tableChoice = 2
        turnDisplay = 0
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
