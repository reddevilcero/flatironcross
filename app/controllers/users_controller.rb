class UsersController < ApplicationController

    get "/sign_up" do
        erb :sign_up
    end

    get "/login" do
        if logged_in?
            redirect "/users/index/:id"
        else
            erb :"/users/login"
        end
    end

    get "/logout" do
        logout!
    end

    post "/users/index/" do
        login(params[:email], params[:password])
        @current_user = User.find_by(email: session[:email])
        redirect "/users/index/#{@current_user.id}"
    end

    post "/users" do  # Missing error msg for email already being used
        if User.all.each { |x| x.email == params[:email]}
            redirect "/sign_up"
        else
            @user = User.new(email: params[:email], password: params[:password])
            if @user.save
                redirect "/login"
            else
                redirect "/sign_nup"
            end
        end
    end

    get "/users/index/:id" do
        @current_user = User.find_by(email: session[:email])
        erb :"/users/index"
    end

    post "/users/:id/form" do
        @current_user = User.find_by(email: session[:email])
        @detail = Detail.new
        @detail.full_name = params[:full_name]
        @detail.dob = params[:dob]
        @detail.gender = params[:gender]
        @detail.address = params[:address]
        @detail.phone_number = params[:phone_number]
        @detail.user_id = @current_user.id
        @detail.save
        redirect "/users/index/#{@current_user.id}"
    end

end