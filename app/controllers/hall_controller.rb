class HallController < ApplicationController
  def index
    @title = 'Александр Мансуров'
    @subtitle = 'фронтенд разработчик в&nbsp;Рокетбанке&nbsp;🚀'

    @projects = Project.all
  end
end
