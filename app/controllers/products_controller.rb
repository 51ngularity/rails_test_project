# frozen_string_literal: true

# Top level omment describing class function
class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def new 
  end

  def create
    @product = Product.new(params.require(:product).permit(:name, :description))
    @product.save
    redirect_to product_path(@product.id)
  end

end
