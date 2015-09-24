class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    if(params[:ratings] != nil && session[:ratings]!=params[:ratings])
        session[:ratings] = params[:ratings]
    end
    if(params[:sort] != nil && session[:sort]!=params[:sort])
        session[:sort] = params[:sort]
    end 

    new_value = { :sort => session[:sort], :ratings => session[:ratings] }
    pre_value = { :sort => params[:sort], :ratings => params[:ratings] }
    
    if (new_value != pre_value)
      flash.keep 	
      redirect_to movies_path(new_value)
    end      
    
    if(session[:ratings]==nil)
	@filtered_ratings = Movie.all_ratings
    else
	@filtered_ratings = session[:ratings].keys
    end			
    if(session[:sort]=='title')
	@title_header='hilite'
	if(session[:ratings])
		@movies = Movie.where("rating IN (?)",@filtered_ratings).order('title')
	else		
		@movies=Movie.all.order('title')
	end
    elsif(session[:sort]=='release_date')
	@release_date_header='hilite'
	if(session[:ratings])
		@movies = Movie.where("rating IN (?)",@filtered_ratings).order('release_date')
 	else		
		@movies=Movie.all.order('release_date')
	end
    else
	if(session[:ratings])
		@movies = Movie.where("rating IN (?)",@filtered_ratings)
	else
    		@movies = Movie.all
	end
    end
    @all_ratings=Movie.all_ratings	
    	
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

end
