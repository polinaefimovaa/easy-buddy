import SwiftUI
// Секции
struct ArticleSectionView: View {
    let article: [Article]

    var body: some View {
        ScrollView {
                SectionView(title: "Tips&Tricks", tags: article) { article in
                    ArticleCard(article: article)
                }
                .padding(.horizontal,16)
        }
    }
}
