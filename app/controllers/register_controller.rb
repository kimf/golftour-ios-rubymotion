# class RegisterController < Formotion::FormController
#   stylesheet :base

#   def init
#     form = Formotion::Form.new({
#       sections: [{
#         rows: [{
#           title: "Email",
#           key: :email,
#           placeholder: "me@mail.com",
#           type: :email,
#           auto_correction: :no,
#           auto_capitalization: :none
#         }, {
#           title: "Name",
#           key: :name,
#           placeholder: "Whats your name",
#           type: :string,
#           auto_correction: :no,
#           auto_capitalization: :none
#         }, {
#           title: "Password",
#           key: :password,
#           placeholder: "required",
#           type: :string,
#           secure: true
#         }, {
#           title: "Confirm Password",
#           key: :password_confirmation,
#           placeholder: "required",
#           type: :string,
#           secure: true
#         }],
#       }, {
#         rows: [{title: "Register", type: :submit}]
#       }]
#     })
#     form.on_submit do
#       self.register
#     end
#     super.initWithForm(form)
#   end

#   def viewDidLoad
#     super

#     self.title = "Sign Up"
#   end

#   def register
#     headers = { 'Content-Type' => 'application/json' }
#     data = BW::JSON.generate({   email: form.render[:email],
#                                  name: form.render[:name],
#                                  password: form.render[:password],
#                                  password_confirmation: form.render[:password_confirmation] })


#     if form.render[:password] != form.render[:password_confirmation]
#       App.alert("Your password doesn't match confirmation, check again")
#     else
#       SVProgressHUD.showWithStatus("Registering new account...", maskType:SVProgressHUDMaskTypeGradient)
#       BW::HTTP.post("#{App.delegate.server}/signup", { headers: headers , payload: data } ) do |response|
#         if response.status_description.nil?
#           App.alert(response.error_message)
#         else
#           json = BW::JSON.parse(response.body.to_s)
#           if response.status_code == 200
#             App::Persistence['authToken'] = json['data']['auth_token']
#             @router.open("leaderboard", false)
#           else
#             App.alert(json['info'])
#           end
#         end
#         SVProgressHUD.dismiss
#       end
#     end
#   end
# end