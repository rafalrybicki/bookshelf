class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update destroy]
  before_action :redirect_if_not_owner_or_book_does_not_exist, only: %i[show edit update destroy]

  def index
    @books = current_user.books
  end

  def show; end

  def new
    @book = Book.new
  end

  def create
    @book = current_user.books.build(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to book_path(@book), notice: 'Book was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @book.destroy

    redirect_to books_path, notice: 'Book was successfully deleted.'
  end

  private

  def set_book
    @book = current_user.books.find_by_id(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :author, :categories, :status, :info)
  end

  def redirect_if_not_owner_or_book_does_not_exist
    redirect_to root_path, status: :see_other if @book.nil?
  end
end
