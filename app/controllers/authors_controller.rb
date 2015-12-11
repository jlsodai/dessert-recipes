class AuthorsController < ApplicationController
  before_action :logged_in_author, only: [:edit, :update]
  before_action :correct_author,   only: [:edit, :update]
  
  def index
    @authors = Author.all
    @recipes = Recipe.all
  end

  def show
      @author = Author.find(params[:id])
      @recipes = Recipe.where(author_id: @author.id)
  end

  def new
    @author = Author.new
  end

  def edit
    @author = Author.find(params[:id])
  end

  def create
    @author = Author.new(author_params)
    respond_to do |format|
      if @author.save
        log_in @author
        format.html { redirect_to @author, notice: 'Author was successfully created.' }
        format.json { render :show, status: :created, location: @author }
      else
        format.html { render :new }
        format.json { render json: @author.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @author = Author.find(params[:id])
    respond_to do |format|
      if @author.update(author_params)
        format.html { redirect_to @author, notice: 'Profile updated.' }
        format.json { render :show, status: :ok, location: @author }
      else
        format.html { render :edit }
        format.json { render json: @author.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @author = Author.find(params[:id])
    @author.destroy
    respond_to do |format|
      format.html { redirect_to authors_url, notice: 'author was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_author
      @author = Author.find(params[:id])
    end

    def author_params
      params.require(:author).permit(:name, :bio, :username, :email, :password, :image)
    end
    # Confirms a logged-in user.
    def logged_in_author
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    # Confirms the correct user.
    def correct_author
      @author = Author.find(params[:id])
      redirect_to(root_url) unless current_author?(@author)
    end
    def admin_author
      redirect_to(root_url) unless current_author.admin?
    end
end