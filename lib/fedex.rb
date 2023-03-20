# frozen_string_literal: true

require "rubygems"
require_relative "fedex/version"
require_relative "fedex/params_setter"
require "net/http"
require "nokogiri"
require "active_support/core_ext/hash/conversions"

module Fedex
  class Rates
    FEDEX_URL = 'https://wsbeta.fedex.com:443/xml'

    def self.get(credentials, quote_params)
      params = Fedex::ParamsSetter.new(credentials, quote_params)
      res = Hash.from_xml(Nokogiri::XML(remote_data(params.call)).to_s)['RateReply']
      raise "#{res['Notifications']['Severity'].to_s.downcase.capitalize}: #{res['Notifications']['Message']}" unless res['RateReplyDetails']

      res['RateReplyDetails'].map { |rate| build_a_rate(rate) }.compact
    rescue StandardError => e
      { message: e.message }
    end

    def self.remote_data(url_params)
      req = Net::HTTP.post(URI(FEDEX_URL), url_params, 'Content-Type' => 'application/xml')
      raise "Fedex server answered with code: #{req.code} instead 200" unless req.is_a?(Net::HTTPSuccess) && req.body

      req.body
    end

    def self.build_a_rate(rate)
      srv_type = rate['ServiceType']
      name = srv_type.split('_').map(&:capitalize).join(' ')
      price = 0
      rate['RatedShipmentDetails'].each do |det|
        next if det['ShipmentRateDetail']['CurrencyExchangeRate']['Rate'] != '1.0'

        price = det['ShipmentRateDetail']['TotalNetChargeWithDutiesAndTaxes']['Amount'].to_f
      end
      price.positive? ? { price:, currency: 'MXN', service_level: { name:, token: srv_type } } : nil
    end
  end
end
