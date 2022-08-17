class Movie < ApplicationRecord

    before_save :set_slug

    has_many :reviews, dependent: :destroy
    has_many :favorites, dependent: :destroy
    has_many :fans, through: :favorites, source: :user
    
    has_many :characterizations, dependent: :destroy
    has_many :genres, through: :characterizations

    has_one_attached :main_image

    validates :title, presence: true, uniqueness: true
    validates :released_on, :duration, :director, presence: true

    validates :description, length: { minimum: 25 }

    validates :total_gross, numericality: { greater_than_or_equal_to: 0}
    
    validate :acceptable_image

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

    def acceptable_image
        return unless main_image.attached?

        errors.add(:main_image, "is too big") unless main_image.blob.byte_size <= 1.megabyte

        acceptable_types = ["image/jpeg", "image/png"]
        errors.add(:main_image, "must be JPEG or PNG") unless acceptable_types.include?(main_image.content_type)
    end
end