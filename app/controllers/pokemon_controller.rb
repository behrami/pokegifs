class PokemonController < ApplicationController
  def show
    pokemon_res = HTTParty.get("https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json")
    pokemon_body = JSON.parse(pokemon_res.body)

    input = params[:id]

    pokemon_body["pokemon"].each do |pokemon|
      if input.to_i == pokemon['id']
        @pokemon_id = pokemon['id']
        @pokemon_name = pokemon['name']
        @pokemon_type = pokemon['type']
      elsif input.to_i == 0
        if input.capitalize == pokemon['name']
          @pokemon_id = pokemon['id']
          @pokemon_name = pokemon['name']
          @pokemon_type = pokemon['type']
        end
      end
    end

    key = ENV['GIFY_KEY']
    gify_res = HTTParty.get("https://api.giphy.com/v1/gifs/search?api_key=#{key}&q=#{@pokemon_name}&rating=g")
    gify_body = JSON.parse(gify_res.body)
    @gify_url = gify_body["data"][0]["images"]["original"]["url"]

    respond_to do |format|
      format.html
      format.json {  render json: { "id": pokemon_id,
                                    "name": pokemon_name,
                                    "types": pokemon_type,
                                    "picture": gify_url}}
    end

  end
end
