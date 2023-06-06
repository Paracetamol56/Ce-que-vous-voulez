//
//  Genre.swift
//  CeQueVousVoulez
//
//  Created by digital on 17/04/2023.
//

import Foundation

struct Genre: Hashable, Identifiable {
    let id: Int
    let name: String
    
    init(dto: GenreDTO) {
        self.id = dto.id ?? 0
        self.name = dto.name ?? ""
    }
}
