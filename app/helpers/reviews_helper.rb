module ReviewsHelper
    def average_stars(movie)
        average_stars = number_with_precision(movie.average_stars, precision: 1)
        return pluralize(average_stars, "star") unless movie.average_stars.zero?

        content_tag(:strong, "No Reviews")
    end
end
