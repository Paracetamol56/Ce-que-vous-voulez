//
//  MovieFetcher.swift
//  CeQueVousVoulez
//
//  Created by digital on 18/04/2023.
//

import Foundation

struct MovieFetcher {
    
    enum MovieFetcherError: Error {
        case invalidURL
        case missingData
    }
    
    static func fetchOne(id: Int) async throws -> Movie {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)?api_key=\(apiKey)&language=\(Locale.preferredLanguages[0])") else {
            throw MovieFetcherError.invalidURL
        }

        // Use the async variant of URLSession to fetch data
        // Code might suspend here
        let (data, _) = try await URLSession.shared.data(from: url)

        // Parse the JSON data
        let movieDTO: MovieDTO = try JSONDecoder().decode(MovieDTO.self, from: data)
        return Movie(dto: movieDTO)
    }
    
    static func fetchVideos(id: Int) async throws -> [Video] {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)/videos?api_key=\(apiKey)&language=\(Locale.preferredLanguages[0])") else {
            throw MovieFetcherError.invalidURL
        }

        // Use the async variant of URLSession to fetch data
        // Code might suspend here
        let (data, _) = try await URLSession.shared.data(from: url)

        // Parse the JSON data
        let videoResultDTO: VideoResultDTO = try JSONDecoder().decode(VideoResultDTO.self, from: data)
        let videos: [Video] = videoResultDTO.results!.map{ videoDTO in
            return Video(dto: videoDTO)
        }
        return videos
    }
    
    static func fetchTrailer(id: Int) async throws -> Video? {
        let videos = try await fetchVideos(id: id)
        return videos.first(where: { $0.type == "Trailer" && $0.site == "YouTube" })
    }
    
    enum MovieFilterType {
        case popular
        case upComming
        case topRated
    }

    static func fetchList(type: MovieFilterType, page: Int) async throws -> [Movie] {
        var urlString: String = ""
        switch type {
        case .popular:
            urlString = "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&language=\(Locale.preferredLanguages[0])&sort_by=popularity.desc&include_adult=false&include_video=false&page=\(page)&with_watch_monetization_types=flatrate"
            break
        case .upComming:
            urlString = "https://api.themoviedb.org/3/movie/upcoming?api_key=\(apiKey)&language=\(Locale.preferredLanguages[0])&sort_by=popularity.desc&include_adult=false&include_video=false&page=\(page)&with_release_type=2|3&with_watch_monetization_types=flatrate"
            break
        case .topRated:
            urlString = "https://api.themoviedb.org/3/movie/top_rated?api_key=\(apiKey)&language=\(Locale.preferredLanguages[0])&sort_by=vote_average.desc&include_adult=false&include_video=false&page=\(page)&with_watch_monetization_types=flatrate"
            break
        }
                    
        guard let url = URL(string: urlString) else {
            throw MovieFetcherError.invalidURL
        }

        // Use the async variant of URLSession to fetch data
        // Code might suspend here
        let (data, _) = try await URLSession.shared.data(from: url)

        // Parse the JSON data
        let movieResultDTO: MovieResultDTO = try JSONDecoder().decode(MovieResultDTO.self, from: data)
        let movies: [Movie] = movieResultDTO.results!.map{ movieDTO in
            return Movie(dto: movieDTO)
        }
        return movies
    }
    
    static func fetchByGenre(genre: Int, page: Int) async throws -> [Movie] {
        guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)&language=\(Locale.preferredLanguages[0])&sort_by=popularity.desc&include_adult=false&include_video=false&page=\(page)&with_watch_monetization_types=flatrate&with_genres=\(genre)"
        ) else {
            throw MovieFetcherError.invalidURL
        }

        // Use the async variant of URLSession to fetch data
        // Code might suspend here
        let (data, _) = try await URLSession.shared.data(from: url)

        // Parse the JSON data
        let movieResultDTO: MovieResultDTO = try JSONDecoder().decode(MovieResultDTO.self, from: data)
        let movies: [Movie] = movieResultDTO.results!.map{ movieDTO in
            return Movie(dto: movieDTO)
        }
        return movies
    }
    
    static func fetchManySearch(search: String, page: Int) async throws -> [Movie] {
        guard let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&language=\(Locale.preferredLanguages[0])&include_adult=false&include_video=false&page=\(page)&with_watch_monetization_types=flatrate&query=\(search.replacingOccurrences(of: " ", with: "+"))"
        ) else {
            throw MovieFetcherError.invalidURL
        }

        // Use the async variant of URLSession to fetch data
        // Code might suspend here
        let (data, _) = try await URLSession.shared.data(from: url)

        // Parse the JSON data
        let movieResultDTO: MovieResultDTO = try JSONDecoder().decode(MovieResultDTO.self, from: data)
        let movies: [Movie] = movieResultDTO.results!.map{ movieDTO in
            return Movie(dto: movieDTO)
        }
        return movies
    }
}
