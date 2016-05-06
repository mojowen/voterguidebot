def env_loader(env_file_path, rails_root='./')
  env_file = File.join(rails_root, env_file_path)
  File.open(env_file).each_line do |line|
    key, value = line.split('=').map(&:strip)
    ENV[key] = value
  end if File.exists?(env_file)
end

