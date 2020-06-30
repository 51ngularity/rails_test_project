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
    id_old = p.id
    patch product_path(p.id), params: { product: { name: 'new name 1', description: 'new description 1' } }
    assert_redirected_to product_path(p.id)
    p.reload
    assert_equal p.id, id_old
    assert_equal 'new name 1', p.name
    assert_equal 'new description 1', p.description
  end

  test 'should update product via put' do
    p = Product.last
    id_old = p.id
    put product_path(p.id), params: { product: { name: 'new name 2', description: 'new description 2' } }
    assert_redirected_to product_path(p.id)
    p.reload
    assert_equal p.id, id_old
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
    (1..rand(1..5)).each do |x|
      Product.create(name: "product name #{x}", description: "product description #{x}")
    end
    get products_path
    assert_select 'div', 'Produktliste'
    assert_select 'table' do
      assert_select 'thead' do
        assert_select 'tr' do
          assert_select 'th' do |ths|
            # th0 = ths.first
            # byebug
            # assert_select ths[0], 'div', { count: 1, text: 'Aktionen' }
            assert_select ths[0], 'div', 'Aktionen', %q[in line 79 "assert_select ths[0], 'div', 'Aktionen'" failed]
            assert_select ths[1], 'div', 'Produktname', %q[in line 80 "assert_select ths[1], 'div', 'Produktname'" failed]
            assert_select ths[2], 'div', 'Beschreibung', %q[in line 81 "assert_select ths[2], 'div', 'Beschreibung'" failed]
            assert_select ths[-1], 'div', 'Aktionen', %q[in line 82 "assert_select ths[-1], 'div', 'Aktionen'" failed]
            assert_select ths[-2], 'div', 'Produktname', %q[in line 83 "assert_select ths[-2], 'div', 'Produktname'" failed]
          end
        end
      end

      assert_select 'tfoot' do
        assert_select 'tr' do
          assert_select 'th' do |ths|
            assert_select ths[0], 'div', 'Aktionen', 'in line 91 > assert_select ths[0], div, Aktionen < failed'
            assert_select ths[1], 'div', 'Produktname', 'in line 92 > assert_select ths[1], div, Produktname < failed'
            assert_select ths[2], 'div', 'Beschreibung', 'in line 93 > assert_select ths[2], div, Beschreibung < failed'
            assert_select ths[-1], 'div', 'Aktionen', 'in line 94 > assert_select ths[-1], div, Aktionen < failed'
            assert_select ths[-2], 'div', 'Produktname', 'in line 95 > assert_select ths[-2], div, Produktname < failed'
          end
        end
      end

      assert_select 'tbody' do
        assert_select 'tr' do |trs|
          assert_select trs[0], 'td' do |tds|
            assert_select tds[0], 'div', 'NEU', %q[in line 103 "assert_select tds[0], 'div', 'NEU'" failed]
            assert_select tds[2], 'div', 'Neuen Eintrag hinzufügen', %q[in line 104 "assert_select tds[2], 'div', 'Neuen Eintrag hinzufügen'" failed]
            assert_select tds[-1], 'div', 'NEU', %q[in line 105 "assert_select tds[-1], 'div'" failed]
          end

          assert_equal trs.count, Product.all.count + 1, %q[in line 114 "assert_equal trs.count, Product.all.count + 1" failed]

          (0...Product.all.count).each do |i|
            products = Product.all
            assert_select trs[i + 1], 'td' do |tds|
              assert_select tds[0], 'div a', 'Bearbeiten', %q[in line 119 "assert_select tds[0], 'div a', 'Bearbeiten'" failed]
              assert_select tds[0], 'div a', 'Löschen', %q[in line 120 "assert_select tds[0], 'div a', 'Löschen'" failed]
              assert_select tds[-1], 'div a', 'Bearbeiten', %q[in line 121 "assert_select tds[-1], 'div a', 'Bearbeiten'" failed]
              assert_select tds[-1], 'div a', 'Löschen', %q[in line 122 "assert_select tds[-1], 'div a', 'Löschen'" failed]
              assert_select tds[1], 'a', products[i].name, %q[in line 123 "assert_select tds[1], 'a', products[i].name" failed]
              assert_select tds[-2], 'a', products[i].name, %q[in line 124 "assert_select tds[-2], 'a', products[i].name" failed]
              assert_select tds[2], 'div', products[i].description, %q[in line 125 "assert_select tds[2], 'div', products[i].description" failed]
            end
          end
        end
      end
    end
  end

  test 'testing empty table in index' do
    Product.destroy_all
    assert Product.all.blank?
    get products_path
    assert_select 'div', 'Produktliste'
    assert_select 'table' do
      assert_select 'tbody' do
        assert_select 'tr' do |trs|
          assert_equal trs.size, 2
          assert_select trs[0], 'td' do |tds|
            assert_select tds[0], 'div', 'NEU', %q[in line 103 "assert_select tds[0], 'div', 'NEU'" failed]
            assert_select tds[2], 'div', 'Neuen Eintrag hinzufügen', %q[in line 104 "assert_select tds[2], 'div', 'Neuen Eintrag hinzufügen'" failed]
            assert_select tds[-1], 'div', 'NEU', %q[in line 105 "assert_select tds[-1], 'div'" failed]
          end
          assert_select trs[1], 'td' do |tds|
            assert_select tds[2], 'div', 'Leider noch keine Einträge vorhanden', %q[in line 111 "assert_select tds[2], 'div', 'Leider noch keine Einträge vorhanden'" failed]
          end
        end
      end
    end
  end

  test 'testing new elements' do
    get new_product_path
    assert_select 'div', 'Neuen Produkt-Eintrag generieren'

    assert_select 'form' do
      assert_select 'label', 'Name', count: 1
      assert_select 'label', 'Beschreibung', count: 1
      assert_select 'input#product_name', count: 1 do |input|
        assert_nil input.first.attr('value')
      end
      assert_select 'textarea', count: 1, value: nil
      assert_select 'input#product_submit', count: 1 do |input|
        assert_equal 'speichern', input.first.attr('value')
      end
    end

    assert_select 'a', 'zurück zur Produktliste'
  end

  test 'testing edit elements' do
    p = Product.last
    get edit_product_path(p.id)
    assert_select 'div', 'Produkt-Eintrag bearbeiten'

    assert_select 'form', count: 1 do
      assert_select 'label', 'Name', count: 1
      assert_select 'label', 'Beschreibung', count: 1
      assert_select 'input#product_name', count: 1 do |input|
        assert_equal p.name, input.first.attr('value')
      end
      assert_select 'textarea', count: 1, value: p.description
      assert_select 'input#product_submit', count: 1 do |input|
        assert_equal 'speichern', input.first.attr('value')
      end
    end

    assert_select 'a', 'zurück zur Produktliste', count: 1
  end

  test 'testing show elements' do
    p = Product.last
    get product_path(p.id)
    assert_select 'div', 'Produktbeschreibung', count: 1
    assert_select 'div', 'Name:', count: 1
    assert_select 'div', 'Beschreibung:', count: 1
    assert_select 'div', p.name, count: 1
    assert_select 'div', p.description, count: 1
    assert_select 'a', 'zurück zur Produktliste', count: 1
  end
end
