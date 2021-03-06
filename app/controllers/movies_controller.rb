class MoviesController < ApplicationController
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
    
  end

  def index
    @all_ratings = Movie.all_ratings
    @header_class = params[:header_clicked]
    @ratings_to_show = Movie.ratings_to_show(params[:ratings])
#     byebug
    if @header_class == nil and @ratings_to_show == [] and session[:filters] != nil
#       byebug
      if session[:filters][0] != nil
        @ratings_to_show = session[:filters][0].keys
      end
      @header_class = session[:filters][1]
    end
#     byebug
    @movies = Movie.with_ratings(@ratings_to_show, @header_class)
    session[:filters] = [params[:ratings], params[:header_clicked]]
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
 

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

end
