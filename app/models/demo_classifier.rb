require 'active_model'
require 'carrierwave'
require 'carrierwave/orm/activerecord'

class DemoClassifier
  include ::ActiveModel::Validations
  extend CarrierWave::Mount

  mount_uploaders :image_files, ImageFileUploader

  attr_accessor :classifier

  validates :image_files, presence: true

  def initialize
    File.open('lib/assets/serialized_classifiers/neural_net_classifier') do |f|
      @classifier = Marshal.load(f)
    end
  end

  def classify
    image_classification = image_files.map do |image|
      image_data = ::ImageData.extract(image.path)
      @classifier.eval(image_data.map(&:to_f))
    end

    return image_classification
  end
end
