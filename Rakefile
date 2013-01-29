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

  #testflight
  app.testflight.sdk = 'vendor/TestFlightSDK1.1'
  app.testflight.api_token = 'Oeyjm6QnyBP75jjdGyRiRX3OgB1WX117Ld9xuCNaCMU'
  app.testflight.team_token = "3694f085bf23e82efd818f1dfb6e8676_MTI1MDI2MjAxMi0wOC0yNCAxNTo1MDo0Ny44MTkwNDc"

  #Frameworks
  app.frameworks << "CoreData"
  app.frameworks += ['QuartzCore']

  app.vendor_project('vendor/nsrails', :xcode, :target => 'NSRails', :headers_dir => 'Source')


  #apple cert stuff
  app.provisioning_profile = '/Users/kimf/Dropbox/Apple Certificates and stuff/Golftour.mobileprovision'
  app.identifier = "se.fransman.golftour"
  app.codesign_certificate = 'iPhone Developer: Kim Fransman (RYL24UPDWZ)'

  app.development do
    # This entitlement is required during development but must not be used for release.
    app.entitlements['get-task-allow'] = true
  end
end