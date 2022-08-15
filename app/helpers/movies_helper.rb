module MoviesHelper
    def total_gross(movie)
        return number_to_currency(movie.total_gross, precision: 0) unless movie.flop?
        
        "Flop!"
    end
    
    def year_of(movie)
        movie.released_on.year
    end

    def nav_link_to(text, url)
        return link_to(text, url) unless current_page?(url)

        link_to(text, url, class: "active")
    end
end
