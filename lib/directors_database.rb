require 'yaml'

def directors_database
	rot13 = -> (s) { s.tr('A-Za-z', 'N-ZA-Mn-za-m') }
  @_db ||= YAML.load(rot13.call(File.open("directors_db").read.to_s))
end

require 'directors_database'

def movie_with_director_name(director_name, movie_data)
  { 
    :title => movie_data[:title],
    :worldwide_gross => movie_data[:worldwide_gross],
    :release_year => movie_data[:release_year],
    :studio => movie_data[:studio],
    :director_name => director_name
  }
end


def movies_with_director_key(name, movies_collection)
  result = []
  i = 0

  while i < movies_collection.length do
    movie_data = movies_collection[i]
    result << movie_with_director_name(name, movie_data)
    i += 1
  end

  result
end


def gross_per_studio(collection)
 
  result = {}
  i = 0

  while i < collection.length do
    movie = collection[i]

    if !result[movie[:studio]]
      result[movie[:studio]] = movie[:worldwide_gross]
    else
      result[movie[:studio]] += movie[:worldwide_gross]
    end
    i += 1
  end

  result
end

def movies_with_directors_set(source)
  

  i = 0
  a_o_a_movies_by_dir = []

  while i < source.length do
    dir_info_hash = source[i]
    director_name = dir_info_hash[:name]
    directors_movies = dir_info_hash[:movies]
    a_o_a_movies_by_dir << movies_with_director_key(director_name, directors_movies)
    i += 1
  end

  a_o_a_movies_by_dir
end
