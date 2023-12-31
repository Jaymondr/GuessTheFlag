//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Jaymond Richardson on 6/14/23.
//

import SwiftUI

struct FlagImage: View {
    let country: String
    
    var body: some View {
        Image(country)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var showingFinalScore = false
    
    @State private var rotationAmount = 0.0
    @State private var selectedFlag: Int?
    
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var questionCount = 0
    private var questionLimit = 8
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
   
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 300, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.headline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                            withAnimation {
                                rotationAmount += 360
                            }
                        } label: {
                            FlagImage(country: countries[number])
                        }
                        .rotation3DEffect(.degrees(number == selectedFlag ? rotationAmount : -rotationAmount), axis: (x: 0, y: 1, z: 0))
                        .opacity(selectedFlag != nil && number != selectedFlag ? 0.5 : 1.0)
                        }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is: \(score)")
        }
        
        .alert("Final Score", isPresented: $showingFinalScore) {
            Button("Start Over", action: reset)
        } message: {
            Text("The final score is \(score)/\(questionLimit)")
        }
        
    }
    
    
    func flagTapped(_ number: Int) {
        questionCount += 1
        selectedFlag = number
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong! That's \(countries[number])s flag"
        }
        
        if questionCount >= questionLimit {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) {
                showingFinalScore = true
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) {
                showingScore = true
            }
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        selectedFlag = nil
    }
    
    func reset() {
        score = 0
        questionCount = 0
        selectedFlag = nil
        countries.shuffle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
