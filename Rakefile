# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'rubygems'
require 'bundler'

if ARGV.join(' ') =~ /spec/
  Bundler.require :default, :spec
else
  Bundler.require
end

Motion::Project::App.setup do |app|

  app.name = 'Golftour'
  app.prerendered_icon = true
  app.sdk_version = "6.1"
  app.device_family = [:iphone]

  app.files = (app.files - Dir.glob('./app/**/*.rb')) + Dir.glob("./lib/**/*.rb") + Dir.glob("./config/**/*.rb") + Dir.glob("./app/**/*.rb")

  #Vendors
  app.vendor_project('vendor/Reachability', :static)

  #Pods
  app.pods do
    pod 'SVProgressHUD', '0.9'
    pod 'MagicalRecord', '2.1'
    pod 'TestFlightSDK', '1.2.3.beta1'
  end

  #Core iOS Frameworks
  app.frameworks << "CoreData"
  app.frameworks += ['QuartzCore']

  if File.exists?('./config.yml')
    config = YAML::load_file('./config.yml')

    app.identifier = config['identifier']

    app.info_plist['API_URL'] = config['api_url']

    app.development do
      # This entitlement is required during development but must not be used for release.
      app.entitlements['get-task-allow'] = true
      #testflight
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