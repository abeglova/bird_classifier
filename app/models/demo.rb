require 'active_model'
require 'carrierwave'
require 'carrierwave/orm/activerecord'

class Demo
  include ::ActiveModel::Validations
  extend CarrierWave::Mount

  attr_reader :classifier
  mount_uploaders :image_files, ImageFileUploader

  validates :image_files, presence: true
  validates :classifier, presence: true

  def initialize(classifier_type)
    @classifier = if classifier_type == 'neural net'
      Classifiers::NeuralNet
    elsif classifier_type == 'svm'
      Classifiers::Svm
    end
  end

  def classify
    image_classification = image_files.map do |image|
      image_data = ::ImageData.extract(image.path)
      @classifier.make_prediction(image_data.map(&:to_f))
    end

    image_classification
  end
end
