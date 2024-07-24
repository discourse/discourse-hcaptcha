# frozen_string_literal: true

class ProblemCheck::HcaptchaCheck < ProblemCheck
  self.priority = "high"

  def call
    [*hcaptcha_site_key, *hcaptcha_secret_key]
  end

  private

  def hcaptcha_credentias_present?
    SiteSetting.hcaptcha_site_key && SiteSetting.hcaptcha_secret_key
  end

  def targets
    [*SiteSetting.hcaptcha_site_key, *SiteSetting.hcaptcha_secret_key]
  end

  def hcaptcha_site_key
    identifier = "hcaptcha_site_key"
    return no_problem if !SiteSetting.hcaptcha_site_key

    Problem.new(
      message(identifier),
      priority: "high",
      identifier: identifier,
      target: identifier,
      details: {
        error: "Your `site_key` is missing",
      },
    )
  end

  def hcaptcha_secret_key
    identifier = "hcaptcha_secret_key"
    return no_problem if !SiteSetting.hcaptcha_secret_key

    Problem.new(
      message(identifier),
      priority: "high",
      identifier: identifier,
      target: identifier,
      details: {
        error: "Your `secret_key` is missing",
      },
    )
  end

  def message(identifier)
    I18n.t("site_settings.errors.#{identifier}", base_path: Discourse.base_path)
  end

  def translation_key
    "site_settings.errors.#{identifier}"
  end
end
