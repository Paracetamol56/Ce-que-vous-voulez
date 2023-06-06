//
//  MovieCard.swift
//  CeQueVousVoulez
//
//  Created by digital on 22/05/2023.
//

import Foundation
import SwiftUI

struct MovieCard: View {
    private let movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    var body: some View {
        NavigationLink {
            DetailView(movieId: movie.id)
        } label: {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: "https://www.themoviedb.org/t/p/w1280" + movie.posterPath)) { image in
                    image
                        .resizable()
                        .frame(width: 170, height: 255)
                        .cornerRadius(8)
                } placeholder: {
                    ProgressView()
                        .aspectRatio(0.66, contentMode: .fit)
                        .frame(width: 170, height: 255)
                        .cornerRadius(8)
                }

                if let voteText = String(movie.vote) {
                    Text(voteText)
                        .foregroundColor(Color.black)
                        .padding(4.0)
                        .background(Color.white)
                        .cornerRadius(4)
                        .padding(5)
                }
            }
        }
    }
}
