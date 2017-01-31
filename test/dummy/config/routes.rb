Rails.application.routes.draw do
  mount WsIntegration::Engine => "/ws_integration"
end
