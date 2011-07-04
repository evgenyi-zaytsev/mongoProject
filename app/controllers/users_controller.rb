class UsersController < ApplicationController
	before_filter :authenticate, :only => [:index, :edit, :update]
	before_filter :correct_user, :only => [:edit, :update]
	before_filter :admin_user,   :only => :destroy

  # GET /users
  # GET /users.xml
  def index
    @users = User.paginate(:page => params[:page], :per_page => 30)
		@title = "All users"
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
    @title = @user.name

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
      format.json  { render :json => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
		@title = "Sign up"

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    #@user = User.find(params[:id])
		@title = "Edit user"
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    #respond_to do |format|
    #  if @user.save
    #    format.html { redirect_to(@user, :notice => 'User was successfully created.') }
    #    format.xml  { render :xml => @user, :status => :created, :location => @user }
    #  else
    #    format.html { render :action => "new" }
    #    format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
    #  end
    #end
    
    if @user.save
			sign_in @user
			flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign up"
			@user.password = ""
			@user.password_confirmation = ""
      render 'new'
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    #@user = User.find(params[:id])

		if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end

    #respond_to do |format|
    #  if @user.update_attributes(params[:user])
    #    format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
    #    format.xml  { head :ok }
    #  else
    #    format.html { render :action => "edit" }
    #    format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
    #  end
    #end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

	private

    def authenticate
      deny_access unless signed_in?
    end
		
		def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
		
		def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
