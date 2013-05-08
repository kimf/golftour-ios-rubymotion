# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'rubygems'
require 'bundler'
require 'yaml'

if ARGV.join(' ') =~ /spec/
  Bundler.require :default, :spec
else
  Bundler.require
end

#specific requires from biiiig gems
require 'bubble-wrap/http'
require 'bubble-wrap/core'


Motion::Project::App.setup do |app|

  app.name = 'Golftour'
  app.sdk_version = "6.1"
  app.device_family = :iphone


  app.files = (app.files - Dir.glob('./app/**/*.rb')) + Dir.glob("./lib/**/*.rb") + Dir.glob("./config/**/*.rb") + Dir.glob("./app/**/*.rb")


  app.pods do
    pod 'SVProgressHUD'
    pod 'NanoStore'
  end

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