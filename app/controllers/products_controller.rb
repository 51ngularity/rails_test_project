# frozen_string_literal: true

class ProductsController < ApplicationController
  def redirect_to_index
    redirect_to products_path
  end

  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def new 
    @product = Product.new
  end

  def create
    @product = Product.new(params.require(:product).permit(:name, :description))
    if @product.save
      flash[:notice] = 'Product-entry was saved successfully'
    redirect_to product_path(@product.id)
    else
      flash[:alert] = 'Product-entry could not be saved due to errors'
      render 'new'
  end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(params.require(:product).permit(:name, :description))
      flash[:notice] = 'Product-entry was updated successfully'
    redirect_to product_path(@product.id)
    else
      flash[:alert] = 'Product-entry could not be updated due to errors'
      render 'edit'
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to products_path
  end
end
