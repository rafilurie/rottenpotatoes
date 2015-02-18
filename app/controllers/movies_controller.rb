class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    sort = params[:sort]
    ratings = params[:ratings]
    sort_not_change = false
    ratings_not_change = false
    if ratings
      # if ratings.class == Hash
      @existing = ratings
      # else
      #   @existing = ratings
      # end
      # @existing = ratings.keys
      session['ratfil'] = @existing
    elsif session['ratfil']
      @existing = session['ratfil']
      ratings_not_change = true
    else
      @existing = {"G" =>"1", "PG" =>"1","PG-13" =>"1", "R" =>"1"}
      session['ratfil'] = @existing
    end
    @movies = Movie.where(rating: @existing.keys)

    if sort
      if sort == 'title'
        @movies = @movies.order(:title)
        session['sortfil'] = 'title'
      else
        @movies = @movies.order(:release_date)
        session['sortfil'] = 'date'
      end
    elsif session['sortfil']
      sort_not_change = true
      if session['sortfil'] == 'title'
        @movies = @movies.order(:title)
      else
        @movies = @movies.order(:release_date)
      end
    end
    
    if sort_not_change
      if ratings_not_change
        flash.keep
        redirect_to movies_path(:sort => session['sortfil'], :ratings => session['ratfil'])
      else
        flash.keep
        redirect_to movies_path(:sort => session['sortfil'], :ratings => params[:ratings])
      end
    else
      if ratings_not_change
        flash.keep
        redirect_to movies_path(:sort => params[:sort],:ratings => session['ratfil'])
      end
    end

  end

  def new
    # default: render 'new' template
    reset_session
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
