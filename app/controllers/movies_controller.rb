class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end


  def index
#@movies = Movie.all
    @all_ratings = Movie.all_ratings

    # get saved session states
    @checked  = session[:ratings]
    @from     = session[:from]
    @from     = @from == nil ? "" : @from

    checked = params[:ratings]
    @checked = checked if checked != nil

    from  = params[:from]
    from  = from == nil ? "" : from
    @from = from if from != ""

    # create the hash if its nil
    if @checked == nil
      @checked = {}
      @all_ratings.each do |rating|
        @checked[rating] = "true"
      end
    end
    @movies = Movie.all
    keys = @checked.keys

    # save curent session
    session[:ratings] = @checked
    session[:from] = @from

    # return the movies
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
