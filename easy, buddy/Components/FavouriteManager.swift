import Foundation

class FavoritesManager: ObservableObject {
    @Published var favorites: Set<Int> = [] // Храним ID избранных статей

    init() {
        loadFavorites()
    }

    func addToFavorites(articleID: Int) {
        favorites.insert(articleID)
        saveFavorites()
    }

    func removeFromFavorites(articleID: Int) {
        favorites.remove(articleID)
        saveFavorites()
    }

    func isFavorite(articleID: Int) -> Bool {
        favorites.contains(articleID)
    }

    private func saveFavorites() {
        let savedData = Array(favorites)
        UserDefaults.standard.set(savedData, forKey: "favorites")
    }

    private func loadFavorites() {
        if let savedData = UserDefaults.standard.array(forKey: "favorites") as? [Int] {
            favorites = Set(savedData)
        }
    }
}
class FavoritesDiscussion: ObservableObject {
    @Published var favorites: Set<Int> = [] // Храним ID избранных статей

    init() {
        loadFavorites()
    }

    func addToFavorites(discussionID: Int) {
        favorites.insert(discussionID)
        saveFavorites()
    }

    func removeFromFavorites(discussionID: Int) {
        favorites.remove(discussionID)
        saveFavorites()
    }

    func isFavorite(discussionID: Int) -> Bool {
        favorites.contains(discussionID)
    }

    private func saveFavorites() {
        let savedData = Array(favorites)
        UserDefaults.standard.set(savedData, forKey: "favorites")
    }

    private func loadFavorites() {
        if let savedData = UserDefaults.standard.array(forKey: "favorites") as? [Int] {
            favorites = Set(savedData)
        }
    }
}

