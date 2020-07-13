# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Products', type: :system do
  before do
    driven_by(:rack_test)
  end

  describe 'product "index" page' do
    before(:example) do
      visit products_path
      assert_text 'Produktliste'
    end

    describe 'table' do
      describe 'in its 1st row' do
        it 'must have two "new" buttons, linking to "new" page"' do
          within('tbody') do
            within(find_all('tr')[0]) do
              click_on 'new_left'
            end
          end
          assert_text 'Neuen Produkt-Eintrag generieren'

          visit products_path
          within('tbody') do
            within(find_all('tr')[0]) do
              click_on 'new_right'
            end
          end
          assert_text 'Neuen Produkt-Eintrag generieren'
        end

        it 'must display text: "Neuen Eintrag hinzufügen"' do
          within('tbody') do
            within(find_all('tr')[0]) do
              assert_text 'Neuen Eintrag hinzufügen'
            end
          end
        end
      end

      context 'with no product db entries' do
        before(:context) do
          Product.destroy_all
          assert_equal 0, Product.count
        end

        it 'in its 2nd row must display a text "no entries yet"' do
          within('tbody') do
            within(find_all('tr', count: 2)[1]) do
              assert_text 'Leider noch keine Einträge vorhanden'
            end
          end
        end
      end

      context 'with existing db product entries' do
        before(:context) do
          5.times do
            create(:random_product)
          end
        end

        after(:context) do
          Product.destroy_all
        end

        describe 'must have one row in the table for each table entry displaying' do
          it 'the product name twice, as a link to the "show" page' do
            Product.all.each do |p|
              within('tbody') do
                within("tr#row_#{p.id}") do
                  click_on 'product_name_left', text: p.name
                end
              end
              assert_text 'Produktbeschreibung'

              visit products_path
              within('tbody') do
                within("tr#row_#{p.id}") do
                  click_on 'product_name_right', text: p.name
                end
              end
              assert_text 'Produktbeschreibung'
              visit products_path
            end
          end

          it 'the product description' do
            Product.all.each do |p|
              within('tbody') do
                within("tr#row_#{p.id}") do
                  assert_text p.description
                end
              end
            end
          end

          it 'two edit-buttons, linking to the "edit" page' do
            Product.all.each do |p|
              within('tbody') do
                within("tr#row_#{p.id}") do
                  click_on "edit_left_#{p.id}", text: 'Bearbeiten'
                end
              end
              assert_text 'Produkt-Eintrag bearbeiten'

              visit products_path
              within('tbody') do
                within("tr#row_#{p.id}") do
                  click_on "edit_right_#{p.id}", text: 'Bearbeiten'
                end
              end
              assert_text 'Produkt-Eintrag bearbeiten'
              visit products_path
            end
          end
        end

        describe 'must have one row in the table for each table entry displaying' do
          it 'two delete-buttons, able to delete the product entry from the table and the db' do
            within('tbody') do
              p = Product.all.sample
              within("tr#row_#{p.id}") do
                click_on "delete_left_#{p.id}", text: 'Löschen'
              end
              assert_no_selector "tr#row_#{p.id}"
              expect(Product.where(id: p.id)).not_to exist

              p = Product.all.sample
              within("tr#row_#{p.id}") do
                click_on "delete_right_#{p.id}", text: 'Löschen'
              end
              assert_no_selector "tr#row_#{p.id}"
              expect(Product.where(id: p.id)).not_to exist
            end
          end
        end
      end
    end
  end

  describe 'product' do
    before(:context) do
      @p = create(:random_product)
    end

    after(:context) do
      Product.destroy_all
    end

    describe '"show" page' do
      before(:example) do
        visit product_path(@p.id)
        assert_text 'Produktbeschreibung'
      end

      it 'must display the name and discription of a product' do
        assert_text @p.name
        assert_text @p.description
      end

      it 'must have a "back to index" button, linking to the index page' do
        click_on 'back_to_index'
        assert_text 'Produktliste'
      end
    end

    describe '"edit" page' do
      before(:example) do
        visit edit_product_path(@p.id)
        assert_text 'Produkt-Eintrag bearbeiten'
      end

      it 'must display the name and discription of the edited product inside the respective input fields' do
        assert_equal @p.name, find('input#product_name')[:value]
        assert_equal @p.description, find('textarea#product_description')[:value]
      end

      it 'must have a "back to index" button, linking to the index page' do
        click_on 'back_to_index'
        assert_text 'Produktliste'
      end
    end

    describe '"new" page' do
      before(:example) do
        visit new_product_path
        assert_text 'Neuen Produkt-Eintrag generieren'
      end

      it 'must display two empty input fields for the name and discription of the new product' do
        assert_equal nil, find('input#product_name')[:value]
        assert_equal '', find('textarea#product_description')[:value]
      end

      it 'must have a "back to index" button, linking to the index page' do
        click_on 'back_to_index'
        assert_text 'Produktliste'
      end

      context 'form, if provided a' do
        it 'name which is empty, it must not create the new product entry' do
          fill_in 'product_name', with: ''
          fill_in 'product_description', with: 'valid description'
          expect { click_on 'product_submit' }.not_to (change { Product.count })
          assert_text 'Neuen Produkt-Eintrag generieren'
        end

        it 'name which is too short, it must not create the new product entry' do
          fill_in 'product_name', with: '12'
          fill_in 'product_description', with: 'valid description'
          expect { click_on 'product_submit' }.not_to (change { Product.count })
          assert_text 'Neuen Produkt-Eintrag generieren'
        end

        it 'descroption which is empty, it must not create the new product entry' do
          fill_in 'product_name', with: 'valid name'
          fill_in 'product_description', with: ''
          expect { click_on 'product_submit' }.not_to (change { Product.count })
          assert_text 'Neuen Produkt-Eintrag generieren'
        end

        it 'descroption which is too short, it must not create the new product entry' do
          fill_in 'product_name', with: 'valid name'
          fill_in 'product_description', with: '123456789'
          expect { click_on 'product_submit' }.not_to (change { Product.count })
          assert_text 'Neuen Produkt-Eintrag generieren'
        end

        it 'name and a description which are vaild, it must create the new product entry and redirect to the respective "show" page' do
          fill_in 'product_name', with: 'valid name'
          fill_in 'product_description', with: 'valid description'
          expect { click_on 'product_submit' }.to (change { Product.count }).by(+1)
          assert_text 'Produktbeschreibung'
          assert_text 'valid name'
          assert_text 'valid description'
        end
      end
    end
  end
  pending "add some scenarios (or delete) #{__FILE__}"
end
