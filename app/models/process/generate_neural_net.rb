class Process::GenerateNeuralNet
  SERILIZED_CLASSIFIER_FILE = File.join(Rails.root, 'lib/assets/serialized_classifiers/neural_net_classifier')
  def self.generate(training_iterations = 100, hidden_layers = [1000, 100, 10])

    bird_training_data = CSV.read(Process::GenerateImageData::BIRD_TRAINING_DATA_FILE)

    bird_training_data.each do |row|
      row.map!(&:to_f)
    end
    bird_training_data.map!{ |row| row << true }

    control_training_data = CSV.read(Process::GenerateImageData::CONTROL_TRAINING_DATA_FILE)
    control_training_data.each do |row|
      row.map!(&:to_f)
    end
    control_training_data.map!{ |row| row << false }

    combined_training_data = Ai4r::Data::DataSet.new(
      :data_items => (bird_training_data + control_training_data).shuffle
    )

    classifier = ::Classifiers::MultilayerPerceptronNumeric.new
    classifier.set_parameters(hidden_layers: hidden_layers, training_iterations: training_iterations )
    classifier.build(combined_training_data)
    File.open(SERILIZED_CLASSIFIER_FILE, "w+"){|to_file| Marshal.dump(classifier, to_file)}
  end

  def self.test()
    classifier = nil
    File.open(SERILIZED_CLASSIFIER_FILE) do |f|
      classifier = Marshal.load(f)
    end

    bird_test_data = CSV.read(Process::GenerateImageData::BIRD_TEST_DATA_FILE)

    bird_data_correct = 0

    bird_test_data.each do |input|
      result = classifier.eval(input.to_a.map(&:to_f))
      bird_data_correct += 1 if result
    end

    puts "Got #{bird_data_correct/bird_test_data.length.to_f} correct"

    control_test_data = CSV.read(Process::GenerateImageData::CONTROL_TEST_DATA_FILE)

    control_data_correct = 0

    control_test_data.each do |input|
      result = classifier.eval(input.to_a.map(&:to_f))
      control_data_correct += 1 unless result
    end

    puts "Got #{control_data_correct/control_test_data.length.to_f} correct"
  end
end
