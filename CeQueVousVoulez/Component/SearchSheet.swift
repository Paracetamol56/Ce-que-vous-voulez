//
//  SearchSheet.swift
//  CeQueVousVoulez
//
//  Created by digital on 06/06/2023.
//

import Foundation
import SwiftUI

struct SearchSheet: View {
    @Binding var searchText: String
    @State private var searchMovies: [Movie] = []
    
    var body: some View {
        NavigationView() {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Recherche")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding()
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color(.systemGray))
                            .padding([.top, .leading, .bottom], 8)
                        TextField("Search", text: $searchText)
                            .foregroundColor(Color(.systemGray))
                            .multilineTextAlignment(.leading)
                            .padding(.vertical, 8.0)
                        Spacer()
                    }
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
                    .padding([.top, .leading, .trailing])
                    
                    if let searchMovies = self.searchMovies {
                        VStack(alignment: .leading) {
                            ForEach(searchMovies) { movie in
                                MovieRow(movie: movie)
                            }
                        }
                    } else {
                        ProgressView()
                    }
                    Spacer()
                }
                .task {
                    do {
                        self.searchMovies = try await MovieFetcher.fetchManySearch(search: searchText, page: 1)
                        print(self.searchMovies)
                    }
                    catch let error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}
