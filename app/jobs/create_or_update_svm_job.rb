class CreateOrUpdateSvmJob < ApplicationJob
  queue_as :default

  def perform
    Classifiers::Svm.create_or_update(
      bird_training_data_file: BIRD_TRAINING_DATA_FILE,
      control_training_data_file: CONTROL_TRAINING_DATA_FILE
    )
  end
end
