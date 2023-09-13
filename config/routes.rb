# frozen_string_literal: true

DiscourseHCaptcha::Engine.routes.draw do
  post "/create" => "h_captcha#create"
end

Discourse::Application.routes.draw { mount ::DiscourseHCaptcha::Engine, at: "hcaptcha" }
