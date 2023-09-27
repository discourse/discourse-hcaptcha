# frozen_string_literal: true

# name: discourse-hCaptcha
# about: hCaptcha support for Discourse
# version: 0.0.1
# authors: Discourse
# url: https://github.com/discourse/discourse-hCaptcha
# required_version: 2.7.0

enabled_site_setting :discourse_hCaptcha_enabled

module ::DiscourseHCaptcha
  PLUGIN_NAME = "discourse-hCaptcha"
end

require_relative "lib/discourse_h_captcha/engine"

after_initialize do
  require_dependency File.expand_path(
                       "../app/controllers/discourse_h_captcha/h_captcha_controller.rb",
                       __FILE__,
                     )
  require_dependency File.expand_path(
                       "../lib/discourse_h_captcha/create_users_controller_patch.rb",
                       __FILE__,
                     )

  reloadable_patch do
    UsersController.class_eval { include DiscourseHCaptcha::CreateUsersControllerPatch }
  end
end
