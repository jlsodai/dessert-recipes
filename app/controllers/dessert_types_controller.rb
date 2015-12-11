class DessertTypesController < ApplicationController
  def index
    @dessert_types = DessertType.all
    @recipes = Recipe.all
  end

  def show
    @dessert_type = DessertType.find(params[:id])
    @recipes = Recipe.where(dessert_type_id: @dessert_type.id)
  end

  def new
    @dessert_types = DessertType.all
    @dessert_type = DessertType.new
  end

  def edit
    @dessert_type = Recipe.find(params[:id])
  end

  def create
    @dessert_type = DessertType.new(dessert_type_params)

    respond_to do |format|
      if @dessert_type.save
        format.html { redirect_to @dessert_type, notice: 'DessertType was successfully created.' }
        format.json { render :show, status: :created, location: @dessert_type }
      else
        format.html { render :new }
        format.json { render json: @dessert_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @dessert_type.update(dessert_type_params)
        format.html { redirect_to @dessert_type, notice: 'DessertType was successfully updated.' }
        format.json { render :show, status: :ok, location: @dessert_type }
      else
        format.html { render :edit }
        format.json { render json: @dessert_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @dessert_type = DessertType.find(params[:id])
    @dessert_type.destroy
    respond_to do |format|
      format.html { redirect_to dessert_types_url, notice: 'DessertType was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_dessert_type
      @dessert_type = DessertType.find(params[:id])
    end

    def dessert_type_params
      params.require(:dessert_type).permit(:name, :image)
    end
end