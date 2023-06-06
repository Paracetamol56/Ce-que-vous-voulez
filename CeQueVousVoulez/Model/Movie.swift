//
//  Movie.swift
//  CeQueVousVoulez
//
//  Created by digital on 04/04/2023.
//

import Foundation

struct Movie: Hashable, Identifiable {
    let id: Int
    let title: String
    let subtitle: String
    let releaseYear: String
    let duration: Int
    let vote: Float
    let genres: [Genre]
    let synopsis: String
    let backdropPath: String
    let posterPath: String
    
    init(dto: MovieDTO) {
        self.id = dto.id ?? 0
        self.title = dto.title ?? ""
        self.subtitle = dto.tagline ?? ""
        
        if let releaseDate = dto.release_date {
            self.releaseYear = String(releaseDate.prefix(4))
        } else {
            self.releaseYear = ""
        }
        
        self.duration = dto.runtime ?? 0
        self.vote = dto.vote_average ?? 0
        
        if let genres = dto.genres {
            self.genres = genres.map { genreDTO in
                return Genre(dto: genreDTO)
            }
        } else {
            self.genres = []
        }
        
        self.synopsis = dto.overview ?? ""
        self.backdropPath = dto.backdrop_path ?? ""
        self.posterPath = dto.poster_path ?? ""
    }
    
    func getDurationString() -> String {
        return "\(duration / 60)h\(duration % 60)m"
    }
}
