class Classifiers::NeuralNet < Classifiers::BaseClassifier
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

  def make_prediction(data)
    @classifier.eval(data)
  end

  private

  def load_serialized_classifier
    @classifier = nil

    begin
      File.open(SERILIZED_CLASSIFIER_FILE) do |f|
        @classifier = Marshal.load(f)
      end
    rescue Errno::ENOENT
      raise NoSerializedClassifierError
    end
  end
end
