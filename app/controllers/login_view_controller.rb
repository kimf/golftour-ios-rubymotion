class LoginViewController < Formotion::FormController
  cattr_accessor :first_login
  self.first_login = true

  def init
    initWithForm(build_form)
    self.title = "Golftour - Login"
    @form.on_submit do |form|
      submit(form)
    end
    self
  end

  def viewDidLoad
    super
    return unless self.class.first_login

    if valid?
      submit(@form)
      self.class.first_login = false
    end
  end

  def submit(form)
    login_data = form.render

    Golftour.when_reachable do
      SVProgressHUD.showWithMaskType(SVProgressHUDMaskTypeClear)
      session = UserSession.new(login_data)
      session.login do |response, json|
        SVProgressHUD.dismiss
        if response.error_message
          UIAlertView.alert("Login failed", response.error_message)
        else
          if json.present?
            Player.current = Player.new(json)
            UIApplication.sharedApplication.delegate.window.rootViewController = ScorecardsViewController.alloc.init
          else
            UIAlertView.alert("Login failed", "Wrong username or password")
          end
        end
      end
    end
  end

private
  def build_form
    @form ||= Formotion::Form.persist({
      persist_as: :credentials,
      sections: [{
        rows: [{
          title: "Email",
          key: :email,
          placeholder: "me@mail.com",
          type: :email,
          auto_correction: :no,
          auto_capitalization: :none
        }, {
          title: "Password",
          key: :password,
          placeholder: "required",
          type: :string,
          secure: true
        }]
      }, {
        rows: [{
          title: "Login",
          type: :submit
        }]
      }]
    })
  end

  def valid?
    login_data = @form.render
    login_data[:email].present? && login_data[:password].present?
  end
end
