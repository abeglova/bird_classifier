require 'active_model'
require 'carrierwave'
require 'carrierwave/orm/activerecord'

class DemoClassifier
  include ::ActiveModel::Validations
  extend CarrierWave::Mount

  attr_reader :classifier
  mount_uploaders :image_files, ImageFileUploader

  validates :image_files, presence: true
  validates :classifier, presence: true

  def initialize(classifier_type)
    serialized_classifier_file = if classifier_type == 'neural net'
      Process::NeuralNet::SERILIZED_CLASSIFIER_FILE
    elsif classifier_type == 'svm'
      Process::Svm::SERILIZED_CLASSIFIER_FILE
    end

    File.open(serialized_classifier_file) do |f|
      @classifier = Marshal.load(f)
    end
  end

  def classify
    image_classification = image_files.map do |image|
      image_data = ::ImageData.extract(image.path)
      @classifier.eval(image_data.map(&:to_f))
    end

    image_classification
  end
end
