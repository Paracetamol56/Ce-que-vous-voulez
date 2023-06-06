//
//  MovieDTO.swift
//  CeQueVousVoulez
//
//  Created by digital on 17/04/2023.
//

import Foundation

struct MovieDTO : Decodable {
    let id: Int?
    let title: String?
    let tagline: String?
    let release_date: String?
    let runtime: Int?
    let vote_average: Float?
    let genres: [GenreDTO]?
    let overview: String?
    let backdrop_path: String?
    let poster_path: String?
}
