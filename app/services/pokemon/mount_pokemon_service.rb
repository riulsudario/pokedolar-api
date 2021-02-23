class Pokemon::MountPokemonService < BusinessProcess::Base
  needs :pokemon

  steps :init_variables,
        :mount_abilities,
        :name,
        :photo,
        :mount_pokemon

  def call
    process_steps
    @pokemon
  end

  private

  def init_variables
    @abilities = []
  end

  def mount_abilities
    @abilities = pokemon['abilities'].map do |ability|
      {
        name: ability['ability']['name'],
        url: ability['ability']['url'],
        hidden: ability['is_hidden'],
        slot: ability['slot']
      }
    end
  end

  def name
    @name = pokemon['name']
  end

  def photo
    @photo = pokemon['sprites']['other']['official-artwork']['front_default']
  end

  def mount_pokemon
    @pokemon = {
      name: @name,
      abilities: @abilities,
      photo: @photo
    }
  end
end
