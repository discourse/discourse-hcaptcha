# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe '#create' do
    before do
      controller.stubs(:cookies).returns(encrypted: { h_captcha_temp_id: 'temp123' })
      SiteSetting.stubs(:allow_new_registrations).returns(true)
    end

    let(:user_params) { { email: 'test@example.com', username: 'testuser', password: 'password' } }

    it 'fails when h_captcha_token is blank' do
      Discourse.redis.stubs(:get).returns(nil)

      post :create, params: user_params
      puts "Response Body: #{response.body}"
      puts "Response Status: #{response.status}"
      expect(JSON.parse(response.body)['message']).to eq('h_captcha_verification_failed')
    end

    it 'fails when h_captcha verification fails' do
      Discourse.redis.stubs(:get).returns('token123')
      Net::HTTP.any_instance.stubs(:request).returns(OpenStruct.new(code: '200', body: '{"success":false}'))

      post :create, params: user_params
      puts "Response Body: #{response.body}"
      puts "Response Status: #{response.status}"
      expect(JSON.parse(response.body)['message']).to eq('h_captcha_verification_failed')
    end

    it 'succeeds when h_captcha verification is successful' do
      Discourse.redis.stubs(:get).returns('token123')
      Net::HTTP.any_instance.stubs(:request).returns(OpenStruct.new(code: '200', body: '{"success":true}'))

      post :create, params: user_params
      puts "Response Body: #{response.body}"
      puts "Response Status: #{response.status}"
      expect(JSON.parse(response.body)['success']).to be(true)
    end
  end
end
