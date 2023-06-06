//
//  GenreSelectView.swift
//  CeQueVousVoulez
//
//  Created by digital on 22/05/2023.
//

import Foundation
import SwiftUI

struct GenreSelectView: View {
    @State private var genres: [Genre]?
    
    var body: some View {
        List {
            if let genres = self.genres {
                ForEach(genres) { genre in
                    NavigationLink(destination: GenreView(genre: genre)) {
                        Text(genre.name)
                    }
                }
            } else {
                ProgressView()
            }
        }
        .navigationTitle("categories.title")
        .task {
            do {
                self.genres = try await GenreFetcher.fetchAll()
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
    }
}

struct GenreSelectView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GenreSelectView()
        }
    }
}

