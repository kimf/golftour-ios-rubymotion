class NewPlayerController < Formotion::FormController
  attr_accessor :player, :name, :email, :hcp

  layout :root do
    self.title = "New Player"
    closeButton = UIBarButtonItem.alloc.initWithTitle("Cancel", style: UIBarButtonItemStylePlain, target:self, action:'cancel')
    self.navigationItem.leftBarButtonItem = closeButton
  end

  def cancel
    App.delegate.router.pop
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

    AFMotion::Client.shared.post("players", name: name, email: email, hcp: hcp) do |result|
      if result.success?
        player = result.object["player"]
        Player.create(
          id: player["id"].to_i,
          name: player["name"],
          points: player["points"].to_i,
          rounds: player["rounds"].to_i,
          average_points: player["average_points"].to_i,
          hcp: player["hcp"],
          email: player["email"]
        )
        App.delegate.router.pop
      elsif result.failure?
        App.alert("Kunde inte spara...")
      end
    end
  end
end