class Movie < ApplicationRecord

    before_save :set_slug

    has_many :reviews, dependent: :destroy
    has_many :favorites, dependent: :destroy
    has_many :fans, through: :favorites, source: :user
    
    has_many :characterizations, dependent: :destroy
    has_many :genres, through: :characterizations

    validates :title, presence: true, uniqueness: true
    validates :released_on, :duration, :director, presence: true

    validates :description, length: { minimum: 25 }

    validates :total_gross, numericality: { greater_than_or_equal_to: 0}

    validates :image_file_name, format: {
        with: /\w+\.(jpg|png)\z/i,
        message: "must be a JPG or PNG image"
    }

    RATINGS = %w(G PG PG-13 R NC-17)

    validates :rating, inclusion: {in: RATINGS}

    FLOP_VALUE = 225_000_000
    CULT_REVIEWS_SIZE = 50
    CULT_AVERAGE_STARS = 4

    def flop?
        return total_gross.blank? || total_gross < FLOP_VALUE unless cult?

        false
    end
    
    scope :released, -> { where("released_on < ?", Time.now).order("released_on desc") }
    scope :upcoming, -> { where("released_on > ?", Time.now).order("released_on asc") }
    scope :recent, ->(max = 5) { released.limit(max) }

    def average_stars
        reviews.average(:stars) || 0.0
    end

    def average_stars_as_percent
        (average_stars / 5.0) * 100.0
    end

    def cult?
        reviews.size > CULT_REVIEWS_SIZE && average_stars >= CULT_AVERAGE_STARS
    end

    def to_param
        slug
    end

private
    def set_slug
        self.slug = title.parameterize
    end
end
