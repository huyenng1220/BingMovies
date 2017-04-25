require 'themoviedb'
class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  Tmdb::Api.key("5fce29b5051471c929ab77ad804cb5d0")
  # GET /reviews
  # GET /reviews.json
  def index
    @movie = Tmdb::Movie.detail(params[:movie_id])
    @reviews = Review.where(movie_id: @movie['id']).order("created_at DESC")
  end

  # GET /reviews/1
  # GET /reviews/1.json
  def show

  end

  def new
    @review = Review.new
    @movie = Tmdb::Movie.detail(params[:id])
    render :new
  end

  def create
    movie = Tmdb::Movie.detail(params[:id])
    @review = Review.new(review_params)
    @review.user = current_user
    @review.movie_id = params[:movie_id]

    if @review.save
      redirect_to root_url
    else
      render :new, status: 422
    end
  end

  # PATCH/PUT /reviews/1
  # PATCH/PUT /reviews/1.json
  def update
    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to @review, notice: 'Review was successfully updated.' }
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { render :edit }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    @review.destroy
    respond_to do |format|
      format.html { redirect_to reviews_url, notice: 'Review was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def review_params
      params.require(:review).permit(:rating, :review)
    end
end
