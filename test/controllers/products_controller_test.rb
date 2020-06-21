# frozen_string_literal: true

require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test 'should get root and redirect to index' do
    get root_path
    assert_redirected_to products_path
  end

  test 'should get index' do
    get products_path
    assert_response :success
  end

  test 'should get new' do
    get new_product_path
    assert_response :success
  end

  test 'should create new product' do
    p = products(:valid_product)
    assert_difference('Product.count', +1) do
      post products_path, params: { product: { name: p.name, description: p.description } }
    end
    assert_redirected_to product_path(Product.last.id)
  end

  test 'should get show' do
    get product_url(Product.last.id)
    assert_response :success
  end

  test 'should get edit' do
    get edit_product_path(Product.last.id)
    assert_response :success
  end

  test 'should update product via patch' do
    p = Product.last
    patch product_path(p.id), params: { product: { name: 'new name' } }
    assert_redirected_to product_path(p.id)
    p.reload
    assert_equal 'new name', p.name
  end

  test 'should update product via put' do
    p = Product.last
    put product_path(p.id), params: { product: { name: 'new name 2', description: 'new description 2' } }
    assert_redirected_to product_path(p.id)
    p.reload
    assert_equal 'new name 2', p.name
    assert_equal 'new description 2', p.description
  end

  test 'should destroy product' do
    p = Product.last
    assert_difference('Product.count', -1) do
      delete product_path(p.id)
    end
    assert_redirected_to products_path
  end
end
