class Pokemon::FetchPokeapiService < BusinessProcess::Base
  BASE_URL = 'https://pokeapi.co/api/v2/pokemon/'.freeze

  needs :dollar_obj

  steps :index,
        :mount_pokemon

  def call
    process_steps
    @pokemon_object
  end

  private

  def index
    response = RestClient.get("#{BASE_URL}#{dollar_obj[:pokemon_id]}")
    @pokemon = JSON.parse(response.body)
  end

  def mount_pokemon
    service = Pokemon::MountPokemonService.call(pokemon: @pokemon, dollar_obj: dollar_obj)

    @pokemon_object = service.result if service.success?
  end
end
