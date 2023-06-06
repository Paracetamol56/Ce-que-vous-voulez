//
//  MovieRow.swift
//  CeQueVousVoulez
//
//  Created by digital on 23/05/2023.
//

import Foundation
import SwiftUI

struct MovieRow: View {
    private let movie: Movie
    @Environment(\.colorScheme) private var colorScheme
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    var body: some View {
        NavigationLink {
            DetailView(movieId: movie.id)
        } label: {
            HStack(alignment: .top) {
                AsyncImage(url: URL(string: "https://www.themoviedb.org/t/p/w1280" + movie.posterPath)) { image in
                    image
                        .resizable()
                        .frame(width: 85, height: 128)
                        .cornerRadius(8)
                } placeholder: {
                    ProgressView()
                        .frame(width: 85, height: 128)
                        .cornerRadius(8)
                }
                
                VStack(alignment: .leading) {
                    Text(movie.title)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(colorScheme == .light ? Color.black : Color.white)
                        .multilineTextAlignment(.leading)
                    
                    Text(movie.releaseYear)
                        .font(.title3)
                        .foregroundColor(colorScheme == .light ? Color.black : Color.white)
                        .multilineTextAlignment(.leading)
                    
                    if let vote = Float(movie.vote) {
                        StarComponent(vote: vote)
                    }
                }
            }
        }
        .padding()
    }
}

struct MovieRow_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GenreView(genre: Genre(dto: GenreDTO(id: 1, name: "Action")))
        }
        .environment(\.sizeCategory, .large)
    }
}
