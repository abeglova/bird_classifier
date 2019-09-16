require 'rails_helper'
require 'tempfile'

RSpec.describe Process::GenerateImageDataFiles do
  let(:bird_training_data_file) { Tempfile.new('csv') }
  let(:bird_test_data_file) { Tempfile.new('csv') }

  let(:bird_training_data_fixture) do
    File.join(Rails.root, 'spec/fixtures/data_files/bird_training_data.csv')
  end

  let(:bird_test_data_fixture) do
    File.join(Rails.root, 'spec/fixtures/data_files/bird_test_data.csv')
  end

  let(:bird_image_source) { 'spec/fixtures/image_files/bird_images/**' }

  let(:control_training_data_file) { Tempfile.new('csv') }
  let(:control_test_data_file) { Tempfile.new('csv') }

  let(:control_training_data_fixture) do
    File.join(Rails.root, 'spec/fixtures/data_files/control_training_data.csv')
  end

  let(:control_test_data_fixture) do
    File.join(Rails.root, 'spec/fixtures/data_files/control_test_data.csv')
  end

  let(:control_image_source) { 'spec/fixtures/image_files/control_images/**' }

  after do
    bird_training_data_file.unlink
    bird_test_data_file.unlink
    control_training_data_file.unlink
    control_test_data_file.unlink
  end

  context 'create_or_update_training_data_files' do
    it 'returns files with processed data' do
      Process::GenerateImageDataFiles.create_or_update_training_data_files(
        bird_input_subfolders: Dir.glob(File.join(Rails.root, bird_image_source)),
        bird_test_data_output: bird_test_data_file,
        bird_training_data_output: bird_training_data_file,
        control_input_subfolders: Dir.glob(File.join(Rails.root, control_image_source)),
        control_test_data_output: control_test_data_file,
        control_training_data_output: control_training_data_file
      )

      expect(CSV.open(bird_training_data_file.path).readlines).to eq(
        CSV.open(bird_training_data_fixture).readlines)

      expect(CSV.open(bird_test_data_file.path).readlines).to eq(
        CSV.open(bird_test_data_fixture).readlines)

      expect(CSV.open(control_training_data_file.path).readlines).to eq(
        CSV.open(control_training_data_fixture).readlines)

      expect(CSV.open(control_test_data_file.path).readlines).to eq(
        CSV.open(control_test_data_fixture).readlines)
    end
  end
end
