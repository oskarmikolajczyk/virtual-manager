class SessionsController < ApplicationController
    skip_before_action :require_login, only: [:create, :new]

    def new
    end

    def create
        if auth_hash = request.env["omniauth.auth"]
            if @employee = Employee.find_or_create_by_omniauth(auth_hash)
                log_in @employee
                
                redirect_to @employee
            else
                flash.now[:danger] = "Email already exists."
                render :welcome
            end
        else #Normal Login
            @employee = Employee.find_by(:email => params[:sessions][:email].downcase)
            if @employee && @employee.authenticate(params[:sessions][:password])
                log_in @employee
                redirect_to @employee
            else
                flash.now[:danger] = "Invalid email or password, please try again."
                render :new
            end
        end
    end

    def destroy
        log_out
        redirect_to root_url
    end 
end