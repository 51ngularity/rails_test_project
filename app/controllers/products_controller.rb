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

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    @product.update(params.require(:product).permit(:name, :description))
    redirect_to product_path(@product.id)
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to products_path
  end
end
