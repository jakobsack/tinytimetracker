namespace :gettext do
  def files_to_translate
    Dir.glob("{app,config,locale}/**/*.{rb,haml}") #lib folder deleted from gettext search
  end
end
