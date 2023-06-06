//
//  StarComponent.swift
//  CeQueVousVoulez
//
//  Created by digital on 23/05/2023.
//

import Foundation
import SwiftUI

struct StarComponent: View {
    private let vote: Float
    
    init(vote: Float) {
        self.vote = vote
    }
    
    var body: some View {
        HStack {
            ForEach(1...5, id: \.self) { index in
                if index <= Int(self.vote / 2) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                } else if index == Int(self.vote / 2) + 1 && self.vote.truncatingRemainder(dividingBy: 1) >= 0.5 {
                    Image(systemName: "star.leadinghalf.filled")
                        .foregroundColor(.yellow)
                        .font(.caption)
                } else {
                    Image(systemName: "star")
                        .foregroundColor(.yellow)
                        .font(.caption)
                }
            }

            Text(String(self.vote))
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.leading)
                .padding(4.0)
                .background(Color.white)
                .cornerRadius(4)
        }
    }
}
