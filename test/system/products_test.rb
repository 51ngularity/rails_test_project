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
    assert_selector 'div', text: 'NEU'
    assert_selector 'div', text: 'Bearbeiten'
    assert_selector 'div', text: 'Löschen'
  end

  test 'visiting show' do
    p = Product.last
    visit product_path(p.id)
    assert_selector 'div', text: 'Produktbeschreibung'
    assert_selector 'div', text: 'Name'
    assert_selector 'div', text: 'Beschreibung'
    assert_selector 'div', text: p.name
    assert_selector 'div', text: p.description
    assert_selector 'div', text: 'zurück zur Produktliste'
  end

  test 'visiting new' do
    visit new_product_path
    assert_selector 'div', text: 'Neuen Produkt-Eintrag generieren'
    assert_selector 'div', text: 'Name'
    assert_selector 'div', text: 'Beschreibung'
    assert_selector 'input', text: 'speichern'
    assert_selector 'div', text: 'zurück zur Produktliste'
  end

  test 'visiting edit' do
    p = products(:valid_product)
    p.save
    visit edit_product_path(p.id)
    assert_selector 'div', text: 'Produkt-Eintrag bearbeiten'
    assert_selector 'div', text: 'Name'
    assert_selector 'div', text: 'Beschreibung'
    assert_selector 'input', text: 'speichern'
    assert_selector 'div', text: p.name
    assert_selector 'div', text: p.description
    assert_selector 'div', text: 'zurück zur Produktliste'
  end
end
