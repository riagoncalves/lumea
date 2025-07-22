class ErrorSerializer < ApplicationSerializer
  attributes :errors

  def errors
    object.errors.full_messages
  end
end
