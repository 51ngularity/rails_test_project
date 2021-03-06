# frozen_string_literal: true

require 'application_system_test_case'

class ProductsTest < ApplicationSystemTestCase
  test 'testing page.all behavior' do
    5.times do
      create(:random_product)
    end
    visit products_path

    edit_buttons = []
    page.all('a', text: 'Bearbeiten') do |butt| # runs once for each found element if byebug is inside the do-block
      assert_equal Capybara::Node::Element, butt.class # each time returns the next found element
      edit_buttons.append(butt)
      # byebug
    end

    loops = 0
    page.all('a') do |links| # runs only once
      assert_equal Capybara::Node::Element, links.class # returns only the first element
      loops += 1
    end
    # byebug

    links = page.all('a')
    assert_equal Capybara::Result, links.class # returns all found elements as an array
    assert_equal Capybara::Node::Element, links.first.class
    # byebug
  end

  test 'testing assert_selector behavior' do
    5.times do
      create(:random_product)
    end
    visit products_path

    assert_selector 'a', text: 'Bearbeiten', count: (2 * Product.all.size) do |inputs|
      # byebug
      assert_equal Capybara::Node::Element, inputs.class # returns only one element
    end
  end
end
