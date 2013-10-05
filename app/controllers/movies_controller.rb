class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end


  def index
#@movies = Movie.all
    @all_ratings = Movie.all_ratings
    @checked = params[:ratings]
    if params[:ratings] == nil
      @checked = {}
      @all_ratings.each do |rating|
        @checked[rating] = "true"
      end
    end
    logger.debug(@checked)
    @movies = Movie.all
    from = params[:from]
    @from = from == nil ? "" : from
#logger.debug(params[:ratings].keys)
    keys = @checked.keys
    @movies = Movie.where(:rating => keys).order(from)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
