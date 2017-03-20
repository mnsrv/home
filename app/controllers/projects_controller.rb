class ProjectsController < ApplicationController

  http_basic_authenticate_with name: 'dhh', password: 'secret'

  def new
    @project = Project.new
    @title = 'Новый проект'
  end

  def edit
    @project = Project.find(params[:id])
    @title = 'Редактирование проекта'
    @subtitle = @project.title
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      redirect_to root_path
    else
      render 'new'
    end
  end

  def update
    @project = Project.find(params[:id])

    if @project.update(project_params)
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    redirect_to root_path
  end

  private
    def project_params
      params.require(:project).permit(:title, :link)
    end
end
