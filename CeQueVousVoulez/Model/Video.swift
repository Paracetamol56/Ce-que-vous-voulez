//
//  Video.swift
//  CeQueVousVoulez
//
//  Created by digital on 17/04/2023.
//

import Foundation

struct Video: Hashable {
    let name: String
    let key: String
    let site: String
    let type: String
    
    init(dto: VideoDTO) {
        self.name = dto.name!
        self.key = dto.key!
        self.site = dto.site!
        self.type = dto.type!
    }
}
