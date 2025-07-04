module DiscourseHcaptcha
  class CaptchaProvider
    def fetch_captcha_token
      raise NotImplementedError
    end

    def fetch_captcha_token
      raise NotImplementedError
    end

    def captcha_verification_url
      raise NotImplementedError
    end

    protected

    def fetch_token(temp_id_key, redis_prefix, cookies)
      temp_id = cookies.encrypted[temp_id_key]
      captcha_token = Discourse.redis.get("#{redis_prefix}_#{temp_id}")

      if temp_id.present?
        Discourse.redis.del("#{redis_prefix}_#{temp_id}")
        cookies.delete(temp_id_key)
      end

      captcha_token
    end
  end

  class HcaptchaProvider < CaptchaProvider
    CAPTCHA_VERIFICATION_URL = "https://hcaptcha.com/siteverify".freeze
    def fetch_captcha_token(cookies)
      fetch_token(:h_captcha_temp_id, "hCaptchaToken", cookies)
    end

    def captcha_verification_url
      CAPTCHA_VERIFICATION_URL
    end
  end

  class RecaptchaProvider < CaptchaProvider
    CAPTCHA_VERIFICATION_URL = "https://www.google.com/recaptcha/api/siteverify".freeze

    def fetch_captcha_token(cookies)
      fetch_token(:re_captcha_temp_id, "reCaptchaToken", cookies)
    end

    def captcha_verification_url
      CAPTCHA_VERIFICATION_URL
    end
  end
end
