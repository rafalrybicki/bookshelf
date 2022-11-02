class CategoriesController < ApplicationController
  before_action :set_category, only: %i[show edit update destroy]
  before_action :redirect_if_not_owner_or_category_does_not_exist, only: %i[show edit update destroy]

  def index
    @categories = Category.with_books(current_user)
  end

  def show
    @books = current_user.books.where('? = ANY(books.categories)', @category.id)
    @categories = {}
    current_user.categories.each { |category| @categories[category.id] = category }
  end

  def new
    @category = Category.new
  end

  def create
    @category = current_user.categories.build(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: 'Category was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to category_path(@category), notice: 'Category was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @category.destroy

    redirect_to categories_path, notice: 'Category was successfully deleted.'
  end

  private

  def set_category
    @category = current_user.categories.find_by_id(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end

  def redirect_if_not_owner_or_category_does_not_exist
    redirect_to root_path, status: :see_other if @category.nil?
  end
end
