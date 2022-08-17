module FavoritesHelper
    def fave_or_unfave_button(movie, favorite)
        return button_to "♡ Fave", movie_favorites_path(movie) unless favorite

        button_to "♥️ Unfave", movie_favorite_path(movie, favorite), method: :delete 
    end
end
