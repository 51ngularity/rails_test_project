# frozen_string_literal: true

require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest

  # testing actions

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

# testing views

  test 'testing index elements' do
    get products_path
    assert_select 'div', 'Produktliste'
    assert_select 'table' do
      assert_select 'thead' do
        assert_select 'tr' do
          assert_select 'th' do |ths|
            # th0 = ths.first
            # byebug
            # assert_select ths[0], 'div', { count: 1, text: 'Aktionen' }
            assert_select ths[0], 'div', 'Aktionen'
            assert_select ths[1], 'div', 'Produktname'
            assert_select ths[2], 'div', 'Beschreibung'
            assert_select ths[-1], 'div', 'Aktionen'
            assert_select ths[-2], 'div', 'Produktname'
          end
        end
      end

      assert_select 'tfoot' do
        assert_select 'tr' do
          assert_select 'th' do |ths|
            assert_select ths[0], 'div', 'Aktionen'
            assert_select ths[1], 'div', 'Produktname'
            assert_select ths[2], 'div', 'Beschreibung'
            assert_select ths[-1], 'div', 'Aktionen'
            assert_select ths[-2], 'div', 'Produktname'
          end
        end
      end

      assert_select 'tbody' do
        assert_select 'tr' do |trs|
          assert_select trs[0], 'td' do |tds|
            assert_select tds[0], 'div', 'NEU'
            assert_select tds[2], 'div', 'Neuen Eintrag hinzufügen'
            assert_select tds[-1], 'div', 'NEU'
          end

          if Product.all.blank?
            assert_equal trs.count, 2
            assert_select trs[1], 'td' do |tds|
              assert_select tds[2], 'div', 'Leider noch keine Einträge vorhanden'
            end
          else
            assert_equal trs.count, Product.all.count + 1

            (0...Product.all.count).each do |i|
              products = Product.all
              assert_select trs[i + 1], 'td' do |tds|
                assert_select tds[0], 'div a', 'Bearbeiten'
                assert_select tds[0], 'div a', 'Löschen'
                assert_select tds[-1], 'div a', 'Bearbeiten'
                assert_select tds[-1], 'div a', 'Löschen'
                assert_select tds[1], 'a', products[i].name
                assert_select tds[-2], 'a', products[i].name
                assert_select tds[2], 'div', products[i].description
              end
            end
          end
        end
      end
    end
  end

  test 'testing new elements' do
    get new_product_path
    assert_select 'div', 'Neuen Produkt-Eintrag generieren'

    assert_select 'form' do
      assert_select 'label', 'Name'
      assert_select 'label', 'Beschreibung'
      assert_select 'input', type: 'text', count: 2
      assert_select 'textarea', 1
      assert_select 'input', { type: 'submit', value: 'speichern' }
    end

    assert_select 'a', 'zurück zur Produktliste'
  end

  test 'testing edit elements' do
    p = Product.last
    get edit_product_path(p.id)
    assert_select 'div', 'Produkt-Eintrag bearbeiten'

    assert_select 'form' do
      assert_select 'label', 'Name'
      assert_select 'label', 'Beschreibung'
      assert_select 'input', type: 'text', count: 3, value: p.name
      assert_select 'textarea', count: 1, value: p.description
      assert_select 'input', { type: 'submit', value: 'speichern' }
    end

    assert_select 'a', 'zurück zur Produktliste'
  end

  test 'testing show elements' do
    p = Product.last
    get product_path(p.id)
    assert_select 'div', 'Produktbeschreibung'
    assert_select 'div', 'Name:'
    assert_select 'div', 'Beschreibung:'
    assert_select 'div', p.name
    assert_select 'div', p.description
    assert_select 'a', 'zurück zur Produktliste'
  end
end
