class Pokemon::FetchPokeapiService < BusinessProcess::Base
  BASE_URL = 'https://pokeapi.co/api/v2/pokemon/'.freeze

  needs :dollar_value

  steps :index,
        :mount_pokemon

  def call
    process_steps
    @pokemon_object
  end

  private

  def index
    response = RestClient.get("#{BASE_URL}#{dollar_value}")

    @pokemon = JSON.parse(response.body)
  end

  def mount_pokemon
    service = Pokemon::MountPokemonService.call(pokemon: @pokemon)

    @pokemon_object = service.result if service.success?
  end
end
