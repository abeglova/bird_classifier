require 'rails_helper'

RSpec.describe CreateOrUpdateNeuralNetJob do
  context 'perform' do
    it 'calls Process::NeuralNet.create_or_update with the correct parameters' do
      expect(Process::NeuralNet).to receive(:create_or_update).
        with(bird_training_data_file: ApplicationJob::BIRD_TRAINING_DATA_FILE,
          control_training_data_file: ApplicationJob::CONTROL_TRAINING_DATA_FILE)
      CreateOrUpdateNeuralNetJob.perform_now
    end
  end
end
