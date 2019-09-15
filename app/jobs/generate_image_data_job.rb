class GenerateImageDataJob < ApplicationJob
  queue_as :default

  BIRD_IMAGE_SOURCE = Dir.glob(File.join(Rails.root, 'lib/assets/bird_images/**'))
  CONTROL_IMAGE_SOURCE = Dir.glob(File.join(Rails.root, 'lib/assets/control_images/**'))

  def perform
    Process::GenerateImageDataFiles.create_or_update_training_data_files(
      bird_training_data_output: BIRD_TRAINING_DATA_FILE,
      bird_test_data_output: BIRD_TEST_DATA_FILE,
      bird_input_subfolders: BIRD_IMAGE_SOURCE,
      control_training_data_output: CONTROL_TRAINING_DATA_FILE,
      control_test_data_output: CONTROL_TEST_DATA_FILE,
      control_input_subfolders: CONTROL_IMAGE_SOURCE
    )
  end
end
