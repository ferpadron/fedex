# Fedex gem

This gem is part of a challenge for some new job. It is not available at Rubygems.org, it is a private gem.

## Installation

### To install this gem, follow the instructions below:
* Clone this repository with

  ```git clone https://github.com/ferpadron/fedex.git```
* Do a build from the root directory:

  ```gem build fedex.gemspec```
* Install the gem manually with:

  ```gem install fedex-0.1.0.gem```
* That's it and do it one time, although it is used in many projects.

## Usage
### To add the gem to a project:
* In the Gemfile add this line:

  ```gem 'fedex'```
* In the class to be used add this line:

  ```require 'fedex'```
* To get a shipping quote:

  ```rates = Fedex::Rates.get(credentials, quote_params)```
* Examples of structures for 'credentials' and 'quote_params':
  * **credentials**

    ```
    {
      :key => "bkjIgUhxdgh00000",
      :password => "6p8oOccHmDwuJZCyJs4411111",
      :account_number => 510022222,
      :meter_number => 119233333
    }
    ```
  * **quote_params**

    ```
    {
      :address_from => {
        :zip => "29000",
        :country => "MX"
      },
      :address_to => {
        :zip => "06500",
        :country => "MX"
      },
      :parcel => {
        :length => 25.0,
        :width => 28.0,
        :height => 46.0,
        :distance_unit => "cm",
        :weight => 6.5,
        :mass_unit => "kg"
      }
    }
    ```
* More details and help at [reto](https://github.com/ferpadron/reto) github project
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ferpadron/fedex. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/ferpadron/fedex/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Fedex project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ferpadron/fedex/blob/master/CODE_OF_CONDUCT.md).
