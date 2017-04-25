require 'themoviedb'

class MoviesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :search]
  before_action :set_movie, only: [:show, :edit, :update, :destroy]
  Tmdb::Api.key("5fce29b5051471c929ab77ad804cb5d0")
  # GET /movies
  # GET /movies.json
  def index
    @movies = Tmdb::Movie.now_playing + Tmdb::Movie.top_rated
    if params[:order] == "title"
      @movies.sort! { |a,b| a.title <=> b.title }
      @subheadline = "by Title"
    elsif params[:order] == "release"
      @movies.sort! { |a,b| a.release_date <=> b.release_date }
      @subheadline = "by Release Date"
    elsif params[:order] == "genre"
      @movies.sort! { |a,b| a.genres <=> b.genres }
      @subheadline = "by Genre"
    end
  end
  
  def search
    @movies = Tmdb::Movie.now_playing + Tmdb::Movie.top_rated
    if params[:order] == "title"
      @movies.sort! { |a,b| a.title <=> b.title }
      @subheadline = "by Title"
    elsif params[:order] == "release"
      @movies.sort! { |a,b| a.release_date <=> b.release_date }
      @subheadline = "by Release Date"
    elsif params[:order] == "genre"
      @movies.sort! { |a,b| a.genres <=> b.genres }
      @subheadline = "by Genre"
    else
      @movies.sort! { |a,b| a.title <=> b.title }
    end
  end


  # GET /movies/1
  # GET /movies/1.json
  def show
    @movie = Tmdb::Movie.detail(params[:id])
    @reviews = Review.where(movie_id: @movie['id']).order("created_at DESC")
    @review = Review.new
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies
  # POST /movies.json
  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: 'Movie was successfully created.' }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1
  # PATCH/PUT /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: 'Movie was successfully updated.' }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.json
  def destroy
    @movie.destroy
    respond_to do |format|
      format.html { redirect_to movies_url, notice: 'Movie was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Tmdb::Movie.detail(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def movie_params
      params.require(:movie).permit(:title, :genre, :release_date)
    end
end
