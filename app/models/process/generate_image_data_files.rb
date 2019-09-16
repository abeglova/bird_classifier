class Process::GenerateImageDataFiles
  TEST_IMAGE_PROPORTION = 0.25

  def self.create_or_update_training_data_files(bird_input_subfolders:, bird_test_data_output:,
    bird_training_data_output:, control_input_subfolders:, control_test_data_output:,
    control_training_data_output:)

    bird_training_images, bird_test_images =
      generate_image_lists(bird_input_subfolders)

    control_training_images, control_test_images =
      generate_image_lists(control_input_subfolders)

    generate_image_data_file(bird_training_images, bird_training_data_output)
    generate_image_data_file(bird_test_images, bird_test_data_output)
    generate_image_data_file(control_training_images, control_training_data_output)
    generate_image_data_file(control_test_images, control_test_data_output)
  end

  def self.create_or_update_additional_test_data_files(bird_data_output:, bird_input_subfolders:,
    control_data_output:, control_input_subfolders:)
    bird_images = ignore_system_files(bird_input_subfolders)
    control_images = ignore_system_files(control_input_subfolders)
    generate_image_data_file(bird_images, bird_data_output)
    generate_image_data_file(control_images, control_data_output)
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
  private_class_method :generate_image_data_file

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
  private_class_method :generate_image_lists

  def self.ignore_system_files(file_array)
    file_array.select { |file_name| !File.directory?(file_name) && file_name[0] != '.' }
  end
  private_class_method :ignore_system_files
end
