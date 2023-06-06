//
//  VideoPlayer.swift
//  CeQueVousVoulez
//
//  Created by digital on 18/04/2023.
//

import Foundation
import SwiftUI
import WebKit

struct VideoPlayerView: UIViewRepresentable {
    var videoID: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let url = URL(string: "https://www.youtube.com/embed/\(videoID)") else {
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
