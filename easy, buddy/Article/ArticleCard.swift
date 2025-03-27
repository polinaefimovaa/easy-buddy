import SwiftUI

// Загружаю данные
class DataFetcher: ObservableObject {
    @Published var article: [Article] = []
    @Published var searchText = ""
    
    var filteredArticles: [Article] {
        if searchText.isEmpty {
            return article
        } else {
            return article.filter { article in
                article.title.localizedCaseInsensitiveContains(searchText) ||
                article.content.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    func fetchData() {
        guard let url = URL(string: "http://localhost:3000/api/v1/posts") else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode([Article].self, from: data)
                    DispatchQueue.main.async {
                        self.article = decodedData
                    }
                } catch {
                    print("Error decoding JSON:", error)
                }
            } else if let error = error {
                print("Network error:", error)
            }
        }.resume()
    }
}

struct ArticleCard: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    let article: Article
    
    private var cardBackgroundColor: Color {
        switch article.tag {
        case "STUDYING": return Color(.green300)
        case "LIFE": return Color(.pink300)
        case "DOCUMENTS": return Color(.red300)
        default: return Color.gray.opacity(0.2)
        }
    }
    
    var body: some View {
        VStack(alignment: .trailing) {
            if let imageUrl = URL(string: article.postImage.url) {
                ZStack(alignment: .topTrailing) {
                    AsyncImage(url: imageUrl) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .background(Color.clear)
                        } else if phase.error != nil {
                            Color.clear
                        } else {
                            ProgressView()
                                .progressViewStyle(.circular)
                        }
                    }
                    .frame(width: 124)
                    .background(Color.clear)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    tags(text: article.tag)
                    Spacer()
                }
                .frame(width: 333)
                
                H4(text: article.title)
                    .frame(width: 225, alignment: .leading)
                    .padding(0)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .frame(width: 357)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(cardBackgroundColor)
        )
    }
}

struct SectionView<Item: Hashable, Content: View>: View {
    @State private var selectedTag: String = "ALL"
    @State private var searchText = ""
    
    let title: String
    let tags: [Item]
    let tags_filter = ["ALL", "LIFE", "DOCUMENTS", "STUDYING"]
    let content: (Item) -> Content
    
    var body: some View {
        VStack(alignment: .leading) {
            H1(text: title)
                .frame(width: 300)
            
            // Поисковая строка
            SearchBar(text: $searchText)
                .padding(.bottom, 12)
            
            // Горизонтальный ScrollView для тегов
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 12) {
                    ForEach(tags_filter, id: \.self) { tag in
                        TagView(tag: tag, isSelected: selectedTag == tag) {
                            selectedTag = tag
                        }
                    }
                }
            }
            
            VStack(spacing: 16) {
                ForEach(filteredTags(), id: \.self) { item in
                    if shouldShowItem(item) {
                        content(item)
                    }
                }
            }
        }
    }
    
    private func filteredTags() -> [Item] {
        if selectedTag == "ALL" {
            return tags
        } else {
            return tags.filter { tag in
                guard let article = tag as? Article else { return false }
                return article.tag == selectedTag
            }
        }
    }
    
    private func shouldShowItem(_ item: Item) -> Bool {
        guard let article = item as? Article else { return true }
        return searchText.isEmpty ||
               article.title.localizedCaseInsensitiveContains(searchText) ||
               article.content.localizedCaseInsensitiveContains(searchText)
    }
}

// Компонент поисковой строки
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                // Фон и обводка
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.greyscale100, lineWidth: 0.7)
                    .frame(height: 40)
                
                HStack {
                    // Иконка поиска
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.greyscale500)
                        .padding(.leading, 12)
                    
                    // Текстовое поле
                    TextField("Search", text: $text)
                        .font(.custom("TTHoves-Regular", size: 14))
                        .foregroundColor(.greyscale500)
                        .padding(.vertical, 12)
                        .padding(.trailing, 12)
                        .overlay(
                            // Кнопка очистки
                            HStack {
                                Spacer()
                                if !text.isEmpty {
                                    Button(action: {
                                        text = ""
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.greyscale500)
                                            .padding(.trailing, 12)
                                    }
                                }
                            }
                        )
                }
            }
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}
