require 'rails_helper'

RSpec.describe GenerateImageDataJob do
  context 'perform' do
    it 'calls Process::GenerateImageDataFiles.create_or_update_training_data_files' do
      expect(Process::GenerateImageDataFiles).to receive(:create_or_update_training_data_files).
        with(bird_training_data_output: ApplicationJob::BIRD_TRAINING_DATA_FILE,
          bird_test_data_output: ApplicationJob::BIRD_TEST_DATA_FILE,
          bird_input_subfolders: GenerateImageDataJob::BIRD_IMAGE_SOURCE,
          control_training_data_output: ApplicationJob::CONTROL_TRAINING_DATA_FILE,
          control_test_data_output: ApplicationJob::CONTROL_TEST_DATA_FILE,
          control_input_subfolders: GenerateImageDataJob::CONTROL_IMAGE_SOURCE)
      GenerateImageDataJob.perform_now
    end
  end
end
