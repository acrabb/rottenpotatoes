class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end


  def index
    @all_ratings = Movie.all_ratings
    redirect = false

    # get params :from
    @from = params[:from]
    logger.debug(params)
    logger.debug(session)
    # if :from is nil check the session
    if @from == nil
        from = session[:from]
      # if the session is not nil
        if from != nil and from != ""
          @from = from
        # redirect is true
          redirect = true
          logger.debug("SHOULD REDIRECT 1")
        else
      # if the session is nil
        # from should be empty string
          @from = ""
        end
    # if :from is not nil
    else
      # write :from to session
      session[:from] = @from
    end

    # get params :ratings
    @checked  = params[:ratings]
    # if :ratings is nil check the session
    if @checked == nil
      checked = session[:ratings]
      # if the session is not nil
      if checked != nil
        @checked = checked
        # redirect is true
        redirect = true
        logger.debug("SHOULD REDIRECT 2")
      # if the session is nil
      else
        # check all boxes
        @checked = {}
        @all_ratings.each do |rating|
          @checked[rating] = "true"
        end
      end
    else
    # if :ratings is not nil
      # write :ratings to session
      session[:ratings] = @checked
    end


    if redirect
      logger.debug("REDIRECTED!!!")
      flash.keep
      redirect_to movies_path({:from => @from, :ratings => @checked})
    end

    # return the movies
    keys = @checked.keys
    @movies = Movie.where(:rating => keys).order(@from)
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
