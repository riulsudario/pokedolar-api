class Money::FetchDollarService < BusinessProcess::Base
  include ActionView::Helpers::NumberHelper

  URL = 'https://economia.awesomeapi.com.br/json/all/USD-BRL'

  steps :index,
        :dollar_value,
        :format_dollar_value,
        :call_pokeapi

  def call
    process_steps
    @pokemon
  end

  def index
    @result = RestClient.get(URL)
  end

  def dollar_value
    parsed_json = JSON.parse(@result)
    @dollar = parsed_json['USD']['bid']
  end

  def format_dollar_value
    dollar = number_to_human(@dollar)
    dollar = number_with_precision(dollar, precision: 2)
    @formatted_dollar = dollar.tr('.', '')
  end

  def call_pokeapi
    service = Pokemon::FetchPokeapiService.call(dollar_value: @formatted_dollar)

    @pokemon = service.result
  end
end
