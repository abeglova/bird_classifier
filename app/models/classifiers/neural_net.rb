class Classifiers::NeuralNet
  SERILIZED_CLASSIFIER_FILE = File.join(Rails.root,
    'lib/assets/serialized_classifiers/neural_net_classifier')

  def self.create_or_update(bird_training_data_file:, control_training_data_file:,
    training_iterations: 100, hidden_layers: [])

    bird_training_data = CSV.read(bird_training_data_file)

    bird_training_data.each do |row|
      row.map!(&:to_f)
    end
    bird_training_data.map! { |row| row << true }

    control_training_data = CSV.read(control_training_data_file)
    control_training_data.each do |row|
      row.map!(&:to_f)
    end
    control_training_data.map! { |row| row << false }

    combined_training_data = Ai4r::Data::DataSet.new(
      data_items: (bird_training_data + control_training_data).shuffle
    )

    classifier = ::Classifier::MultilayerPerceptronNumeric.new
    classifier.set_parameters(hidden_layers: hidden_layers,
      training_iterations: training_iterations)
    classifier.build(combined_training_data)
    File.open(SERILIZED_CLASSIFIER_FILE, 'w+') { |to_file| Marshal.dump(classifier, to_file) }
  end

  def self.load_serialized_classifier
    classifier = nil

    File.open(SERILIZED_CLASSIFIER_FILE) do |f|
      classifier = Marshal.load(f)
    end

    classifier
  end

  def self.make_prediction(data)
    classifier = load_serialized_classifier
    classifier.eval(data)
  end

  def self.test(bird_test_data_file:, control_test_data_file:)
    bird_test_data = CSV.read(bird_test_data_file)
    bird_test_data_percent_bird = percent_bird(bird_test_data)

    puts "Got #{bird_test_data_percent_bird}% correct for bird images"

    control_test_data = CSV.read(control_test_data_file)
    control_test_data_percent_bird = percent_bird(control_test_data)

    puts "Got #{100 - control_test_data_percent_bird}% correct for control images"
  end

  def self.percent_bird(data)
    num_bird = 0

    classifier = load_serialized_classifier

    data.each do |input|
      result = classifier.eval(input.to_a.map(&:to_f))
      num_bird += 1 if result
    end

    (num_bird / data.length.to_f) * 100
  end
  private_class_method :percent_bird
end
