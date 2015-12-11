class RecipesController < ApplicationController
  # before_action :logged_in_author, only: [:index, :edit, :update]
  # before_action :correct_author,   only: [:edit, :update]
  
  def home
  end
  def index
    @recipes = Recipe.all
    @dessert_types = DessertType.all
  end

  def show
      #@current_author = current_author
      @recipe = Recipe.find(params[:id])
      @comments = Comment.where(recipe_id: @recipe.id)
      @comment = Comment.new
      @author = Author.find(@recipe.author_id)
  end

  def new
    if logged_in?
      @recipe = Recipe.new
    else
      flash[:danger] = "Kindly login or create an account to add a Recipe."
      redirect_to login_url
    end
  end

  def edit
    if logged_in?
      @recipe = Recipe.find(params[:id])
      unless current_author.admin? || @recipe.author_id == current_author.id
        flash[:danger] = "You aren't allowed to edit someone else\'s Recipe."
        redirect_to @recipe
      end
    else
      flash[:danger] = "Only logged in users are allowed to edit a recipe."
      redirect_to login_url
    end
  end

  def create   
    @author = Author.find(current_author.id)
    @recipe = @author.recipes.create(recipe_params)

    respond_to do |format|
      if @recipe.save
        format.html { redirect_to @author, notice: 'recipe was successfully created.' }
        format.json { render :show, status: :created, location: @author }
      else
        format.html { render :new }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @recipe = Recipe.find(params[:id])
    respond_to do |format|
      if @recipe.update(recipe_params)
        format.html { redirect_to @recipe, notice: 'recipe was successfully updated.' }
        format.json { render :show, status: :ok, location: @recipe }
      else
        format.html { render :edit }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy
    
    respond_to do |format|
      format.html { redirect_to recipes_url, notice: 'recipe was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

    def recipe_params
      params.require(:recipe).permit(:name, :description, :ingredients, :directions, :image, :author_id, :dessert_type_id)
    end
end
