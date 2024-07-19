# frozen_string_literal: true

DiscourseHcaptcha::Engine.routes.draw { post "/create" => "hcaptcha#create" }

Discourse::Application.routes.draw { mount ::DiscourseHcaptcha::Engine, at: "hcaptcha" }
