class UsersController < Clearance::UsersController
  before_action :require_login, only: [:settings, :edit]

  public
  def settings
    @user = current_user
  end

  def edit
    @user = current_user
    @user.update(cash: params[:cash], venmo: params[:venmo], paypal: params[:paypal], cashapp: params[:cashapp], contact: params[:contact])
    redirect_to '/', :flash => { :success => "Settings saved!" }
  end

  private
  def user_from_params
    email = user_params.delete(:email)
    password = user_params.delete(:password)
    cash = user_params.delete(:cash)
    venmo = user_params.delete(:venmo)
    cashapp = user_params.delete(:cashapp)
    paypal = user_params.delete(:paypal)
    contact = user_params.delete(:contact)

    Clearance.configuration.user_model.new(user_params).tap do |user|
      user.email = email
      user.password = password
      user.cash = cash
      user.venmo = venmo
      user.cashapp = cashapp
      user.paypal = paypal
      user.contact = contact
    end
  end

  def user_params
    params[Clearance.configuration.user_parameter] || Hash.new
  end
end