//
//  HomeView.swift
//  Ce}VousVoulez
//
//  Created by digital on 18/04/2023.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @State private var searchText: String = ""
    @State private var searchSheetDisplayed: Bool = false
    @State private var genres: [Genre]?
    
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        ScrollView {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color(.systemGray))
                    .padding([.top, .leading, .bottom], 8)
                TextField("home.search", text: $searchText, onCommit: { searchSheetDisplayed.toggle()})
                    .foregroundColor(Color(.systemGray))
                    .multilineTextAlignment(.leading)
                    .padding(.vertical, 8.0)
                Spacer()
            }
                .background(Color(.systemGray5))
                .cornerRadius(8)
                .padding([.top, .leading, .trailing])
                .sheet(isPresented: $searchSheetDisplayed) {
                    SearchSheet(searchText: $searchText)
                }
            VStack(alignment: .leading) {
                Text("home.popular")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                MovieHList(filterType: MovieFetcher.MovieFilterType.popular)
                
                Spacer()
                
                Text("home.top_rated")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                MovieHList(filterType: MovieFetcher.MovieFilterType.topRated)
                
                NavigationLink(destination: GenreSelectView()) {
                    Text("home.all_categories")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Image("interior-theatre-theater-empty-theater")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width)
                        
                        VStack(alignment: .leading) {
                            Text("home.map")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                            NavigationLink(destination: TheaterMapView()) {
                                Text("home.map_button")
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                            .padding()
                        }
                    }
                }
                .frame(height: 500)
            }
        }
        .navigationTitle("home.title")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
        }
        .environment(\.sizeCategory, .large)
    }
}
