//
//  Movie.swift
//  ios101-lab6-flix
//

import Foundation

struct MovieFeed: Decodable {
    let results: [Movie]
}

struct Movie: Codable, Equatable {
    let title: String
    let overview: String
    let posterPath: String? // Path used to create a URL to fetch the poster image

    // MARK: Additional properties for detail view
    let backdropPath: String? // Path used to create a URL to fetch the backdrop image
    let voteAverage: Double?
    let releaseDate: Date?

    // MARK: ID property to use when saving movie
    let id: Int

    // MARK: Custom coding keys
    // Allows us to map the property keys returned from the API that use underscores (i.e. `poster_path`)
    // to a more "swifty" lowerCamelCase naming (i.e. `posterPath` and `backdropPath`)
    enum CodingKeys: String, CodingKey {
        case title
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case id
    }
}

extension Movie {
  static func saveMovie(_ movies: [Movie], forKey key: String) {
    let userDefaults = UserDefaults.standard
    let data = try! JSONEncoder().encode(movies)
    userDefaults.set(data, forKey: key)
  }
  
  static func getMovie(forKey key: String) -> [Movie] {
    let userDefaults = UserDefaults.standard
    if let data = userDefaults.data(forKey: key) {
      let decodedData = try! JSONDecoder().decode([Movie].self, from: data)
      return decodedData
    } else {
      return []
    }
  }
  
  func addToFavorites() {
    var favoriteMovies = Movie.getMovie(forKey: "Favorites")
    favoriteMovies.append(self)
    Movie.saveMovie(favoriteMovies, forKey: "Favorites")
  }
  
  func removeFromFavorites() {
    var favoriteMovies = Movie.getMovie(forKey: "Favorites")
    favoriteMovies.removeAll { $0 == self }
    Movie.saveMovie(favoriteMovies, forKey: "Favorites")
  }
}
