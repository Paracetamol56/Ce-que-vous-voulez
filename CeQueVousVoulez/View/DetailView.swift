//
//  ContentView.swift
//  CeQueVousVoulez
//
//  Created by digital on 04/04/2023.
//

import SwiftUI
import YouTubePlayerKit

struct DetailView: View {
    private let movieId: Int
    @State private var trailerSheetDisplayed: Bool = false
    @State private var movie: Movie?
    @State private var trailer: Video?
    @Environment(\.colorScheme) private var colorScheme
    
    init(movieId: Int) {
        self.movieId = movieId
    }
    
    var body: some View {
        ScrollView {
            if let movie {
                headerBackground
                VStack() {
                    HStack(alignment: .top) {
                        AsyncImage(
                            url: URL(string: "https://www.themoviedb.org/t/p/w1280" + movie.posterPath),
                            content: {image in
                                image.image?
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 128)
                                    .cornerRadius(8)
                                
                            }
                        )
                        .padding(.trailing, 12.0)
                        VStack(alignment: .leading) {
                            Text(movie.title)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)
                            Text(movie.subtitle)
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)
                            StarComponent(vote: movie.vote)
                        }
                        Spacer()
                    }
                    .padding()
                    VStack(alignment: .leading) {
                        Text("\(movie.releaseYear) - \(movie.getDurationString())")
                        Spacer()
                        ScrollView(.horizontal) {
                            HStack() {
                                ForEach(movie.genres, id: \.self) { genre in
                                    NavigationLink("#" + genre.name, destination: GenreView(genre: genre))
                                }
                            }
                        }
                        Spacer(minLength: 16)
                        Text(movie.synopsis)
                        Spacer(minLength: 16)
                    }
                    .padding()
                }
            } else {
                ProgressView()
            }
        }
        .edgesIgnoringSafeArea(.all)
        .task {
            do {
                self.movie = try await MovieFetcher.fetchOne(id: self.movieId)
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    var headerBackground: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                if let movie = movie {
                    AsyncImage(
                        url: URL(string: "https://www.themoviedb.org/t/p/w1280" + movie.backdropPath),
                        content: {image in
                            image.image?
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: 500)
                        }
                    )
                    LinearGradient(
                        gradient: Gradient(colors: [Color.clear, colorScheme == .dark ? Color.black : Color.white]),
                        startPoint: .center,
                        endPoint: .bottom
                    )
                    Button(action: {
                        trailerSheetDisplayed.toggle()
                    }) {
                        Image(systemName: "play.fill")
                            .foregroundColor(.white)
                            .font(.title)
                    }
                    .sheet(isPresented: $trailerSheetDisplayed) {
                        sheetContent
                    }
                }
            }
        }
        .frame(height: 425)
    }
    
    var sheetContent: some View {
        VStack(alignment: .center) {
            if let trailer = self.trailer {
                let configuration = YouTubePlayer.Configuration(
                    // Define which fullscreen mode should be used (system or web)
                    fullscreenMode: .system,
                    // Enable auto play
                    autoPlay: true,
                    // Hide controls
                    showControls: false,
                    // Enable loop
                    loopEnabled: false
                )
                let youTubePlayer = YouTubePlayer(
                    source: .video(id: trailer.key),
                    configuration: configuration
                )
                YouTubePlayerView(youTubePlayer) { state in
                    switch state {
                    case .idle:
                        ProgressView()
                    case .ready:
                        EmptyView()
                    case .error:
                        EmptyView()
                    }
                }
            } else {
                ProgressView()
            }
        }.task {
            do {
                self.trailer = try await MovieFetcher.fetchTrailer(id: movieId)
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(movieId: 385687)
        }
    }
}
