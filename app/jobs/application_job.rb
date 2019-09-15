class ApplicationJob < ActiveJob::Base
  BIRD_TRAINING_DATA_FILE = File.join(Rails.root, 'lib/assets/data/bird_training_data.csv')
  BIRD_TEST_DATA_FILE = File.join(Rails.root, 'lib/assets/data/bird_test_data.csv')
  CONTROL_TRAINING_DATA_FILE = File.join(Rails.root, 'lib/assets/data/control_training_data.csv')
  CONTROL_TEST_DATA_FILE = File.join(Rails.root, 'lib/assets/data/control_test_data.csv')
end
