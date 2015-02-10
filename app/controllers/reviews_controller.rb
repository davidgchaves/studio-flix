class ReviewsController < ApplicationController
  before_action :set_movie, only: [:index, :new, :create]

  def index
    @reviews = @movie.reviews
  end

  def new
    @review = @movie.reviews.new
  end

  def create
    @review = @movie.reviews.new review_params
    if @review.save
      redirect_to movie_reviews_path(@movie), notice: "Thanks for your review!"
    else
      render :new
    end
  end

  private
    def review_params
      params.require(:review).permit :name, :stars, :comment, :location
    end

    def set_movie
      @movie = Movie.find params[:movie_id]
    end
end
