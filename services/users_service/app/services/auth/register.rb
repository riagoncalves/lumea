module Auth
  class Register < ApplicationService

    attribute :email, :string
    attribute :password, :string
    attribute :password_confirmation, :string
    attribute :type, :string

    validates :email, 'valid_email_2/email': { mx: true,
                                               message: "Doesn't look like a valid email address" },
                      presence: { message: "Email can't be blank" }
    validates :password, presence: true, length: { minimum: 6 }
    validates :password_confirmation, presence: true
    validates :type, presence: true, inclusion: { in: %w[Patient Doctor] }

    validate :validate_unique_email
    validate :validate_passwords_match

    def call
      return false unless valid?

      type.constantize.create(email: email, password: password)
    end

    private

    def validate_unique_email
      return unless email.present?
      return unless User.exists?(email: email)

      errors.add(:email, 'has already been taken')
    end

    def validate_passwords_match
      return unless password.present? && password_confirmation.present?
      return if password.eql?(password_confirmation)

      errors.add(:password_confirmation, "doesn't match Password")
    end
  end
end
