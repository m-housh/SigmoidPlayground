//
//  ContentView.swift
//  SigmoidPlayground
//
//  Created by Michael Housh on 4/17/20.
//  Copyright © 2020 Michael Housh. All rights reserved.
//

import SwiftUI
import Foundation

struct ContentView: View {

    let frameHeight: CGFloat
    let frameWidth: CGFloat

    let extraFlashlightOffset: CGFloat = 25
    let flashLightYOffset: CGFloat = -15

    @State private var minString: String = "50"
    @State private var maxString: String = "300"

    @State private var budgetOneString: String = "80"
    @State private var budgetTwoString: String = "125"

    init(width: CGFloat = 1000, height: CGFloat = 500) {
        self.frameWidth = width
        self.frameHeight = height
    }

    var body: some View {
//        Rectangle()
//            .fill(LinearGradient(gradient: .init(colors: [.green, .white]), startPoint: .topTrailing, endPoint: .bottomLeading))
//            .overlay(SigmoidView())
        NavigationView {
            HStack(spacing: 40) {
                sigmoidView
                formView
                    .frame(maxWidth: 300)
                    .offset(x: 0, y: 150)
            }
            .navigationBarTitle("Sigmoid Playground", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - Displayed Content
private extension ContentView {

    func flashlightOffset(for budget: Int) -> CGFloat {
        let min = Int(minString) ?? 50
        let max = Int(maxString) ?? 300
        let range = max - min
        let step = frameWidth / CGFloat(range)
        let distance = budget - min
        return step * CGFloat(distance) + extraFlashlightOffset
    }

    var v1View: some View {
        VShape(minScale: Int(minString),
               maxScale: Int(maxString),
               customerBudget: Int(budgetOneString),
               contractorBudget: Int(budgetTwoString))
            .fill(LinearGradient(gradient: .init(colors: [.white, .yellow]), startPoint: .bottom, endPoint: .top))
            .opacity(0.7)
            .frame(width: frameWidth, height: frameHeight, alignment: .center)

    }

    var flashLightView: some View {
        Image(systemName: "flashlight.on.fill")
    }

    var formView: some View {
        Form {
            Section(header: Text("Minimum Budget Scale")) {
                        TextField("", text: $minString)
            }

            Section(header: Text("Maximum Budget Scale")) {
                TextField("", text: $maxString)
            }
            Section(header: Text("Customer Budget")) {
                TextField("", text: $budgetOneString)
            }
            Section(header: Text("Contractor Budget")) {
                TextField("", text: $budgetTwoString)
            }
        }
    }

    var sigmoidView: some View {
        VStack {
            HStack {
               LabelsY()
                   .frame(width: 50, height: frameHeight, alignment: .trailing)

               SigmoidView(width: frameWidth, height: frameHeight)
                   .overlay(v1View)
           }

           ZStack {
               LabelsX(min: Int(minString) ?? 50, max: Int(maxString) ?? 300)
                .frame(width: frameWidth, height: 50, alignment: .leading)
                .offset(x: -30, y: 0)

               flashLightView
                   .frame(width: frameWidth, alignment: .topLeading)
                   .offset(x: flashlightOffset(for: Int(budgetOneString) ?? 80), y: flashLightYOffset)

               flashLightView
                   .frame(width: frameWidth, alignment: .topLeading)
                   .offset(x: flashlightOffset(for: Int(budgetTwoString) ?? 120), y: flashLightYOffset)
           }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
