class TestNeuralNetJob < ApplicationJob
  queue_as :default

  def perform
    classifier = Classifiers::NeuralNet.new
    classifier.test(bird_test_data_file: BIRD_TEST_DATA_FILE,
      control_test_data_file: CONTROL_TEST_DATA_FILE)
  end
end
