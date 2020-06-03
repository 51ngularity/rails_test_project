# frozen_string_literal: true

require 'test_helper'

# class documentation comment placeholder
class ProductsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get products_url
    assert_response :success
  end

  test 'should get show' do
    product = Product.new(id: 1, name: 'valid_name', description: 'valid_description')
    assert product.save
    product.save
    get '/products/1'
    assert_response :success
  end
end
