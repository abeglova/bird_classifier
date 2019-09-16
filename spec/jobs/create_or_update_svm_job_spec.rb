require 'rails_helper'

RSpec.describe CreateOrUpdateSvmJob do
  context 'perform' do
    it 'calls Classifiers::Svm.create_or_update with the correct parameters' do
      expect(Classifiers::Svm).to receive(:create_or_update).
        with(bird_training_data_file: ApplicationJob::BIRD_TRAINING_DATA_FILE,
          control_training_data_file: ApplicationJob::CONTROL_TRAINING_DATA_FILE)
      CreateOrUpdateSvmJob.perform_now
    end
  end
end
