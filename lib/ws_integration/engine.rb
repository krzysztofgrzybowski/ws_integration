module WsIntegration
  class Engine < ::Rails::Engine
    isolate_namespace WsIntegration

    require 'http'
    require 'nokogiri'
  end
end
