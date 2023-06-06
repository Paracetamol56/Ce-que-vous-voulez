//
//  GenreView.swift
//  CeQueVousVoulez
//
//  Created by digital on 22/05/2023.
//

import Foundation
import SwiftUI

struct GenreView: View {
    private let genre: Genre
    @State private var movies: [Movie]?
    @State private var moviePage: Int = 1
    
    init(genre: Genre) {
        self.genre = genre
    }
    
    var body: some View {
        ScrollView {
            if let movies = self.movies {
                VStack(alignment: .leading) {
                    ForEach(movies) { movie in
                        MovieRow(movie: movie)
                    }
                }
            } else {
                ProgressView()
            }
        }
        .task {
            do {
                self.movies = try await MovieFetcher.fetchByGenre(genre: self.genre.id, page: 1)
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
        .navigationTitle(self.genre.name)
    }
}

struct GenreView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GenreView(genre: Genre(dto: GenreDTO(id: 1, name: "Action")))
        }
        .environment(\.sizeCategory, .large)
    }
}
