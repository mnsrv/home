class HallController < ApplicationController
  def index
    @title = 'Александр Мансуров'
    @subtitle = 'фронтенд разработчик'

    @projects = Project.all
  end
end
