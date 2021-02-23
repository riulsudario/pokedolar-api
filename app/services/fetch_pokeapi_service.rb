class FetchPokeapiService < BusinessProcess::Base
  BASE_URL = 'https://pokeapi.co/api/v2/pokemon/'

  needs :dollar_value

  steps :index

  def call
    process_steps
    @brl
  end

  def index
    @brl = RestClient.get("#{BASE_URL}#{dollar_value}")
  end
end
