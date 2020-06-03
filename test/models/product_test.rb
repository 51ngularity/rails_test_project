# frozen_string_literal: true

require 'test_helper'

class ProductTest < ActionDispatch::IntegrationTest
  test 'should save valid article' do
    product = products(:valid_product)
    assert product.save
  end

  test 'should reject saving if name empty' do
    product = products(:valid_product)
    product.name = nil
    assert_not product.save
  end

  test 'should reject saving if name has wrong length' do
    product = products(:valid_product)
    product.name = 'ab'
    assert_not product.save
  end
end
