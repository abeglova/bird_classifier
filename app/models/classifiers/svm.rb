require 'libsvm'

class Classifiers::Svm < Classifiers::BaseClassifier
  include Libsvm

  SERILIZED_CLASSIFIER_FILE = File.join(Rails.root,
    'lib/assets/serialized_classifiers/svm_classifier')

  def self.create_or_update(bird_training_data_file:, control_training_data_file:)
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

    combined_training_data = (bird_training_data + control_training_data).shuffle

    training_inputs = combined_training_data.map do |instance|
      Node.features(instance[1..-2].map(&:to_f))
    end

    training_labels = combined_training_data.map { |instance| instance.last ? 1 : 0 }
    problem = Problem.new
    problem.set_examples(training_labels, training_inputs)

    parameters = Libsvm::SvmParameter.new

    parameters.cache_size  = 100 # in megabytes
    parameters.eps         = 0.00001
    parameters.degree      = 5
    parameters.gamma       = 0.01
    parameters.c           = 100
    parameters.kernel_type = KernelType.const_get(:SIGMOID)

    classifier = Libsvm::Model.train(problem, parameters)

    classifier.save(SERILIZED_CLASSIFIER_FILE)
  end

  def make_prediction(data)
    @classifier.predict(Libsvm::Node.features(*data)) == 1
  end

  private

  def load_serialized_classifier
    @classifier = Libsvm::Model.load(SERILIZED_CLASSIFIER_FILE)
  end
end
