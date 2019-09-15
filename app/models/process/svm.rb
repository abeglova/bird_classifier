require 'libsvm'

class Process::Svm
  include Libsvm

  SERILIZED_CLASSIFIER_FILE = File.join(Rails.root,
    'lib/assets/serialized_classifiers/svm_classifier')

  def self.generate
    bird_training_data = CSV.read(Process::GenerateImageDataFiles::BIRD_TRAINING_DATA_FILE)

    bird_training_data.each do |row|
      row.map!(&:to_f)
    end

    bird_training_data.map! { |row| row << true }

    control_training_data = CSV.read(Process::GenerateImageDataFiles::CONTROL_TRAINING_DATA_FILE)
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

  def self.test
    classifier = Model.load(SERILIZED_CLASSIFIER_FILE)

    bird_test_data = CSV.read(Process::GenerateImageDataFiles::BIRD_TEST_DATA_FILE)

    bird_data_correct = 0

    bird_test_data.each do |input|
      input.map!(&:to_f)
      result = classifier.predict(Libsvm::Node.features(*input))
      bird_data_correct += 1 if result == 1
    end

    puts "Got #{bird_data_correct / bird_test_data.length.to_f} correct for control images"

    control_test_data = CSV.read(Process::GenerateImageDataFiles::CONTROL_TEST_DATA_FILE)

    control_data_correct = 0

    control_test_data.each do |input|
      input.map!(&:to_f)
      result = classifier.predict(Libsvm::Node.features(*input))
      control_data_correct += 1 if result.zero?
    end

    puts "Got #{control_data_correct / control_test_data.length.to_f} correct for bird images"
  end
end
