Teacup::Stylesheet.new :table do

  style :root,
    backgroundColor: "#d7dee6".to_color

  style :table,
    backgroundColor: "#d7dee6".to_color,
    separatorStyle: UITableViewCellSeparatorStyleNone

  style :cell,
    textColor: "#2b2c2e".to_color,
    detailTextLabel: {
      textColor: "#2b2c2e".to_color,
      font: UIFont.boldSystemFontOfSize(20)
    }

  style :selected,
    backgroundColor: "#1b8ad4".to_color

  style :bottom_line,
    width: '100%',
    height: 1,
    top: lambda { superview.bounds.size.height - 1 },
    backgroundColor: "#cccccc".to_color,
    autoresizingMask: UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth


  style :play_button,
    top: 440,
    left: 0,
    width: 320,
    height: 60,
    backgroundColor: "#68a15f".to_color,
    textColor: "#FFFFFF".to_color,
    title: "Starta Runda!",
    hidden: true
end
