# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  subject { create(:product) }

  describe 'validation tests:' do
    describe 'valid subject entry' do
      it 'must be recognized as valid' do
        expect(subject).to be_valid
      end
    end

    context 'for a product to be saved' do
      describe 'name' do
        it 'must be present' do
          subject.name = nil
          expect(subject.save).to be false
        end

        it 'must have the right length' do
          subject.name = '12'
          expect(subject.save).to be false
          subject.name = '123456789+123456789+123456789+123456789+123456789+123456789+123456789+123456789+123456789+123456789+1'
          expect(subject.save).to be false
          subject.name = '123'
          expect(subject.save).to be true
          subject.name = '123456789+123456789+123456789+123456789+123456789+123456789+123456789+123456789+123456789+123456789+'
          expect(subject.save).to be true
        end

        it 'must be unique' do
          subject_copy = subject.dup
          expect(subject.save).to be true
          expect(subject_copy.save).to be false
        end
      end

      describe 'description' do
        it 'must be present' do
          subject.description = nil
          expect(subject.save).to be false
        end

        it 'must not be too short' do
          subject.description = '123456789'
          expect(subject.save).to be false
          subject.description = '123456789+'
          expect(subject.save).to be true
        end
      end
    end
  end
  pending "add some examples to (or delete) #{__FILE__}"
end
