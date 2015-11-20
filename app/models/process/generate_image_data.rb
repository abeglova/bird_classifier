class Process::GenerateImageData
  require 'opencv'
  include OpenCV

  BIRD_TRAINING_DATA_FILE = File.join(Rails.root, 'lib/assets/data/bird_training_data.csv')
  BIRD_TEST_DATA_FILE = File.join(Rails.root, 'lib/assets/data/bird_test_data.csv')
  CONTROL_TRAINING_DATA_FILE = File.join(Rails.root, 'lib/assets/data/control_training_data.csv')
  CONTROL_TEST_DATA_FILE = File.join(Rails.root, 'lib/assets/data/control_test_data.csv')

  def self.run
    #load images
    bird_training_images = []
    bird_test_images = []
    control_training_images = []
    control_test_images = []

    bird_subfolders = Dir.glob(File.join(Rails.root, 'lib/assets/bird_images/**'))
    bird_training_images, bird_test_images = generate_image_lists(bird_subfolders)

    control_subfolders = Dir.glob(File.join(Rails.root, 'lib/assets/control_images/**'))
    control_training_images, control_test_images = generate_image_lists(control_subfolders)

    #turn images into data
    generate_image_data_file(bird_training_images, BIRD_TRAINING_DATA_FILE)
    generate_image_data_file(bird_test_images, BIRD_TEST_DATA_FILE)
    generate_image_data_file(control_training_images, CONTROL_TRAINING_DATA_FILE)
    generate_image_data_file(control_test_images, CONTROL_TEST_DATA_FILE)
  end

  def self.generate_image_lists(subfolders)
    training_images = []
    test_images = []

    subfolders.each do |subfolder|
      subfolder_images = Dir.entries(subfolder).select{|file_name| !File.directory?(file_name) && file_name[0] != '.' }
        .map{ |file_name| subfolder + '/' + file_name }
      subfoler_training_images, subfolder_test_images = subfolder_images.each_slice( (subfolder_images.size/2.0).round ).to_a
      training_images = training_images + subfoler_training_images
      test_images = test_images + subfolder_test_images
    end

    return training_images, test_images
  end

  def self.generate_image_data_file(image_array, file)

    CSV.open(file, 'wb') do |csv|
      image_array.each do |image_path|
        image = OpenCV::CvMat.load(image_path)

        gray = image.BGR2GRAY
        contours = gray.smooth(:blur, 2, 7).canny(60, 100).find_contours(:mode => OpenCV::CV_RETR_CCOMP, :method => OpenCV::CV_CHAIN_APPROX_SIMPLE)

        contour_image = gray.clone.clear
        contour_image.draw_contours!(contours, CvColor::White, CvColor::White, 2,
                               :thickness => 2, :line_type => :aa)

        moments = CvMoments.new(contour_image, true).hu.to_a

        csv << moments
      end
    end
  end
end
