class Document < ApplicationRecord
  belongs_to :documentable, polymorphic: true

  mount_uploader :file, DocumentUploader
end
