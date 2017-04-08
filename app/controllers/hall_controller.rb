class HallController < ApplicationController
  def index
    @title = 'Александр Мансуров'
    @subtitle = 'фронтенд разработчик в Рокетбанке 🚀'

    @projects = Project.all
  end
end
