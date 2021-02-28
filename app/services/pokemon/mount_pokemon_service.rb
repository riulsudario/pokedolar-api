class Pokemon::MountPokemonService < BusinessProcess::Base
  STEPS = 5

  needs :pokemon
  needs :dollar_obj

  steps :init_variables,
        :mount_abilities,
        :name,
        :photo,
        :stats,
        :max_base_stat,
        :mount_pokemon

  def call
    process_steps
    @pokemon
  end

  private

  def init_variables
    @abilities = []
    @stats = []
  end

  def mount_abilities
    @abilities = pokemon['abilities'].map do |ability|
      {
        name: ability['ability']['name'].humanize,
        url: ability['ability']['url'],
        hidden: ability['is_hidden'],
        slot: ability['slot']
      }
    end
  end

  def name
    @name = pokemon['name'].humanize
  end

  def photo
    @photo = pokemon['sprites']['other']['official-artwork']['front_default']
  end

  def stats
    @stats = pokemon['stats'].map do |stat|
      {
        name: stat['stat']['name'].humanize,
        base_stat: stat['base_stat']
      }
    end
  end

  def max_base_stat
    @max_base_stat = @stats.map { |d| d[:base_stat] }.max
  end

  def mount_pokemon
    @pokemon = {
      id: pokemon['id'],
      name: @name,
      abilities: @abilities,
      photo: @photo,
      chart: {
        stats: @stats,
        max_base_stat: @max_base_stat,
        step_size: @max_base_stat / STEPS
      },
      dollar: dollar_obj[:dollar]
    }
  end
end
