class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user!, only: [:edit, :update, :destroy]
  def new
    @post= Post.new
  end

  def index
    @posts = Post.all
  end
  

  def show
    @post= Post.find(params[:id])
  end

  def create
    @post= current_user.posts.build(post_params)
    if @post.save
      flash[:success]= "Post creado con exito"
      redirect_to posts_path(@post)
    else
      flash[:error]= @post.errors.full_messages
      render :new
    end
  end

  def update
    @post= Post.find(params[:id])
    if @post.user_id == current_user.id
      if @post.update(post_params)
        flash[:success]="El post fue actualizado!"
       redirect_to posts_path
      else
        flash[:error]="No se pudo actualizar el post."
         render :edit
      end
    else
      flash[:error]= "No tienes permiso para actualizar este post"
      redirect_to posts_path
    end

  end

  def edit
    @post= Post.find(params[:id])
  end

  def destroy
    @post= Post.find(params[:id])
    if @post.user_id == current_user.id
       @post.destroy
      flash[:success]= "El post ah sido eliminado!"
      redirect_to posts_path
    else
      flash[:error]= "No se pudo eliminar el post, no tienes permiso"
      redirect_to posts_path
    end
  end

  private

  def authorize_user!
    @post =Post.find(params[:id])
    unless @post.user_id == current_user.id
      flash[:error] = "No tienes permiso para editar o eliminar este post"
      redirect_to posts_path
    end
  end

  
  def post_params
    params.require(:post).permit(:image, :description)
  end

end
