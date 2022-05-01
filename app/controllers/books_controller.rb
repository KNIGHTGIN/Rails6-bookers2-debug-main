class BooksController < ApplicationController
  before_action :ensure_currect_user, only: [:edit, :update, :destroy]

  def show
    @book = Book.find(params[:id])
    @book_new = Book.new
  end

  def index
    @books = Book.all
    @book = Book.new
  end

  def create
   @newbook = Book.new(book_params)
   @newbook.user_id = current_user.id
   if @newbook.save
    flash[:notice] = "You have created book successfully."
    redirect_to book_path(@newbook)
   else
    @books = Book.all
    @user = current_user
    render 'index'
   end
  end

  def edit
    @book = Book.find(params[:id])
    if @book.user.id!= current_user.id
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "You have updated book successfully."
      redirect_to book_path(@book.id)
    else
      render 'edit'
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path, notice: "successfully delete book!"
  end

  def delete
  flash[:notice] = "Signed out successfully."
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def ensure_correct_user
   @book = Book.find(params:[:id])
   unless @book.user == current_user
     redirect_to book_path
   end
  end
end
