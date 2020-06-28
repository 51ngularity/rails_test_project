# frozen_string_literal: true

require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test 'testing assert_select behavior' do
    assert_select 'input', { text: 'speichern', type: 'submit', count: 3 } do |inputs| # no error message on wrong attributes used
      assert_equal 3, inputs.size
      # byebug
    end
  end
end
