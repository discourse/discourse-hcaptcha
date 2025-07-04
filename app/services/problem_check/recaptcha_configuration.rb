# frozen_string_literal: true

class ProblemCheck::RecaptchaConfiguration < ProblemCheck
  self.priority = "high"

  def call
    if SiteSetting.discourse_captcha_enabled && SiteSetting.discourse_recaptcha_enabled &&
         !recaptcha_credentias_present?
      return problem
    end

    no_problem
  end

  private

  def recaptcha_credentias_present?
    SiteSetting.recaptcha_site_key.present? && SiteSetting.recaptcha_secret_key.present?
  end
end
