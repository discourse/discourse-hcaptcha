# frozen_string_literal: true

DiscourseHCaptcha::Engine.routes.draw { post "/create" => "h_captcha#create" }

Discourse::Application.routes.draw { mount ::DiscourseHCaptcha::Engine, at: "hcaptcha" }
