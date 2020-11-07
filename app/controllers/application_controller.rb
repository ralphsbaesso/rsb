class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  attr_reader :current_ac, :current_account_user

  before_action :set_current_account_user
  rescue_from Exception, with: :error_occurred

  private

  def set_current_account_user
    if current_user
      au = current_user.account_users.first
      @current_ac = au
      @current_account_user = au
    end
  end


  def build_facade
    Facade.new(account_user: @current_account_user)
  end

  def to_data(resource: nil, data: {}, errors: [], meta: {}, fields: false, **args)

    unless resource.nil?
      _resource = resource.page(page).per(per_page)
      if fields
        data = _resource.fields(*fields)
      else
        data = block_given? ? yield(_resource) : _resource
      end
      meta.merge!({
                    total_count: _resource.total_count,
                    count: _resource.count,
                    total_pages: _resource.total_pages,
                    current_page: _resource.current_page,
                    prev_page: _resource.prev_page,
                    next_page: _resource.next_page,
                    per_page: per_page
                  })
    end

    { data: data, errors: errors, meta: meta }.merge(args)
  end

  def error_occurred(exception)
    Event.add message: "Error in #{self.class.name} [#{exception.message}]",
              app: :application,
              account_user: current_account_user,
              user: current_user,
              type: :error,
              params: params_to_hash,
              error: exception.message,
              backtrace: exception.backtrace

    render json: to_data(errors: ['Ops, ocorreu um erro!']), status: :unprocessable_entity
  end


  def params_to_hash
    params.permit!.to_h.deep_symbolize_keys
  end

  def page
    params[:page]
  end

  def per_page
    @total_per_page = params[:per_page] || 10
  end

end
