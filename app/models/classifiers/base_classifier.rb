class Classifiers::BaseClassifier
  class NoSerializedClassifierError < StandardError
  end

  def initialize
    load_serialized_classifier
  end

  def test(bird_test_data_file:, control_test_data_file:)
    bird_test_data = CSV.read(bird_test_data_file)
    bird_test_data_percent_bird = percent_bird(bird_test_data)

    puts "Got #{bird_test_data_percent_bird}% correct for bird images"

    control_test_data = CSV.read(control_test_data_file)
    control_test_data_percent_bird = percent_bird(control_test_data)

    puts "Got #{100 - control_test_data_percent_bird}% correct for control images"
  end

  private

  def percent_bird(data)
    num_bird = 0

    data.each do |input|
      result = make_prediction(input.to_a.map(&:to_f))
      num_bird += 1 if result
    end

    (num_bird / data.length.to_f) * 100
  end
end
