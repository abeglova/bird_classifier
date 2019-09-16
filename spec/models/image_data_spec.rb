require 'rails_helper'

RSpec.describe ImageData do
  let(:image_path) { 'spec/fixtures/test_image.jpg' }
  let(:expected_result) do
    CSV.read('spec/fixtures/hu_moments_from_test_image.csv').flatten.map(&:strip).
      map(&:to_f)
  end

  context 'extract' do
    it 'returns an array of hu moments from the image' do
      expect(described_class.extract(image_path)).to eq(expected_result)
    end
  end
end
