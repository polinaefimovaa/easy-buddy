import SwiftUI

struct ArticleView: View {
    @StateObject private var fetcher = DataFetcher()
    @State private var currentPage: Int = 0
    @State private var selectedTab = 3
    
    var body: some View {
        TabView(selection: $currentPage) {
            ArticleSectionView(article: fetcher.article)
                .tag(0)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .onAppear {
            fetcher.fetchData()
        }
    }
}
