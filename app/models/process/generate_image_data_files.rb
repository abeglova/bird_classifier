class Process::GenerateImageDataFiles
  require 'opencv'
  include OpenCV

  BIRD_TRAINING_DATA_FILE = File.join(Rails.root, 'lib/assets/data/bird_training_data.csv')
  BIRD_TEST_DATA_FILE = File.join(Rails.root, 'lib/assets/data/bird_test_data.csv')
  CONTROL_TRAINING_DATA_FILE = File.join(Rails.root, 'lib/assets/data/control_training_data.csv')
  CONTROL_TEST_DATA_FILE = File.join(Rails.root, 'lib/assets/data/control_test_data.csv')

  ADDITIONAL_BIRD_DATA_FILE = File.join(Rails.root, 'lib/assets/data/additional_bird_test_data.csv')
  ADDITIONAL_CONTROL_DATA_FILE = File.join(Rails.root,
    'lib/assets/data/additional_control_test_data.csv')

  TEST_IMAGE_PROPORTION = 0.25

  def self.run
    bird_subfolders = Dir.glob(File.join(Rails.root, 'lib/assets/bird_images/**'))
    bird_training_images, bird_test_images = generate_image_lists(bird_subfolders)

    control_subfolders = Dir.glob(File.join(Rails.root, 'lib/assets/control_images/**'))
    control_training_images, control_test_images = generate_image_lists(control_subfolders)

    generate_image_data_file(bird_training_images, BIRD_TRAINING_DATA_FILE)
    generate_image_data_file(bird_test_images, BIRD_TEST_DATA_FILE)
    generate_image_data_file(control_training_images, CONTROL_TRAINING_DATA_FILE)
    generate_image_data_file(control_test_images, CONTROL_TEST_DATA_FILE)
  end

  def self.generate_additional_test_data_files
    bird_images = ignore_system_files(Dir['lib/assets/additional_bird_images/**/*'])
    control_images = ignore_system_files(Dir['lib/assets/additional_control_images/**/*'])
    generate_image_data_file(bird_images, ADDITIONAL_BIRD_DATA_FILE)
    generate_image_data_file(control_images, ADDITIONAL_CONTROL_DATA_FILE)
  end

  def self.generate_image_lists(subfolders)
    training_images = []
    test_images = []

    subfolders.each do |subfolder|
      subfolder_images = ignore_system_files(Dir.entries(subfolder)).map do |file_name|
        subfolder + '/' + file_name
      end

      subfolder_training_images = subfolder_images.each_with_index.map do |img, idx|
        img if idx % (1 / TEST_IMAGE_PROPORTION).to_i != 0
      end.compact

      subfolder_test_images = subfolder_images.each_with_index.map do |img, idx|
        img if (idx % (1 / TEST_IMAGE_PROPORTION).to_i).zero?
      end.compact

      training_images += subfolder_training_images
      test_images += subfolder_test_images
    end

    [training_images, test_images]
  end

  def self.generate_image_data_file(image_array, file)
    CSV.open(file, 'wb') do |csv|
      image_array.each do |image_path|
        data_for_image = ::ImageData.extract(image_path)

        if data_for_image
          csv << data_for_image
        else
          puts "image data could not be generated for #{image_path}"
        end
      end
    end
  end

  def self.ignore_system_files(file_array)
    file_array.select { |file_name| !File.directory?(file_name) && file_name[0] != '.' }
  end
end
