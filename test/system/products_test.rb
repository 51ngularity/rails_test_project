# frozen_string_literal: true

require 'application_system_test_case'

class ProductsTest < ApplicationSystemTestCase
  test 'visiting index' do
    visit products_url
    assert_selector 'div', text: 'Produktliste'
    assert_selector 'table'
    assert_selector 'div', text: 'Neuen Eintrag hinzufügen'
    # assert_equal Product.count, 0
    # assert_selector 'div', text: 'Leider noch keine Einträge vorhanden'
    # can't test, fixtures occupy table
    assert_selector 'div', text: 'NEU'
    assert_selector 'div', text: 'Bearbeiten'
    assert_selector 'div', text: 'Löschen'
  end

  test 'visiting show from index' do
    visit products_url
    p = products(:valid_product)
    click_link p.name, match: :first
    assert_selector 'div', text: 'Produktbeschreibung'
    assert_selector 'div', text: 'Name'
    assert_selector 'div', text: 'Beschreibung'
    assert_selector 'div', text: p.name
    assert_selector 'div', text: p.description
    assert_selector 'div', text: 'zurück zur Produktliste'
    click_on 'zurück zur Produktliste'
    assert_selector 'div', text: 'Produktliste'
  end

  test 'visiting new from index' do
    visit products_path
    assert_no_selector 'div', text: 'new_name'
    assert_no_selector 'div', text: 'new_description'
    click_on 'NEU', match: :first
    assert_selector 'div', text: 'Neuen Produkt-Eintrag generieren'
    assert_selector 'div', text: 'Name'
    assert_selector 'div', text: 'Beschreibung'
    fill_in 'product_name', with: 'new_name'
    fill_in 'product_description', with: 'new_description'
    click_on 'speichern'
    click_on 'zurück zur Produktliste'
    assert_selector 'div', text: 'Produktliste'
    assert_selector 'div', text: 'new_name'
    assert_selector 'div', text: 'new_description'
  end

  test 'visiting edit from index' do
    # Product.create(name: 'name for editing', description: 'description for editing')
    p = Product.last
    visit products_path
    assert_no_selector 'div', text: 'edited_name'
    assert_no_selector 'div', text: 'edited_description'
    click_link 'Bearbeiten', href: edit_product_path(p.id), match: :first
    assert_selector 'div', text: 'Produkt-Eintrag bearbeiten'
    assert_selector 'div', text: 'Name'
    assert_selector 'div', text: 'Beschreibung'
    assert_selector 'input' do |i|
      assert_equal i.value, p.name
    end
    assert_selector 'textarea', text: p.description
    fill_in 'product_name', with: 'edited_name'
    fill_in 'product_description', with: 'edited_description'
    click_on 'speichern'
    click_on 'zurück zur Produktliste'
    assert_selector 'div', text: 'Produktliste'
    assert_selector 'div', text: 'edited_name'
    assert_selector 'div', text: 'edited_description'
  end
end
