# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'

require 'rubygems'
require 'bundler'

Bundler.require

Motion::Project::App.setup do |app|

  app.name = 'Golftour'
  app.prerendered_icon = true
  app.sdk_version = "6.1"
  app.device_family = [:iphone]

  app.status_bar_style = :black_opaque

  #Frameworks
  app.frameworks << "CoreData"
  app.frameworks += ['QuartzCore']

  app.vendor_project('vendor/nsrails', :xcode, :target => 'NSRails', :headers_dir => 'Source')


   if File.exists?('./config.yml')
    config = YAML::load_file('./config.yml')

    app.identifier = config['identifier']

    app.info_plist['API_URL'] = config['api_url']
    app.info_plist['API_EMAIL'] = config['api_email']
    app.info_plist['API_PASS'] = config['api_pass']

    app.development do
      # This entitlement is required during development but must not be used for release.
      app.entitlements['get-task-allow'] = true
      #testflight
      app.testflight.sdk = 'vendor/TestFlightSDK1.1'
      app.testflight.api_token = config['testflight']['api_token']
      app.testflight.team_token = config['testflight']['team_token']
      #apple cert stuff
      app.provisioning_profile = config['development']['provisioning_profile']
      app.codesign_certificate = config['development']['certificate']
    end

    app.release do
      app.provisioning_profile = config['release']['provisioning']
      app.codesign_certificate = config['release']['certificate']
      app.seed_id = config['release']['seed_id']
    end
  end
end