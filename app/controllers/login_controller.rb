class LoginController < Formotion::FormController
  stylesheet :base

  def init
    form = Formotion::Form.new({
      sections: [{
        rows: [{
          title: "Epost",
          key: :email,
          placeholder: "me@mail.se",
          type: :email,
          auto_correction: :no,
          auto_capitalization: :none
        }, {
          title: "Lösenord",
          key: :password,
          placeholder: "**********",
          type: :string,
          secure: true
        }],
      },{
        rows: [{
          title: "LOGGA IN",
          type: :submit
        }]
      }]
    })

    form.on_submit do
      self.login
    end
    super.initWithForm(form)
  end

  def viewDidLoad
    super
    self.title = "Logga in"
  end

  def login
    email     = form.render[:email]
    password  = form.render[:password]
    SVProgressHUD.showWithStatus("Loggar in", maskType:SVProgressHUDMaskTypeGradient)
    AFMotion::Client.shared.post("authenticate", email: email, password: password) do |result|
      if result.success?
        id = result.object["id"]
        name = result.object["name"]

        if !Player.where(:id).eq(id).first
          create_player(id, name)
        end

        App.delegate.login(result.object["auth_token"], id)
        SVProgressHUD.dismiss
      elsif result.failure?
        SVProgressHUD.dismiss
        App.alert("Kunde inte logga in...")
      end
    end
  end

  def create_player(id, name)
    Player.create(
      id: id,
      name: name,
      points: 0,
      rounds: 0,
      average_points: 0,
      hcp: 0,
      email: ""
    )
    Player.serialize_to_file
  end
end