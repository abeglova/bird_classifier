require 'rails_helper'

RSpec.describe TestNeuralNetJob do
  context 'perform' do
    it 'calls Classifiers::NeuralNet.test with the correct parameters' do
      expect(Classifiers::NeuralNet).to receive(:test).
        with(bird_test_data_file: ApplicationJob::BIRD_TEST_DATA_FILE,
          control_test_data_file: ApplicationJob::CONTROL_TEST_DATA_FILE)
      TestNeuralNetJob.perform_now
    end
  end
end
