class Money::FetchDollarService < BusinessProcess::Base
  include ActionView::Helpers::NumberHelper

  URL = 'https://economia.awesomeapi.com.br/json/all/USD-BRL'

  steps :index,
        :dollar_value,
        :format_dollar_value,
        :mount_dollar,
        :call_pokeapi

  def call
    process_steps
    @pokemon
  end

  def index
    @result = RestClient.get(URL)
  end

  def dollar_value
    @parsed_json = JSON.parse(@result)
    @dollar = @parsed_json['USD']['bid']
  end

  def format_dollar_value
    @rounded_dollar = number_to_human(@dollar)
    @dollar = number_with_precision(@rounded_dollar, precision: 2)
    @formatted_dollar = dollar.tr('.', '')
  end

  def mount_dollar
    @dollar_obj = {
      pokemon_id: @formatted_dollar,
      dollar: {
        value: @dollar,
        percentage_change: @parsed_json['USD']['pctChange'].to_f,
        positive: @parsed_json['USD']['pctChange'].to_f.positive?
      }
    }
  end

  def call_pokeapi
    service = Pokemon::FetchPokeapiService.call(dollar_obj: @dollar_obj)

    @pokemon = service.result
  end
end
