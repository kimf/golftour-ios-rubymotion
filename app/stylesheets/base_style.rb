Teacup::Stylesheet.new(:base) do

  style :root,
    backgroundColor: "#d7dee6".to_color

  style :play_button,
    top: 440,
    left: 0,
    width: 320,
    height: 60,
    backgroundColor: "#68a15f".to_color,
    textColor: "#FFFFFF".to_color,
    title: "Starta Runda!",
    font: 'OpenSans-Bold'.uifont(20)

  style :cancel_button,
    top: 440,
    left: 0,
    width: 320,
    height: 60,
    backgroundColor: "#a14f45".to_color,
    textColor: "#FFFFFF".to_color,
    title: "Avbryt Runda!",
    font: 'OpenSans-Bold'.uifont(20)
end
