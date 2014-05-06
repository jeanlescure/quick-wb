def safe_require(gem_name)
  begin
    require gem_name
  rescue LoadError
    puts "[\e[31mERROR\e[0m] Unmet dependency! You need the '#{gem_name}' gem installed."
    puts "\e[32mSimply run:\e[0m gem install #{gem_name}"
    exit
  end
end