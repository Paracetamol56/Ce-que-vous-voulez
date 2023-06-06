//
//  GenreFetcher.swift
//  CeQueVousVoulez
//
//  Created by digital on 22/05/2023.
//

import Foundation

struct GenreFetcher {
    
    enum GenreFetcherError: Error {
        case invalidURL
        case missingData
    }
    
    static func fetchAll() async throws -> [Genre] {
        guard let url = URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=\(apiKey)&language=\(Locale.preferredLanguages[0])") else {
            throw GenreFetcherError.invalidURL
        }

        // Use the async variant of URLSession to fetch data
        // Code might suspend here
        let (data, _) = try await URLSession.shared.data(from: url)

        // Parse the JSON data
        let genreResultDTO: GenreResultDTO = try JSONDecoder().decode(GenreResultDTO.self, from: data)
        let genres: [Genre] = genreResultDTO.genres!.map { genreDTO in
            return Genre(dto: genreDTO)
        }
        return genres
    }
}
