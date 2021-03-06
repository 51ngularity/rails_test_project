# frozen_string_literal: true

require 'application_system_test_case'

class ProductsTest < ApplicationSystemTestCase
  test 'visiting index' do
    Product.destroy_all
    assert_nil Product.first
    visit products_path
    assert_selector 'div', text: 'Produktliste'
    assert_selector 'table', count: 1
    assert_selector 'div', text: 'Neuen Eintrag hinzufügen'
    assert_selector 'div', text: 'Leider noch keine Einträge vorhanden'

    5.times do
      create(:random_product)
    end
    visit products_path
    assert_selector 'div', text: 'Produktliste'
    click_on %w[new_left new_right].sample
    assert_selector 'div', text: 'Neuen Produkt-Eintrag generieren'
    click_on 'zurück zur Produktliste', count: 1
    find_all('a', text: 'Bearbeiten').sample.click
    assert_selector 'div', text: 'Produkt-Eintrag bearbeiten'
    click_on 'zurück zur Produktliste', count: 1
    assert_difference 'Product.count', -1 do
      find_all('a', text: 'Löschen').sample.click
    end
  end

  test 'visiting show from index' do
    visit products_url
    p = Product.all.sample
    click_link p.name, id: %w[product_name_left product_name_right].sample
    assert_selector 'div', text: 'Produktbeschreibung'
    assert_selector 'div', text: 'Name'
    assert_selector 'div', text: 'Beschreibung'
    assert_selector 'div', text: p.name
    assert_selector 'div', text: p.description
    assert_selector 'div', text: 'zurück zur Produktliste'
    click_on 'zurück zur Produktliste', count: 1
    assert_selector 'div', text: 'Produktliste'
  end

  test 'visiting new from index' do
    visit products_path
    assert_no_selector 'div', text: 'new_name', count: 1
    assert_no_selector 'div', text: 'new_description', count: 1
    click_on  %w[new_left new_right].sample
    assert_selector 'div', text: 'Neuen Produkt-Eintrag generieren'
    assert_selector 'div', text: 'Name'
    assert_selector 'div', text: 'Beschreibung'
    fill_in 'product_name', with: 'new_name'
    fill_in 'product_description', with: 'new_description'
    click_on 'speichern', count: 1
    click_on 'zurück zur Produktliste', count: 1
    assert_selector 'div', text: 'Produktliste'
    assert_selector 'div', text: 'new_name'
    assert_selector 'div', text: 'new_description'
  end

  test 'visiting edit from index' do
    5.times do
      create(:random_product)
    end
    p = Product.all[rand(Product.count)]
    visit products_path
    assert_no_selector 'div', text: 'edited_name'
    assert_no_selector 'div', text: 'edited_description'
    click_link 'Bearbeiten', id: "edit_left_#{p.id}"
    assert_selector 'div', text: 'Produkt-Eintrag bearbeiten'
    assert_selector 'div', text: 'Name'
    assert_selector 'div', text: 'Beschreibung'
    assert_selector 'input', id: 'product_name', count: 1 do |name_input|
      assert_equal p.name, name_input[:value]
    end
    assert_selector 'textarea', text: p.description
    fill_in 'product_name', with: 'edited_name'
    fill_in 'product_description', with: 'edited_description'
    click_on 'speichern', count: 1
    assert_selector 'div', text: 'Produktbeschreibung'
    click_on 'zurück zur Produktliste', count: 1
    assert_selector 'div', text: 'Produktliste'
    assert_selector 'div', text: 'edited_name'
    assert_selector 'div', text: 'edited_description'
  end
end
