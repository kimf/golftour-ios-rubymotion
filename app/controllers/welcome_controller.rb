class WelcomeController < UIViewController
  stylesheet :base

  layout :root do
    form = Formotion::Form.new({
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
        }],
      },{
        rows: [{
          title: "Login",
          type: :submit
        }]
      }]
    })

    form.on_submit do
      self.login
    end
  end

  def layoutDidLoad
    self.title = "Simple Golftour"
    registerButton = UIBarButtonItem.alloc.initWithTitle("Sign Up",
                                                           style:UIBarButtonItemStylePlain,
                                                           target:self,
                                                           action:'register')

    self.navigationItem.rightBarButtonItem = registerButton
  end

  def register
    @registerController = RegisterController.alloc.init
    self.navigationController.pushViewController(@registerController, animated:true)
  end

  def login
    headers = { 'Content-Type' => 'application/json' }
    data = BW::JSON.generate({ email: form.render[:email], password: form.render[:password] })

    SVProgressHUD.showWithStatus("Logging in", maskType:SVProgressHUDMaskTypeGradient)

    # BW::HTTP.post("#{App.delegate.server}/authenticate", { headers: headers, payload: data } ) do |response|
    #   if response.status_description.nil?
    #     App.alert(response.error_message)
    #   else
    #     if response.ok?
    #       json = BW::JSON.parse(response.body.to_s)
    #       App::Persistence['authToken'] = json['data']['auth_token']
    #       self.navigationController.dismissModalViewControllerAnimated(true)
    #       ScorecardsListController.controller.load_data
    #     elsif response.status_code.to_s =~ /40\d/
    #       App.alert("Login failed")
    #     else
    #       App.alert(response.to_s)
    #     end
    #   end
    #   SVProgressHUD.dismiss
    # end
  end
end