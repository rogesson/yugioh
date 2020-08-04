dirs = [
  './source/rgss3/lib/*.rb',
  './source/rgss3/game_objecs/*.rb',
  './source/rgss3/modules/*.rb',
  './source/rgss3/scenes/*.rb',
  './source/rgss3/sprites/*.rb',
  './source/rgss3/windows/*.rb',
  './tools/*.rb',
  './source/*.rb'
]

dirs.each do |dir|
  # [TODO] Create a class to do it.
  Dir[dir].each do |file|
    file if file.include?('lib')
    class_name = file.split('/').last[0..-4]
    autoload(class_name, file)
  end
end
