LiquidApi.route("saltedge_callbacks") do |r|
  r.post "success" do
    data = JSON.parse(request.body.read)
    login_id = data["data"]["login_id"]
    saltedge_login = SaltedgeLogin.find_by(saltedge_id: login_id)
    if saltedge_login
      Services::UpdateSaltedgeLogin.new(saltedge_login).call
      unless saltedge_login.saltedge_accounts.any? || user.default_account
        service = Services::SelectSaltedgeAccount.new(saltedge_login)
        service.call
        if service.saltedge_account
          Services::LoadSaltedgeAccountTransactions.new(service.saltedge_account).call
        end
      end
    end
    [200, '']
  end

  r.post "failure" do
    [200, '']
  end
end
