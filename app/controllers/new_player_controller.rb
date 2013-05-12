class NewPlayerController < Formotion::FormController
  stylesheet :base
  attr_accessor :player, :name, :email, :hcp

  layout :root do
    self.title = "New Course"
    closeButton = UIBarButtonItem.alloc.initWithTitle("Close", style: UIBarButtonItemStylePlain, target:self, action:'close')
    self.navigationItem.leftBarButtonItem = closeButton
  end

  def close
    navigationController.dismissViewControllerAnimated(true, completion: lambda{})
  end

  def init
    form = Formotion::Form.new({
      sections: [{
        rows: [{
          title: "Namn",
          key: :name,
          placeholder: "Förnamn Efternamn",
          type: :string
        }, {
          title: "Hcp",
          key: :hcp,
          placeholder: "14.2",
          type: :string
        },{
          title: "Epost",
          key: :email,
          placeholder: "namn@doman.se",
          type: :email,
          auto_correction: :no,
          auto_capitalization: :none
        }],
      },{
        rows: [{
          title: "Spara",
          type: :submit
        }]
      }]
    })

    form.on_submit do
      self.save
    end
    super.initWithForm(form)
  end

  def save
    name = form.render[:name]
    email = form.render[:email]
    hcp = form.render[:hcp]

    headers = { 'Content-Type' => 'application/json' }
    data = BW::JSON.generate({name:   name, email:  email, hcp: hcp})

    BW::HTTP.post("#{App.delegate.server}/players",
      { headers: headers, payload: data } ) do |response|
      if response.status_description.nil?
        App.alert(response.error_message)
      else
        json = BW::JSON.parse(response.body.to_s)
        if response.status_code == 200
          player = json["player"]
          Player.create(
            id: player["id"].to_i,
            name: player["name"],
            points: player["points"].to_i,
            rounds: player["rounds"].to_i,
            average_points: player["average_points"].to_i,
            hcp: player["hcp"],
            email: player["email"]
          )
          self.close
          PlayController.controller.reload_players
        else
          App.alert(json['info'])
        end
      end
      SVProgressHUD.dismiss
    end
  end
end