class Document < ApplicationRecord
  include Loggable

  belongs_to :documentable, polymorphic: true

  mount_uploader :file, DocumentUploader

  attr_accessor :file_base64
  before_save :decode_base64_file

  private

  def decode_base64_file
    return unless file_base64.present?

    content_type, encoding, string = file_base64.split(/[:;,]/)[1..3]

    extension = content_type.split('/')[1]
    filename = "upload.#{extension}"
    decoded_data = Base64.decode64(string)

    temp_file = Tempfile.new([File.basename(filename, ".*"), ".#{extension}"])
    temp_file.binmode
    temp_file.write(decoded_data)
    temp_file.rewind

    self.file = temp_file
  end
end
