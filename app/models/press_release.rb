# == Schema Information
#
# Table name: press_releases
#
#  id           :integer          not null, primary key
#  medium       :string(255)
#  release_type :string(255)
#  release_date :datetime
#  link         :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  title        :string(255)
#

class PressRelease < ActiveRecord::Base
  validates :title, :presence => true

  # Ugly and deprecated. The press releases will soon be extracted to a separate
  # app.
  def self.upload_file(upload)
    name =  upload.original_filename
    directory = "public/media"
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(upload.read) }
  end
end
