# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'bundler'
require 'yaml'

Bundler.require

require 'sugarcube-repl'
require 'sugarcube-gestures'

Motion::Project::App.setup do |app|

  app.name = 'Golftour'
  app.sdk_version = "9.0"
  app.device_family = [:iphone]
  app.prerendered_icon = true

  # add local sources
  Dir.glob(File.join(app.project_dir, 'lib/**/*.rb')).flatten.each do |file|
    app.files.push(file)
  end

  app.frameworks += [
    'QuartzCore',
    'CoreLocation'
  ]


  app.pods do
    pod 'SVProgressHUD'
    pod 'AFNetworking'
    pod 'ViewDeck'
  end

  app.identifier = 'com.screeninteraction.golftour'
  app.info_plist['API_URL']= 'http://192.168.0.104.xip.io:3000/api'

  app.development do
    #apple cert stuff
    app.provisioning_profile = '/Users/kifr/Library/MobileDevice/Provisioning Profiles/09ea883b-154e-45ca-bf02-b8124e3407dc.mobileprovision'
    app.codesign_certificate = 'iPhone Developer: Kim Fransman (C5WLWGDK35)'

    app.entitlements['get-task-allow'] = true
  end
end
