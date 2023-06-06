//
//  MovieHList.swift
//  CeQueVousVoulez
//
//  Created by digital on 22/05/2023.
//

import Foundation
import SwiftUI

struct MovieHList: View {
    @State private var error: Error? = nil
    @State private var movies: [Movie]?
    @State private var moviePage: Int = 1
    private let movieType: MovieFetcher.MovieFilterType
    
    init(filterType: MovieFetcher.MovieFilterType?) {
        self.movieType = filterType ?? MovieFetcher.MovieFilterType.popular
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            if let movies = self.movies {
                LazyHStack {
                    ForEach(movies, id: \.self) { movie in
                        MovieCard(movie: movie)
                            .padding(.leading, movie == movies.first ? 16 : 0)
                    }
                    .frame(height: 255)
                    Button(action: {
                        Task {
                            self.moviePage += 1
                            let newItems = try await MovieFetcher.fetchList(
                                type: movieType,
                                page: moviePage
                            )
                            self.movies = self.movies! + newItems
                        }
                    }) {
                        ZStack {
                            Color.gray
                            Image(systemName: "plus")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                        }
                    }
                    .frame(width: 100, height: 255)
                    .cornerRadius(8)
                }
            } else {
                ProgressView()
            }
        }
        .task {
            do {
                self.movies = try await MovieFetcher.fetchList(type: movieType, page: 1)
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
