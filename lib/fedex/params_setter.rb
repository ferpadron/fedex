# frozen_string_literal: true

module Fedex
  ##
  # Simple setter of correct params to get Fedex quotes
  #
  class ParamsSetter
    def initialize(credentials, qps)
      @credentials = credentials
      @qps = qps
    end

    def call
      %(<RateRequest xmlns="http://fedex.com/ws/rate/v13">#{authentication}
      <Version><ServiceId>crs</ServiceId><Major>13</Major><Intermediate>0</Intermediate><Minor>0</Minor></Version>
      <ReturnTransitAndCommit>true</ReturnTransitAndCommit>
      <RequestedShipment><DropoffType>REGULAR_PICKUP</DropoffType><PackagingType>YOUR_PACKAGING</PackagingType>
      #{shipper}#{recipient}
      <ShippingChargesPayment><PaymentType>SENDER</PaymentType></ShippingChargesPayment>
      <RateRequestTypes>ACCOUNT</RateRequestTypes><PackageCount>1</PackageCount>
      <RequestedPackageLineItems><GroupPackageCount>1</GroupPackageCount>#{item_weight}#{item_dimensions}
      </RequestedPackageLineItems></RequestedShipment></RateRequest>)
   end

    def authentication
      %(<WebAuthenticationDetail>
        <UserCredential><Key>#{@credentials[:key]}</Key><Password>#{@credentials[:password]}</Password></UserCredential>
      </WebAuthenticationDetail>
      <ClientDetail>
        <AccountNumber>#{@credentials[:account_number]}</AccountNumber>
        <MeterNumber>#{@credentials[:meter_number]}</MeterNumber>
        <Localization><LanguageCode>es</LanguageCode><LocaleCode>mx</LocaleCode></Localization>
      </ClientDetail>)
    end

    def shipper
      %(<Shipper>
        <Address>
          <StreetLines></StreetLines><City></City><StateOrProvinceCode>XX</StateOrProvinceCode>
          <PostalCode>#{@qps[:address_from][:zip]}</PostalCode>
          <CountryCode>#{@qps[:address_from][:country].upcase}</CountryCode>
        </Address>
      </Shipper>)
    end

    def recipient
      %(<Recipient>
        <Address>
          <StreetLines></StreetLines><City></City><StateOrProvinceCode>XX</StateOrProvinceCode>
          <PostalCode>#{@qps[:address_to][:zip]}</PostalCode>
          <CountryCode>#{@qps[:address_to][:country].upcase}</CountryCode>
          <Residential>false</Residential>
        </Address>
      </Recipient>)
    end

    def item_weight
      %(<Weight>
          <Units>#{@qps[:parcel][:mass_unit].upcase}</Units>
          <Value>#{@qps[:parcel][:weight].round}</Value>
        </Weight>)
    end

    def item_dimensions
      %(<Dimensions>
          <Length>#{@qps[:parcel][:length].round}</Length>
          <Width>#{@qps[:parcel][:width].round}</Width>
          <Height>#{@qps[:parcel][:height].round}</Height>
          <Units>#{@qps[:parcel][:distance_unit].upcase}</Units>
      </Dimensions>)
    end
  end
end
