require 'rails_helper'

RSpec.describe TestSvmJob do
  context 'perform' do
    it 'calls Classifiers::Svm.test with the correct parameters' do
      expect_any_instance_of(Classifiers::Svm).to receive(:test).
        with(bird_test_data_file: ApplicationJob::BIRD_TEST_DATA_FILE,
          control_test_data_file: ApplicationJob::CONTROL_TEST_DATA_FILE)
      TestSvmJob.perform_now
    end
  end
end
