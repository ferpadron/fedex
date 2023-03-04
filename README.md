# Fedex gem

This gem is part of a challenge for some new job. It is not available at Rubygems.org, it is a private gem.

## Installation

### Para instalar esta gema siga las siguientes instrucciones:
* Clone este repositorio con
```git clone https://github.com/ferpadron/fedex.git```
* Haga un build desde el directorio raíz:
```gem build fedex.gemspec```
* Instale la gema manualmente con:
```gem install fedex-0.1.0.gem```
* Es todo y se realiza por única ocasión, aunque se utilice en muchos proyectos.

## Usage
### Para agregar la gema a un proyecto:
* En el Gemfile del proyecto agregue esta línea:
```gem 'fedex'```
* En la clase que será utilizada agregue esta línea:
```require 'fedex'```
* Para obtener una cotización de envío:
```rates = Fedex::Rates.get(credentials, quote_params)```
* Para obtener ejemplos de las estructuras para 'credentials' y 'quote_params' consulte el proyecto: 
[reto](https://github.com/ferpadron/reto)


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ferpadron/fedex. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/ferpadron/fedex/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Fedex project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ferpadron/fedex/blob/master/CODE_OF_CONDUCT.md).
