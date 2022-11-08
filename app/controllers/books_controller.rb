class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update destroy]
  before_action :redirect_if_not_owner_or_book_does_not_exist, only: %i[show edit update destroy]
  before_action :reject_hidden_category, only: %i[create update]

  def index
    @categories = {}
    current_user.categories.each { |cateogry| @categories[cateogry.id] = cateogry }

    @books = books
    @pagy, @books = pagy(@books, items: 30)
  end

  def show
    @categories = current_user.categories.where(id: @book.categories)
  end

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
    params.require(:book).permit(:title, :author, :status, :info, categories: [])
  end

  def redirect_if_not_owner_or_book_does_not_exist
    redirect_to root_path, status: :see_other if @book.nil?
  end

  def reject_hidden_category
    params[:book][:categories].reject!(&:blank?) if params[:book][:categories]
  end

  def books
    books = current_user.books
    title = params[:title]
    author = params[:author]
    status = params[:status]
    categories = params[:categories]&.reject!(&:blank?)

    if title && title != ''
      title = Book.sanitize_sql_like(params[:title])
      books = books.where("LOWER(title) LIKE LOWER('%#{title}%')")
    end

    if author && author != ''
      author = Book.sanitize_sql_like(params[:author])
      books = books.where("LOWER(author) LIKE LOWER('%#{author}%')")
    end

    books = books.where('status = ?', status) if status && status != ''

    categories&.each do |category|
      books = books.where('? = ANY(categories)', category)
    end

    books
  end
end
