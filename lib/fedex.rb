# frozen_string_literal: true

require "rubygems"
require_relative "fedex/version"
require "net/http"
require "nokogiri"
require "active_support/core_ext/hash/conversions"

module Fedex
  class Error < StandardError; end
  FEDEX_URL = "https://wsbeta.fedex.com:443/xml"
  ##
  # Main class of this gem
  class Rates
    def self.get(credentials, quote_params)
      req = Net::HTTP.post(URI(FEDEX_URL), fedex_params(credentials, quote_params), "Content-Type" => "application/xml")
      res = Hash.from_xml(Nokogiri::XML(req.body).to_s)["RateReply"]
      res["RateReplyDetails"] ? turn_results(res["RateReplyDetails"]) : turn_error(res["Notifications"]["Message"])
    rescue StandardError => e
      { message: "Error: #{e.message}." }
    end

    def self.turn_results(res)
      to_back = []
      res.each do |rate|
        srv_type = rate["ServiceType"]
        name = srv_type.split('_').map { |n| n.capitalize }.join(' ')
        price = 0
        rate["RatedShipmentDetails"].each do |det|
          next if det["ShipmentRateDetail"]["CurrencyExchangeRate"]["Rate"] != "1.0"
          price = det["ShipmentRateDetail"]["TotalNetChargeWithDutiesAndTaxes"]["Amount"].to_f
        end
        next unless price.positive?
        to_back << { price: price, currency: "MXN", service_level: { name: name, token: srv_type } }
      end
      to_back.blank? ? { message: "Error: No price found for this request." } : to_back
    end

    def self.turn_error(res)
      { message: "Error: #{res}" }
    end

    def self.fedex_params(credentials, qps)
      %(<RateRequest xmlns="http://fedex.com/ws/rate/v13"><WebAuthenticationDetail><UserCredential>
      <Key>#{credentials[:key]}</Key><Password>#{credentials[:password]}</Password>
      </UserCredential></WebAuthenticationDetail><ClientDetail><AccountNumber>510087720</AccountNumber>
      <MeterNumber>119238439</MeterNumber><Localization><LanguageCode>es</LanguageCode><LocaleCode>mx</LocaleCode>
      </Localization></ClientDetail><Version><ServiceId>crs</ServiceId><Major>13</Major><Intermediate>0</Intermediate>
      <Minor>0</Minor></Version><ReturnTransitAndCommit>true</ReturnTransitAndCommit><RequestedShipment>
      <DropoffType>REGULAR_PICKUP</DropoffType><PackagingType>YOUR_PACKAGING</PackagingType>
      <Shipper><Address><StreetLines></StreetLines><City></City><StateOrProvinceCode>XX</StateOrProvinceCode>
      <PostalCode>#{qps[:address_from][:zip]}</PostalCode><CountryCode>#{qps[:address_from][:country].upcase}</CountryCode>
      </Address></Shipper><Recipient><Address><StreetLines></StreetLines><City></City>
      <StateOrProvinceCode>XX</StateOrProvinceCode>
      <PostalCode>#{qps[:address_to][:zip]}</PostalCode><CountryCode>#{qps[:address_to][:country].upcase}</CountryCode>
      <Residential>false</Residential></Address></Recipient><ShippingChargesPayment><PaymentType>SENDER</PaymentType>
      </ShippingChargesPayment><RateRequestTypes>ACCOUNT</RateRequestTypes><PackageCount>1</PackageCount>
      <RequestedPackageLineItems><GroupPackageCount>1</GroupPackageCount>
      <Weight><Units>#{qps[:parcel][:mass_unit].upcase}</Units><Value>#{qps[:parcel][:weight].round}</Value></Weight>
      <Dimensions><Length>#{qps[:parcel][:length].round}</Length><Width>#{qps[:parcel][:width].round}</Width>
        <Height>#{qps[:parcel][:height].round}</Height><Units>#{qps[:parcel][:distance_unit].upcase}</Units>
      </Dimensions>
      </RequestedPackageLineItems></RequestedShipment></RateRequest>)
    end
  end
end
